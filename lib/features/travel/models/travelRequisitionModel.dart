class TravelRequisitionModel {
  final List<ResultItem> result;
  final List<TravelRequisitionRow> table1;

  TravelRequisitionModel({
    required this.result,
    required this.table1,
  });

  factory TravelRequisitionModel.fromJson(Map<String, dynamic> json) {
    return TravelRequisitionModel(
      result: (json['Result'] as List<dynamic>)
          .map((e) => ResultItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      table1: (json['Table1'] as List<dynamic>)
          .map((e) => TravelRequisitionRow.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
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
      statusId: json['StatusID'] as int,
      msg: json['MSG'] as String,
    );
  }
}

class TravelRequisitionRow {
  final int trId;
  final int trEmployeeCode;
  final String employeeName;
  final String trDestination;
  final String trLocation;
  final String trDepartureDate;
  final String trReturnDate;
  final String trStatus;

  TravelRequisitionRow({
    required this.trId,
    required this.trEmployeeCode,
    required this.employeeName,
    required this.trDestination,
    required this.trLocation,
    required this.trDepartureDate,
    required this.trReturnDate,
    required this.trStatus,
  });

  // ---------- SAFE PARSERS ----------
  static String _s(dynamic v) => v?.toString() ?? '';
  static int _i(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;

  factory TravelRequisitionRow.fromJson(Map<String, dynamic> json) {
    return TravelRequisitionRow(
      trId: _i(json['TR_ID']),
      trEmployeeCode: _i(json['TR_EmployeeCode']),

      // 🔥 API sends different keys sometimes
      employeeName: _s(
          json['EmployeeName'] ??
              json['Employeename'] ??
              json['employeeName']
      ),

      trDestination: _s(json['TR_Destination']),
      trLocation: _s(json['TR_Location']),
      trDepartureDate: _s(json['TR_Departuredate']),
      trReturnDate: _s(json['TR_ReturnDate']),

      // trim long padded spaces from SQL char fields
      trStatus: _s(json['TR_Status']).trim(),
    );
  }
}
