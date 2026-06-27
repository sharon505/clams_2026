import 'package:clams/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TravelRequisitionTextFieldViewModel extends ChangeNotifier {
  /// Dropdowns
  final List<String> destinationList = ["Domestic", "International"];
  final List<String> levelList = ["L1", "L2", "L3", "L4"];

  // Private selected + accessors
  String? _selectedDestination;
  String? _selectedLevel;

  String? get selectedDestination => _selectedDestination;
  String? get selectedLevel => _selectedLevel;

  set selectedDestination(String? value) {
    _selectedDestination = value;
    notifyListeners();
  }

  set selectedLevel(String? value) {
    _selectedLevel = value;
    notifyListeners();
  }

  final List<String> transportationModes = [
    "Bus",
    "Train",
    "Flight",
    "Car",
    "Bike",
    "Taxi",
    "Metro",
    "Ship",
  ];

  String? selectedTransportationMode;

  final List<String> accommodationList = [
    "Company Guest House",
    "Hotel",
    "Lodge",
    "Self Arrangement",
    "Relative's House",
    "No Accommodation",
  ];

  String? selectedAccommodation;

  /// Controllers
  final TextEditingController levelController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController travelLocationController = TextEditingController();
  final TextEditingController departureDateController = TextEditingController();
  final TextEditingController returnDateController = TextEditingController();
  final TextEditingController modeOfTransportationController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController estimatedKmController = TextEditingController();
  final TextEditingController accommodationController = TextEditingController();
  final TextEditingController purposeOfTravelController = TextEditingController();
  final TextEditingController crnController = TextEditingController();


  /// Getters
  String get level => levelController.text;
  String get destination => destinationController.text;
  String get travelLocation => travelLocationController.text;
  String get departureDate => departureDateController.text;
  String get returnDate => returnDateController.text;
  String get modeOfTransportation => modeOfTransportationController.text;
  String get duration => durationController.text;
  String get estimatedKm => estimatedKmController.text;
  String get accommodation => accommodationController.text;
  String get purposeOfTravel => purposeOfTravelController.text;

  /// Setters
  set level(String v) {
    levelController.text = v;
    notifyListeners();
  }

  set destination(String v) {
    destinationController.text = v;
    notifyListeners();
  }

  set travelLocation(String v) {
    travelLocationController.text = v;
    notifyListeners();
  }

  set departureDate(String v) {
    departureDateController.text = v;
    notifyListeners();
  }

  set returnDate(String v) {
    returnDateController.text = v;
    notifyListeners();
  }

  set modeOfTransportation(String v) {
    modeOfTransportationController.text = v;
    notifyListeners();
  }

  set duration(String v) {
    durationController.text = v;
    notifyListeners();
  }

  set estimatedKm(String v) {
    estimatedKmController.text = v;
    notifyListeners();
  }

  set accommodation(String v) {
    accommodationController.text = v;
    notifyListeners();
  }

  set purposeOfTravel(String v) {
    purposeOfTravelController.text = v;
    notifyListeners();
  }

  // ---------------------------------------------------------
  // DATE FORMAT FIXED HERE ✔✔✔
  // ---------------------------------------------------------

  final DateFormat _fmt = DateFormat('dd/MM/yyyy');   // ✅ UPDATED FORMAT
  DateTime? _dep; // parsed departure
  DateTime? _ret; // parsed return

  DateTime? _parse(String s) {
    if (s.trim().isEmpty) return null;
    try {
      return _fmt.parseStrict(s);
    } catch (_) {
      return null;
    }
  }

  /// Generic date picker
  Future<void> pickDate(BuildContext context, TextEditingController controller) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      controller.text = _fmt.format(picked);
      notifyListeners();
    }
  }

  /// Pick Departure Date
  Future<void> pickDepartureDate(BuildContext context) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _dep ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,          // Header & selected date
              onPrimary: AppColors.white,               // Header text
              surface: AppColors.white,                 // Dialog background
              onSurface: AppColors.textColor,           // Calendar text
            ),
            scaffoldBackgroundColor: AppColors.white,
            dialogTheme: DialogThemeData(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _dep = picked;
      departureDateController.text = _fmt.format(picked);

      // Ensure return date is valid
      _ret = _parse(returnDateController.text);
      if (_ret != null && _ret!.isBefore(_dep!)) {
        _ret = null;
        returnDateController.clear();
      }

      notifyListeners();
    }
  }

  /// Pick Return Date
  Future<void> pickReturnDate(BuildContext context) async {
    _dep = _parse(departureDateController.text);

    if (_dep == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select Departure Date first'),
        ),
      );
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: _ret ?? _dep!.add(const Duration(days: 1)),
      firstDate: _dep!,
      lastDate: DateTime(_dep!.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.textColor,
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _ret = picked;
      returnDateController.text = _fmt.format(picked);
      notifyListeners();
    }
  }

  /// Validate return >= departure
  String? validateDateOrder() {
    final d = _parse(departureDateController.text);
    final r = _parse(returnDateController.text);

    if (d == null || r == null) return null;
    if (r.isBefore(d)) return 'Return date must be on or after Departure date';

    return null;
  }

  /// Clear All
  void clearAll() {
    levelController.clear();
    destinationController.clear();
    travelLocationController.clear();
    departureDateController.clear();
    returnDateController.clear();
    modeOfTransportationController.clear();
    durationController.clear();
    estimatedKmController.clear();
    accommodationController.clear();
    purposeOfTravelController.clear();
    crnController.clear();

    _selectedDestination = null;
    _selectedLevel = null;
    _dep = null;
    _ret = null;

    notifyListeners();
  }

  @override
  void dispose() {
    levelController.dispose();
    destinationController.dispose();
    travelLocationController.dispose();
    departureDateController.dispose();
    returnDateController.dispose();
    modeOfTransportationController.dispose();
    durationController.dispose();
    estimatedKmController.dispose();
    accommodationController.dispose();
    purposeOfTravelController.dispose();
    crnController.dispose();
    super.dispose();
  }
}
