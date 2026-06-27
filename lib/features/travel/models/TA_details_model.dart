class TADetailsModel {
  final List<TADetailsResult> result;

  TADetailsModel({
    required this.result,
  });

  factory TADetailsModel.fromJson(Map<String, dynamic> json) {
    return TADetailsModel(
      result: (json['Result'] as List)
          .map((e) => TADetailsResult.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Result': result.map((e) => e.toJson()).toList(),
    };
  }
}

class TADetailsResult {
  final String trLevel;
  final String trDestination;
  final String trLocation;
  final DateTime trDepartureDate;
  final DateTime trReturnDate;
  final String trModeOfTransportation;
  final int trDuration;
  final String trEstimatedKm;
  final String trAccommodation;
  final String trPurposeOfTravel;

  TADetailsResult({
    required this.trLevel,
    required this.trDestination,
    required this.trLocation,
    required this.trDepartureDate,
    required this.trReturnDate,
    required this.trModeOfTransportation,
    required this.trDuration,
    required this.trEstimatedKm,
    required this.trAccommodation,
    required this.trPurposeOfTravel,
  });

  factory TADetailsResult.fromJson(Map<String, dynamic> json) {
    return TADetailsResult(
      trLevel: json['TR_Level'] ?? '',
      trDestination: json['TR_Destination'] ?? '',
      trLocation: json['TR_Location'] ?? '',
      trDepartureDate: DateTime.parse(json['TR_Departuredate']),
      trReturnDate: DateTime.parse(json['TR_ReturnDate']),
      trModeOfTransportation: json['TR_modeofTransportation'] ?? '',
      trDuration: json['TR_Duration'] ?? 0,
      trEstimatedKm: json['TR_EstimatedKm'] ?? '',
      trAccommodation: json['TR_Accommodation'] ?? '',
      trPurposeOfTravel: json['TR_PurposeofTravel'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TR_Level': trLevel,
      'TR_Destination': trDestination,
      'TR_Location': trLocation,
      'TR_Departuredate': trDepartureDate.toIso8601String(),
      'TR_ReturnDate': trReturnDate.toIso8601String(),
      'TR_modeofTransportation': trModeOfTransportation,
      'TR_Duration': trDuration,
      'TR_EstimatedKm': trEstimatedKm,
      'TR_Accommodation': trAccommodation,
      'TR_PurposeofTravel': trPurposeOfTravel,
    };
  }
}