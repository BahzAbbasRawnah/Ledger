import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ledger/core/constants/app_constants.dart';
import 'package:ledger/core/theme/app_theme.dart';
import 'package:ledger/presentation/screens/reports/report_footer.dart';
import 'package:ledger/presentation/screens/reports/report_header.dart';
import 'package:ledger/presentation/utils/snackbar_utils.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportBody extends StatelessWidget {
  final String reportTitle;
  final List<String> tableHeaderTitles; // Dynamic header titles
  final List<List<String>> tableData; // Dynamic table data
  final List<String> tableFooterData; // last row in the table
  final String fromDate;
  final String toDate;

  const ReportBody({
    super.key,
    required this.reportTitle,
    required this.tableHeaderTitles,
    required this.tableData,
    required this.tableFooterData,
    required this.fromDate,
    required this.toDate,
  });

  @override
  Widget build(BuildContext context) {
    print(tableData);
    return Scaffold(
      appBar: AppBar(
        title: Text(reportTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Header
              ReportHeader(),
              const Divider(height: 20),
              // Date and Title Row
              _buildTitleRow(context, fromDate, toDate),
              const SizedBox(height: 20),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildReportTable(context),
              ),
              // ),
              // Footer
              ReportFooter(),
            ],
          ),
        ),
      ),
    );
  }
  // Build the date and title row
  Widget _buildTitleRow(BuildContext context, String fromDate, String toDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Start Date
        _buildDateRow(
          icon: Icons.calendar_month,
          date: fromDate,
        ),

        // Report Title wrapped inside Expanded to handle long text
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              reportTitle,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
            ),
          ),
        ),

        // End Date
        _buildDateRow(
          icon: Icons.calendar_month,
          date: toDate,
        ),
      ],
    );
  }
  Widget _buildDateRow({
    required IconData icon,
    required String date,
  }) {
    return Row(
      children: [
        Icon(icon, size: 25),
        Text(date, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
  Widget _buildReportTable(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.black),
      children: [
        // Table Header
        TableRow(
          decoration: BoxDecoration(color: AppTheme.primaryColor),
          children: [
            _buildTableCell('No', isHeader: true),
            for (var title in tableHeaderTitles)
              _buildTableCell(title, isHeader: true),
          ],
        ),
        // Table Rows
        for (var i = 0; i < tableData.length; i++)
          TableRow(
            children: [
              _buildTableCell((i + 1).toString()),
              for (var cell in tableData[i]) _buildTableCell(cell),
            ],
          ),

          // Table Footer
          TableRow(
            decoration: BoxDecoration(color: AppTheme.primaryColor),
            children: [
              _buildTableCell('Total', isHeader: true),
              for (var cell in tableFooterData) _buildTableCell(cell),
            ],
          ),
      ],
    );
  }

  // Generate and print PDF report
  Future<void> generatePdf(BuildContext context) async {
    try {
      final pdf = pw.Document();

      // Load Arabic font
      final arabicFont =
          pw.Font.ttf(await rootBundle.load("assets/fonts/HacenTunisia.ttf"));

      // Load logo image
      final Uint8List imageBytes =
          (await rootBundle.load("assets/images/logo.png"))
              .buffer
              .asUint8List();

      // Convert to pw.MemoryImage for PDF
      final pw.MemoryImage pdfImage = pw.MemoryImage(imageBytes);

      // Define colors
      final pdfColor = PdfColor.fromInt(0xFF1F1F1F);

      // Set default font
      pdf.theme?.copyWith(
        defaultTextStyle: pw.TextStyle(font: arabicFont),
      );

      // Add page to PDF
      pdf.addPage(
        pw.Page(
          orientation: tableData.length > 6
              ? pw.PageOrientation.landscape
              : pw.PageOrientation.portrait,
          textDirection: pw.TextDirection.rtl,
          build: (pw.Context context) {
            return pw.Column(
              children: [
                // Header with business info and logo
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(AppConstants.prefBusinessName,
                            style: pw.TextStyle(
                              fontSize: 20.0,
                              fontWeight: pw.FontWeight.normal,
                              color: pdfColor,
                              font: arabicFont,
                            )),
                        pw.Text(AppConstants.prefBusinessLocation,
                            style: pw.TextStyle(
                              fontSize: 18.0,
                              fontWeight: pw.FontWeight.normal,
                              color: pdfColor,
                              font: arabicFont,
                            )),
                        pw.Text(AppConstants.prefBusinessPhone,
                            style: pw.TextStyle(
                              fontSize: 18.0,
                              fontWeight: pw.FontWeight.normal,
                              color: pdfColor,
                              font: arabicFont,
                            )),
                      ],
                    ),
                    pw.Image(pdfImage, width: 120, height: 120),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(AppConstants.prefBusinessName,
                            style: pw.TextStyle(
                              fontSize: 20.0,
                              fontWeight: pw.FontWeight.normal,
                              color: pdfColor,
                              font: arabicFont,
                            )),
                        pw.Text(AppConstants.prefBusinessLocation,
                            style: pw.TextStyle(
                              fontSize: 18.0,
                              fontWeight: pw.FontWeight.normal,
                              color: pdfColor,
                              font: arabicFont,
                            )),
                        pw.Text(AppConstants.prefBusinessPhone,
                            style: pw.TextStyle(
                              fontSize: 18.0,
                              fontWeight: pw.FontWeight.normal,
                              color: pdfColor,
                              font: arabicFont,
                            )),
                      ],
                    ),
                  ],
                ),

                // Report title
                pw.Text(reportTitle,
                    style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        font: arabicFont)),

                pw.SizedBox(height: 10),

                // Date range
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(children: [
                      pw.Text(' $fromDate ',
                          style: pw.TextStyle(font: arabicFont, fontSize: 16)),
                      pw.Text(' $toDate ',
                          style: pw.TextStyle(font: arabicFont, fontSize: 16)),
                    ]),
                    pw.Column(children: [
                      pw.Text(fromDate,
                          style: pw.TextStyle(font: arabicFont, fontSize: 16)),
                      pw.Text(toDate,
                          style: pw.TextStyle(font: arabicFont, fontSize: 16)),
                    ]),
                  ],
                ),

                pw.SizedBox(height: 10),

                // Table with data
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black),
                  columnWidths: {
                    0: const pw
                        .IntrinsicColumnWidth(), // Adjusts "No." column dynamically
                    for (var i = 1; i <= tableHeaderTitles.length; i++)
                      i: const pw
                          .IntrinsicColumnWidth(), // Adjusts each column based on content
                  },
                  children: [
                    // Table header
                    pw.TableRow(
                      children: [
                        for (var title in tableHeaderTitles
                            .reversed) // Reverse header order
                          _buildPdfTableCell(title,
                              isHeader: true, font: arabicFont),
                        _buildPdfTableCell('No.',
                            isHeader: true, font: arabicFont),
                      ],
                    ),
                    // Table rows
                    for (var i = 0; i < tableData.length; i++)
                      pw.TableRow(
                        children: [
                          for (var cell in tableData[i]
                              .reversed) // Reverse row data order
                            _buildPdfTableCell(cell, font: arabicFont),
                          _buildPdfTableCell((i + 1).toString(),
                              font: arabicFont),
                        ],
                      ),
                  ],
                ),
                // Table footer
                pw.Row(
                  children: [
                    for (var cell in tableFooterData.reversed)
                      _buildPdfTableCell(cell, font: arabicFont),
                    _buildPdfTableCell('Total', font: arabicFont),
                  ],
                ),

                pw.SizedBox(height: 20),

                // Footer
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('Generated by: ',
                        style: pw.TextStyle(font: arabicFont)),
                    pw.Text(AppConstants.appName,
                        style: pw.TextStyle(font: arabicFont)),
                  ],
                ),
              ],
            );
          },
        ),
      );

      // Print or share the PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      print('Error generating PDF: $e');
    }
  }

  // Build a table cell with consistent styling
  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
        textAlign: isHeader ? TextAlign.center : TextAlign.start,
      ),
    );
  }

  // Build a table cell for PDF with consistent styling
  pw.Widget _buildPdfTableCell(String text,
      {bool isHeader = false, required pw.Font font}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: pw.Text(text,
          style: pw.TextStyle(
            font: font,
            fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
          textAlign: isHeader ? pw.TextAlign.center : pw.TextAlign.start),
    );
  }
}
