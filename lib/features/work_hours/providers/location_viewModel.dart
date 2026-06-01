import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  // ---------------------------------------------------------------------------
  // STATE
  // ---------------------------------------------------------------------------

  String _locationName = 'Fetching location...';
  bool _isLoading = true;
  String? _error;

  Position? _lastPosition;
  DateTime? _lastUpdatedAt;

  Timer? _locationTimer;

  // ---------------------------------------------------------------------------
  // GETTERS
  // ---------------------------------------------------------------------------

  String get locationName => _locationName;

  bool get isLoading => _isLoading;

  String? get error => _error;

  DateTime? get lastUpdatedAt => _lastUpdatedAt;

  double? get latitude => _lastPosition?.latitude;

  double? get longitude => _lastPosition?.longitude;

  String get coordString {
    final lat = latitude;
    final lng = longitude;

    if (lat == null || lng == null) {
      return '';
    }

    return '$lat,$lng';
  }

  // ---------------------------------------------------------------------------
  // CONFIG
  // ---------------------------------------------------------------------------

  final Duration _staleAfter =
  const Duration(minutes: 5);

  final Duration _geocodeTimeout =
  const Duration(seconds: 15);

  final Duration _positionTimeout =
  const Duration(seconds: 20);

  // ---------------------------------------------------------------------------
  // CONSTRUCTOR
  // ---------------------------------------------------------------------------

  LocationProvider() {
    _init();

    _locationTimer = Timer.periodic(
      const Duration(minutes: 5),
          (_) => refresh(force: true),
    );
  }

  // ---------------------------------------------------------------------------
  // INITIAL LOAD
  // ---------------------------------------------------------------------------

  Future<void> _init() async {
    await _ensureServiceAndPermission();

    await _fastWarmupFromLastKnown();

    await refresh(force: true);
  }

  Future<void> getCurrentLocationName() async {
    await refresh(force: true);
  }

  // ---------------------------------------------------------------------------
  // REFRESH LOCATION
  // ---------------------------------------------------------------------------

  Future<void> refresh({
    bool force = false,
  }) async {
    if (!force &&
        _lastUpdatedAt != null &&
        _lastPosition != null) {
      final age = DateTime.now()
          .difference(_lastUpdatedAt!);

      if (age <= _staleAfter) {
        return;
      }
    }

    _setLoading(true);

    try {
      await _ensureServiceAndPermission();

      final position =
      await Geolocator.getCurrentPosition(
        desiredAccuracy:
        LocationAccuracy.high,
        timeLimit: _positionTimeout,
      );

      _lastPosition = position;
      _lastUpdatedAt = DateTime.now();

      final placemarks =
      await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).timeout(_geocodeTimeout);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        final locality =
            _nonEmpty(place.locality) ??
                _nonEmpty(
                  place.subAdministrativeArea,
                );

        final admin = _nonEmpty(
          place.administrativeArea,
        );

        final country =
        _nonEmpty(place.country);

        _locationName = [
          if (locality != null) locality,
          if (admin != null) admin,
          if (country != null) country,
        ].join(', ');
      } else {
        _locationName = 'Unknown place';
      }

      if (kDebugMode &&
          position.isMocked) {
        _locationName =
        '⚠️ Mocked: $_locationName';
      }

      _error = null;
    } on TimeoutException {
      _error =
      'Location request timed out';

      _locationName =
      'Location timeout';
    } on PermissionDeniedException {
      _error =
      'Location permission denied';

      _locationName =
      'Permission denied';
    } on LocationServiceDisabledException {
      _error =
      'Location service disabled';

      _locationName =
      'Location service disabled';
    } catch (e) {
      _error = e.toString();

      _locationName =
      'Error getting location';
    } finally {
      _setLoading(false);
    }
  }

  // ---------------------------------------------------------------------------
  // LAST KNOWN LOCATION
  // ---------------------------------------------------------------------------

  Future<void> _fastWarmupFromLastKnown() async {
    try {
      final lastKnown =
      await Geolocator
          .getLastKnownPosition();

      if (lastKnown == null) return;

      _lastPosition = lastKnown;
      _lastUpdatedAt = DateTime.now();

      try {
        final placemarks =
        await placemarkFromCoordinates(
          lastKnown.latitude,
          lastKnown.longitude,
        ).timeout(_geocodeTimeout);

        if (placemarks.isNotEmpty) {
          final place =
              placemarks.first;

          final locality =
              _nonEmpty(
                place.locality,
              ) ??
                  _nonEmpty(
                    place
                        .subAdministrativeArea,
                  );

          final admin = _nonEmpty(
            place.administrativeArea,
          );

          final country =
          _nonEmpty(place.country);

          _locationName = [
            if (locality != null)
              locality,
            if (admin != null)
              admin,
            if (country != null)
              country,
          ].join(', ');
        }
      } catch (_) {}

      _error = null;
      notifyListeners();
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // PERMISSION HANDLING
  // ---------------------------------------------------------------------------

  Future<void>
  _ensureServiceAndPermission() async {
    final serviceEnabled =
    await Geolocator
        .isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw LocationServiceDisabledException();
    }

    var permission =
    await Geolocator.checkPermission();

    if (permission ==
        LocationPermission.denied) {
      permission =
      await Geolocator.requestPermission();

      if (permission ==
          LocationPermission.denied) {
        throw PermissionDeniedException(
          'Location permission denied',
        );
      }
    }

    if (permission ==
        LocationPermission.deniedForever) {
      throw PermissionDeniedException(
        'Location permission permanently denied',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // SETTINGS HELPERS
  // ---------------------------------------------------------------------------

  Future<bool>
  openLocationSettings() async {
    return Geolocator
        .openLocationSettings();
  }

  Future<bool> openAppSettings() async {
    return Geolocator.openAppSettings();
  }

  void setLocationName(String name) {
    _locationName = name;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // PRIVATE HELPERS
  // ---------------------------------------------------------------------------

  void _setLoading(bool value) {
    if (_isLoading == value) return;

    _isLoading = value;
    notifyListeners();
  }

  String? _nonEmpty(String? value) {
    if (value == null) return null;

    final trimmed = value.trim();

    if (trimmed.isEmpty) return null;

    return trimmed;
  }

  // ---------------------------------------------------------------------------
  // DISPOSE
  // ---------------------------------------------------------------------------

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }
}

// -----------------------------------------------------------------------------
// CUSTOM EXCEPTIONS
// -----------------------------------------------------------------------------

class PermissionDeniedException
    implements Exception {
  final String message;

  PermissionDeniedException(
      this.message,
      );

  @override
  String toString() => message;
}

class LocationServiceDisabledException
    implements Exception {
  @override
  String toString() {
    return 'Location services are disabled.';
  }
}