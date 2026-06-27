// lib/features/travel_requisition/models/cancle_travel_model.dart
class CancelTravelModel {
  final List<ResultRow> result;
  final List<TableRowItem> table1;

  CancelTravelModel({
    required this.result,
    required this.table1,
  });

  factory CancelTravelModel.fromJson(Map<String, dynamic> json) {
    return CancelTravelModel(
      result: (json['Result'] as List<dynamic>)
          .map((e) => ResultRow.fromJson(e as Map<String, dynamic>))
          .toList(),
      table1: (json['Table1'] as List<dynamic>)
          .map((e) => TableRowItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// ✅ Add this getter so your ViewModel can check success
  bool get isOk {
    if (table1.isEmpty) return false;
    final code = table1.first.statusId;
    return code >= 200 && code < 300;
  }

  /// ✅ Add this getter so your ViewModel can show messages
  String get message {
    if (table1.isNotEmpty) return table1.first.msg;
    return 'Unknown response';
  }
}

class ResultRow {
  final int column1;
  ResultRow({required this.column1});

  factory ResultRow.fromJson(Map<String, dynamic> json) {
    return ResultRow(column1: json['Column1'] as int);
  }
}

class TableRowItem {
  final int statusId;
  final String msg;

  TableRowItem({required this.statusId, required this.msg});

  factory TableRowItem.fromJson(Map<String, dynamic> json) {
    return TableRowItem(
      statusId: json['StatusID'] as int,
      msg: (json['MSG'] as String).trim(),
    );
  }
}
