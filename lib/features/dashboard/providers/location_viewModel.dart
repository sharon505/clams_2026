// location_provider.dart
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  // ---- State ---------------------------------------------------------------
  String _locationName = 'Fetching location...';
  bool _isLoading = true;
  String? _error;

  Position? _lastPosition;
  DateTime? _lastUpdatedAt;

  // Expose coordinates
  double? get latitude => _lastPosition?.latitude;
  double? get longitude => _lastPosition?.longitude;

  // Public getters
  String get locationName => _locationName;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastUpdatedAt => _lastUpdatedAt;

  // Convenience: "lat,lng" or empty
  String get coordString {
    final lat = latitude, lng = longitude;
    return (lat != null && lng != null) ? '$lat,$lng' : '';
  }

  // Config
  final Duration _staleAfter = const Duration(minutes: 5);
  final Duration _geocodeTimeout = const Duration(seconds: 15);
  final Duration _positionTimeout = const Duration(seconds: 20);

  // Add this inside your LocationProvider class
  Future<void> getCurrentLocationName() async {
    // simply forward to refresh(force: true)
    return refresh(force: true);
  }


  LocationProvider() {
    // Kick off an initial fetch without blocking UI
    _init();
  }

  Future<void> _init() async {
    await _ensureServiceAndPermission();
    // Try cache/last known first for instant-ish UI
    await _fastWarmupFromLastKnown();
    // Then do a fresh precise fetch
    await refresh(force: true);
  }

  /// Force refresh from sensors + reverse geocode.
  /// If not [force], will reuse cached result if still "fresh".
  Future<void> refresh({bool force = false}) async {
    // If we have fresh data and not forcing, skip
    if (!force && _lastUpdatedAt != null) {
      final age = DateTime.now().difference(_lastUpdatedAt!);
      if (age <= _staleAfter && _lastPosition != null && _locationName.isNotEmpty) {
        return;
      }
    }

    _setLoading(true);

    try {
      await _ensureServiceAndPermission();

      // New position
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: _positionTimeout,
      );

      _lastPosition = pos;
      _lastUpdatedAt = DateTime.now();

      // Reverse geocode with timeout
      final placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      ).timeout(_geocodeTimeout);

      final place = placemarks.isNotEmpty ? placemarks.first : null;
      if (place != null) {
        // You can adjust fields as you like
        final locality = _nonEmpty(place.locality) ?? _nonEmpty(place.subAdministrativeArea);
        final admin = _nonEmpty(place.administrativeArea);
        final country = _nonEmpty(place.country);
        _locationName = [
          if (locality != null) locality,
          if (admin != null) admin,
          if (country != null) country,
        ].join(', ');
      } else {
        _locationName = 'Unknown place';
      }

      // Mark mocked location in debug (optional)
      if (kDebugMode && (pos.isMocked)) {
        _locationName = '⚠️ Mocked: $_locationName';
      }

      _error = null;
    } on TimeoutException {
      _error = 'Location timed out. Pull to refresh again.';
      _locationName = 'Location timeout';
    } on PermissionDeniedException {
      _error = 'Location permission denied.';
      _locationName = 'Location permission denied';
    } on LocationServiceDisabledException {
      _error = 'Location services are disabled.';
      _locationName = 'Location services are disabled.';
    } catch (e) {
      _error = 'Error getting location: $e';
      _locationName = 'Error getting location: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Attempts to use cached/last known position to quickly show something.
  Future<void> _fastWarmupFromLastKnown() async {
    try {
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) {
        _lastPosition = last;
        _lastUpdatedAt = DateTime.now();

        // Best-effort reverse geocode (no throw on timeout)
        try {
          final placemarks = await placemarkFromCoordinates(
            last.latitude,
            last.longitude,
          ).timeout(_geocodeTimeout);
          if (placemarks.isNotEmpty) {
            final p = placemarks.first;
            final locality = _nonEmpty(p.locality) ?? _nonEmpty(p.subAdministrativeArea);
            final admin = _nonEmpty(p.administrativeArea);
            final country = _nonEmpty(p.country);
            _locationName = [
              if (locality != null) locality,
              if (admin != null) admin,
              if (country != null) country,
            ].join(', ');
          } else {
            _locationName = 'Locating...';
          }
        } catch (_) {
          // Keep existing label; proper refresh() will update
        }

        _error = null;
        notifyListeners();
      }
    } catch (_) {
      // Ignore warmup errors; refresh() will handle
    }
  }

  /// Ensures services & permissions are OK; throws on failure to unify handling.
  Future<void> _ensureServiceAndPermission() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw LocationServiceDisabledException();
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw PermissionDeniedException('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw PermissionDeniedException(
        'Location permission permanently denied. Enable from app settings.',
      );
    }
  }

  // ---- Helpers -------------------------------------------------------------

  /// Opens OS location settings screen.
  Future<bool> openLocationSettings() async {
    return Geolocator.openLocationSettings();
  }

  /// Opens app settings (permissions) screen.
  Future<bool> openAppSettings() async {
    return Geolocator.openAppSettings();
  }

  /// Manually set a custom label (rarely needed, but handy for testing)
  void setLocationName(String name) {
    _locationName = name;
    notifyListeners();
  }

  // ---- Private -------------------------------------------------------------
  void _setLoading(bool v) {
    if (_isLoading == v) return;
    _isLoading = v;
    notifyListeners();
  }

  String? _nonEmpty(String? s) {
    if (s == null) return null;
    final t = s.trim();
    return t.isEmpty ? null : t;
  }
}

// Custom exceptions to unify catch branches.
// (Geolocator throws generic exceptions; we normalize them.)
class PermissionDeniedException implements Exception {
  final String message;
  PermissionDeniedException(this.message);
  @override
  String toString() => message;
}

class LocationServiceDisabledException implements Exception {
  @override
  String toString() => 'Location services are disabled.';
}
