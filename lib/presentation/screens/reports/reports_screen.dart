import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../bloc/transaction/transaction_state.dart';
import '../../widgets/custom_button.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _reportType = 'monthly'; // 'monthly', 'custom', 'detailed'
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedClientId;
  String _selectedCurrency = 'USD';

  @override
  void initState() {
    super.initState();

    // Set default dates for monthly report (current month)
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month + 1, 0); // Last day of month
  }

  void _generateReport() {
    if (_reportType == 'monthly') {
      final now = DateTime.now();

      context.read<TransactionBloc>().add(
            TransactionGenerateMonthlyReportEvent(
              year: now.year,
              month: now.month,
              clientId: _selectedClientId,
              currencyCode: _selectedCurrency,
            ),
          );
    } else if (_reportType == 'custom' || _reportType == 'detailed') {
      if (_startDate != null && _endDate != null) {
        context.read<TransactionBloc>().add(
              TransactionGenerateCustomReportEvent(
                startDate: _startDate!,
                endDate: _endDate!,
                clientId: _selectedClientId,
                currencyCode: _selectedCurrency,
              ),
            );
      }
    }
  }

  void _exportAsPdf() {
    // In a real app, we would generate and export a PDF
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).exportAsPdf),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _exportAsExcel() {
    // In a real app, we would generate and export an Excel file
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).exportAsExcel),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.reports),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report type selection
            Text(
              localizations.reportType,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: [
                ButtonSegment<String>(
                  value: 'monthly',
                  label: Text(localizations.monthly),
                  icon: const Icon(Icons.calendar_month),
                ),
                ButtonSegment<String>(
                  value: 'custom',
                  label: Text(localizations.custom),
                  icon: const Icon(Icons.date_range),
                ),
                ButtonSegment<String>(
                  value: 'detailed',
                  label: Text(localizations.detailed),
                  icon: const Icon(Icons.receipt_long),
                ),
              ],
              selected: {_reportType},
              onSelectionChanged: (Set<String> selection) {
                setState(() {
                  _reportType = selection.first;
                });
              },
            ),
            const SizedBox(height: 24),

            // Date range selection (for custom and detailed reports)
            if (_reportType == 'custom' || _reportType == 'detailed')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.dateRange,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _startDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );

                            if (date != null) {
                              setState(() {
                                _startDate = date;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: localizations.startDate,
                              border: const OutlineInputBorder(),
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              _startDate != null
                                  ? DateFormat.yMd().format(_startDate!)
                                  : '',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _endDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );

                            if (date != null) {
                              setState(() {
                                _endDate = date;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: localizations.endDate,
                              border: const OutlineInputBorder(),
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              _endDate != null
                                  ? DateFormat.yMd().format(_endDate!)
                                  : '',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // Client selection
            if (_reportType == 'detailed')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.selectClient,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // In a real app, we would show a dropdown with clients
                  // For now, we'll just use a placeholder
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedClientId,
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text(localizations.allClients),
                      ),
                      const DropdownMenuItem<String>(
                        value: 'client1',
                        child: Text('Client 1'),
                      ),
                      const DropdownMenuItem<String>(
                        value: 'client2',
                        child: Text('Client 2'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedClientId = value;
                      });
                    },
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // Currency selection
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.currency,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedCurrency,
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'USD',
                      child: Text('USD (\$)'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'EUR',
                      child: Text('EUR (€)'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'GBP',
                      child: Text('GBP (£)'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'SAR',
                      child: Text('SAR (﷼)'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCurrency = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Generate report button
            CustomButton(
              text: localizations.generateReport,
              icon: Icons.bar_chart,
              onPressed: _generateReport,
            ),
            const SizedBox(height: 24),

            // Report results
            Expanded(
              child: BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  if (state is TransactionLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TransactionReportGeneratedState) {
                    final reportData = state.reportData;
                    final transactions = reportData['transactions'] as List;
                    final totalIncoming = reportData['totalIncoming'] as double;
                    final totalOutgoing = reportData['totalOutgoing'] as double;
                    final balance = reportData['balance'] as double;

                    if (transactions.isEmpty) {
                      return Center(
                        child: Text(localizations.noReportData),
                      );
                    }

                    return Column(
                      children: [
                        // Summary cards
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        localizations.totalIncoming,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '$_selectedCurrency ${totalIncoming.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.successColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        localizations.totalOutgoing,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '$_selectedCurrency ${totalOutgoing.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.errorColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Text(
                                  localizations.balance,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '$_selectedCurrency ${balance.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: balance >= 0
                                        ? AppTheme.successColor
                                        : AppTheme.errorColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Export buttons
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: localizations.exportAsPdf,
                                icon: Icons.picture_as_pdf,
                                isOutlined: true,
                                onPressed: _exportAsPdf,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomButton(
                                text: localizations.exportAsExcel,
                                icon: Icons.table_chart,
                                isOutlined: true,
                                onPressed: _exportAsExcel,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.bar_chart,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Generate a report to see results',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
