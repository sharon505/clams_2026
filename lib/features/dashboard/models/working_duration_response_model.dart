class WorkingDurationResponse {
  final List<ResultItem> result;
  final List<WorkingDurationData> data;

  WorkingDurationResponse({
    required this.result,
    required this.data,
  });

  factory WorkingDurationResponse.fromJson(Map<String, dynamic> json) {
    return WorkingDurationResponse(
      result: (json['Result'] as List? ?? [])
          .map((e) => ResultItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      data: (json['Data'] as List? ?? [])
          .map((e) => WorkingDurationData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'Result': result.map((e) => e.toJson()).toList(),
    'Data': data.map((e) => e.toJson()).toList(),
  };
}

class ResultItem {
  final int statusId;
  final String msg;

  ResultItem({
    required this.statusId,
    required this.msg,
  });

  factory ResultItem.fromJson(Map<String, dynamic> json) {
    return ResultItem(
      statusId: _asInt(json['StatusID']),
      msg: (json['MSG'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'StatusID': statusId,
    'MSG': msg,
  };
}

class WorkingDurationData {
  /// Example: "2025-12-12T09:15:36"
  final DateTime? firstPunch;

  /// Example: "2025-12-12T11:37:46.683"
  final DateTime? lastPunch;

  /// Example: 8530
  final int totalSeconds;

  /// Example: "0 days 2 hours 22 minutes 10 seconds"
  final String durationFormatted;

  WorkingDurationData({
    required this.firstPunch,
    required this.lastPunch,
    required this.totalSeconds,
    required this.durationFormatted,
  });

  factory WorkingDurationData.fromJson(Map<String, dynamic> json) {
    return WorkingDurationData(
      firstPunch: _asDateTimeNullable(json['FirstPunch']),
      lastPunch: _asDateTimeNullable(json['LastPunch']),
      totalSeconds: _asInt(json['TotalSeconds']),
      durationFormatted: (json['DurationFormatted'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'FirstPunch': firstPunch?.toIso8601String(),
    'LastPunch': lastPunch?.toIso8601String(),
    'TotalSeconds': totalSeconds,
    'DurationFormatted': durationFormatted,
  };

  /// Convenient computed value
  Duration get duration => Duration(seconds: totalSeconds);
}

// -------------------------
// Safe parsing helpers
// -------------------------
int _asInt(dynamic v) {
  if (v is int) return v;
  if (v is double) return v.toInt();
  return int.tryParse(v?.toString() ?? '') ?? 0;
}

DateTime? _asDateTimeNullable(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  if (s.isEmpty) return null;
  return DateTime.tryParse(s);
}
