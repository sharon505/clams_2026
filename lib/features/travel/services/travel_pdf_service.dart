import 'dart:io';
import 'package:clams/network/app_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/get_emp_travel_details_model.dart';

class TravelPdfService {

  /// ✅ FIXED → must be static
  static String formatDate(String? date) {
    try {
      if (date == null || date.isEmpty) return "-";
      final parsed = DateTime.parse(date);
      return DateFormat('dd MMMM yyyy').format(parsed);
    } catch (_) {
      return date ?? "-";
    }
  }

  /// ---------------- WATERMARK ----------------
  static Future<pw.MemoryImage?> _loadWatermark() async {
    try {
      final bytes = await rootBundle.load('assets/icons/boche (1).jpg');
      return pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (e) {
      print("⚠️ Watermark not found");
      return null;
    }
  }

  /// ---------------- COMMON CELL ----------------
  static pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.TableRow _row(String l1, String v1, String l2, String v2) {
    return pw.TableRow(
      children: [
        _cell(l1, bold: true),
        _cell(v1),
        _cell(l2, bold: true),
        _cell(v2),
      ],
    );
  }

  /// ---------------- GENERATE PDF ----------------
  static Future<pw.Document> generatePdf(
      TravelResult data,
      List<TravelExtension> extensions,
      String generatedBy,
      ) async {

    final pdf = pw.Document();
    final watermark = await _loadWatermark();
    final date = DateTime.now();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),

        build: (context) {
          return pw.Stack(
            children: [

              /// WATERMARK
              if (watermark != null)
                pw.Positioned.fill(
                  child: pw.Center(
                    child: pw.Opacity(
                      opacity: 0.08,
                      child: pw.Transform.rotate(
                        angle: -0.4,
                        child: pw.Image(watermark, width: 250),
                      ),
                    ),
                  ),
                ),

              /// CONTENT
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [

                  /// HEADER
                  pw.Row(
                    children: [
                      if (watermark != null)
                        pw.Container(width: 40, height: 40, child: pw.Image(watermark)),

                      pw.SizedBox(width: 10),

                      pw.Expanded(
                        child: pw.Center(
                          child: pw.Text(
                            "EMPLOYEE TRAVEL REQUISITION",
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 12),

                  /// BASIC DETAILS
                  pw.Table(
                    border: pw.TableBorder.all(width: 0.5),
                    columnWidths: const {
                      0: pw.FlexColumnWidth(2),
                      1: pw.FlexColumnWidth(3),
                      2: pw.FlexColumnWidth(2),
                      3: pw.FlexColumnWidth(3),
                    },
                    children: [
                      _row("Name", data.employeeName, "Designation", data.designation),
                      _row("Employee Code", data.employeeCode.toString(), "Department", data.departmentName),
                      _row("Reporting", data.reportingTo, "Level", data.level),
                      _row("Destination", data.destination, "Date", formatDate(data.departureDate)),
                    ],
                  ),

                  pw.SizedBox(height: 10),

                  /// LOCATION
                  pw.Text("I. Travel Location:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 7),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(6),
                    decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)),
                    child: pw.Text(data.location),
                  ),

                  pw.SizedBox(height: 10),

                  /// PURPOSE
                  pw.Text("II. Purpose of Travel:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 7),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(6),
                    decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)),
                    child: pw.Text(data.purpose),
                  ),

                  pw.SizedBox(height: 10),

                  /// DETAILS TABLE
                  pw.Table(
                    border: pw.TableBorder.all(width: 0.5),
                    children: [
                      pw.TableRow(children: [_cell("Departure Date", bold: true), _cell(formatDate(data.departureDate))]),
                      pw.TableRow(children: [_cell("Return Date", bold: true), _cell(formatDate(data.returnDate))]),
                      pw.TableRow(children: [_cell("Transport", bold: true), _cell(data.modeOfTransportation)]),
                      pw.TableRow(children: [_cell("Duration", bold: true), _cell("${data.duration} days")]),
                      pw.TableRow(children: [_cell("Estimated KM", bold: true), _cell(data.estimatedKm)]),
                      pw.TableRow(children: [_cell("Accommodation", bold: true), _cell(data.accommodation)]),
                    ],
                  ),

                  pw.SizedBox(height: 10),

                  /// APPROVED DATE
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text("Approved Date: ${formatDate(data.approvedDate)}"),
                  ),

                  pw.SizedBox(height: 10),

                  /// APPROVED BY
                  pw.Text("III. Approved by:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 7),
                  pw.Table(
                    border: pw.TableBorder.all(width: 0.5),
                    children: [
                      pw.TableRow(children: [
                        _cell("Name", bold: true),
                        _cell(data.reportingTo),
                        _cell("Designation", bold: true),
                        _cell(data.rpDesignation),
                      ])
                    ],
                  ),

                  pw.SizedBox(height: 10),

                  /// CRN NUMBER
                  pw.Table(
                    border: pw.TableBorder.all(width: 0.5),
                    columnWidths: const {
                      0: pw.FlexColumnWidth(2),
                      1: pw.FlexColumnWidth(6),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          _cell("CRN Number", bold: true),
                          _cell(data.crnNumber),
                        ],
                      ),
                    ],
                  ),

                  /// EXTENSIONS
                  if (extensions.isNotEmpty) ...[
                    pw.SizedBox(height: 12),
                    pw.Text("Extensions", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 7),
                    pw.Table(
                      border: pw.TableBorder.all(width: 0.5),
                      children: [
                        pw.TableRow(children: [
                          _cell("Reason", bold: true),
                          _cell("Days", bold: true),
                          _cell("Date", bold: true),
                        ]),
                        ...extensions.map((e) => pw.TableRow(children: [
                          _cell(e.reason),
                          _cell(e.extendedDays.toString()),
                          _cell(formatDate(e.extendedDate)),
                        ])),
                      ],
                    ),
                  ],

                  pw.SizedBox(height: 12),

                  /// GENERATED INFO
                  pw.Text(
                    "Generated by $generatedBy | CLAMS ${AppUrls.version} | ${DateFormat('dd MMM yyyy, hh:mm a').format(date)}",
                    style: pw.TextStyle(fontSize: 7),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  static Future<File> savePdf(pw.Document pdf, String fileName) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<void> openPdf(
      TravelResult data,
      List<TravelExtension> extensions,
      BuildContext context,
      String generatedBy,
      ) async {

    final pdf = await generatePdf(data, extensions, generatedBy);

    final file = await savePdf(pdf, "Travel_${data.trId}.pdf");

    final result = await OpenFilex.open(file.path);

    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
    }
  }
}