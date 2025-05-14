import 'package:flutter/material.dart';
import 'package:ledger/presentation/screens/reports/report_body.dart';
import 'package:ledger/presentation/screens/reports/report_footer.dart';
import 'package:ledger/presentation/screens/reports/report_header.dart';
import 'package:ledger/presentation/utils/snackbar_utils.dart';

class ReportPreview extends StatelessWidget {
  final String reportTitle;
  final List<String> tableHeaderTitles; // Dynamic header titles
  final List<List<String>> tableData; // Dynamic table data
  final List<String> tableFooterData; // last row in the table
  final String fromDate;
  final String toDate;

  const ReportPreview({
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
              // Footer
              ReportFooter(),
            ],
          ),
        ),
      ),
      // Floating Action Button for Printing
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _printReport(context);
        },
        tooltip: 'Print Report',
        child: const Icon(Icons.print),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Generate and print PDF report
  Future<void> _printReport(BuildContext context) async {
    try {
      // Create a ReportBody instance to use its generatePdf method
      final reportBody = ReportBody(
        reportTitle: reportTitle,
        tableHeaderTitles: tableHeaderTitles,
        tableData: tableData,
        tableFooterData: tableFooterData,
        fromDate: fromDate,
        toDate: toDate,
      );

      // Generate and print the PDF
      await reportBody.generatePdf(context);
    } catch (e) {
      SnackBarUtils.showErrorSnackBar(
        context,
        message: 'Error generating PDF: $e',
      );
    }
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

  // Build a date row with icon and dates
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

  // Build the report table
  Widget _buildReportTable(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.black),
      columnWidths: _generateColumnWidths(tableHeaderTitles.length),
      children: [
        // Table Header
        TableRow(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
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
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            children: [
              _buildTableCell('Total', isHeader: true),
              for (var cell in tableFooterData) _buildTableCell(cell),
            ],
          ),
      ],
    );
  }

// Generate dynamic column widths
  Map<int, TableColumnWidth>? _generateColumnWidths(int columnCount) {
    final columnWidths = <int, TableColumnWidth>{
      0: const IntrinsicColumnWidth(), // Adjusts to content size for "No." column
    };

    for (var i = 1; i <= columnCount; i++) {
      columnWidths[i] =
          const IntrinsicColumnWidth(); // Adjusts dynamically to content
    }

    return columnWidths;
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
}
