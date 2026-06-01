import 'dart:convert';
import 'dart:typed_data';

class PunchResponseModel {
  final List<PunchDayLog> result;

  PunchResponseModel({required this.result});

  factory PunchResponseModel.fromJson(Map<String, dynamic> json) {
    return PunchResponseModel(
      result: (json['Result'] as List? ?? [])
          .whereType<Map>()
          .map((e) => PunchDayLog.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'Result': result.map((e) => e.toJson()).toList(),
  };
}

class PunchPhoto {
  final String? fileName;
  final String? fileContent; // base64
  final String? fileExtention;

  const PunchPhoto({
    this.fileName,
    this.fileContent,
    this.fileExtention,
  });

  bool get hasContent => (fileContent ?? '').trim().isNotEmpty;

  Uint8List? get bytes {
    final b64 = (fileContent ?? '').trim();
    if (b64.isEmpty) return null;
    try {
      return base64Decode(b64);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
    'File_Name': fileName,
    'File_Content': fileContent,
    'File_Extention': fileExtention,
  };
}

class PunchDayLog {
  final int employeeCode;
  final String punchDate; // "2025-12-18"

  /// ✅ NEVER NULL (fixes spread issues)
  final List<PunchingTime> punchingTimes;

  /// ✅ NEW: multiple photos (IN + OUT)
  final List<PunchPhoto> photos;

  PunchDayLog({
    required this.employeeCode,
    required this.punchDate,
    required this.punchingTimes,
    this.photos = const [],
  });

  /// Backward compatible helpers (first photo fields)
  String? get fileName => photos.isNotEmpty ? photos.first.fileName : null;
  String? get fileContent => photos.isNotEmpty ? photos.first.fileContent : null;
  String? get fileExtention =>
      photos.isNotEmpty ? photos.first.fileExtention : null;

  factory PunchDayLog.fromJson(Map<String, dynamic> json) {
    final raw = json['PunchingTime'];

    List decodedList = [];
    if (raw is String && raw.trim().isNotEmpty) {
      try {
        decodedList = jsonDecode(raw) as List;
      } catch (_) {
        decodedList = [];
      }
    } else if (raw is List) {
      decodedList = raw;
    }

    // ✅ each row can contain 0/1 photo -> we store into photos list
    final photo = PunchPhoto(
      fileName: json['File_Name']?.toString(),
      fileContent: json['File_Content']?.toString(),
      fileExtention: json['File_Extention']?.toString(),
    );

    final photos = <PunchPhoto>[];
    if (photo.hasContent) photos.add(photo);

    return PunchDayLog(
      employeeCode: _asInt(json['EmployeeCode']),
      punchDate: (json['PunchDate'] ?? '').toString(),
      punchingTimes: decodedList
          .whereType<Map>()
          .map((e) => PunchingTime.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      photos: photos,
    );
  }

  Map<String, dynamic> toJson() => {
    'EmployeeCode': employeeCode,
    'PunchDate': punchDate,
    'PunchingTime': jsonEncode(punchingTimes.map((e) => e.toJson()).toList()),
    // keep first photo fields for API compatibility (optional)
    'File_Name': fileName,
    'File_Content': fileContent,
    'File_Extention': fileExtention,
  };

  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}

class PunchingTime {
  final String time;
  final String punchType;
  final String location;
  final int lateCount;

  PunchingTime({
    required this.time,
    required this.punchType,
    required this.location,
    required this.lateCount,
  });

  factory PunchingTime.fromJson(Map<String, dynamic> json) {
    return PunchingTime(
      time: (json['Time'] ?? '').toString(),
      punchType: (json['PunchType'] ?? '').toString(),
      location: (json['Location'] ?? '').toString(),
      lateCount: _asInt(json['latecount']),
    );
  }

  Map<String, dynamic> toJson() => {
    'Time': time,
    'PunchType': punchType,
    'Location': location,
    'latecount': lateCount,
  };

  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}
