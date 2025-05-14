import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger/core/constants/app_constants.dart';
import 'package:ledger/core/localization/app_localizations.dart';
import 'package:ledger/core/utils/data_utils.dart';
import 'package:ledger/data/models/client_model.dart';
import 'package:ledger/data/models/transaction_model.dart';
import 'package:ledger/presentation/bloc/client/client_bloc.dart';
import 'package:ledger/presentation/bloc/client/client_event.dart';
import 'package:ledger/presentation/bloc/client/client_state.dart';
import 'package:ledger/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:ledger/presentation/screens/reports/report_preview.dart';
import 'package:ledger/presentation/utils/snackbar_utils.dart';
import 'package:ledger/presentation/widgets/custom_button.dart';

/// Main screen for generating different types of reports
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // Selected report type
  String _selectedReportType = 'client';

  // Date range for reports
  DateTime? _startDate;
  DateTime? _endDate;

  // Selected client ID (if applicable)
  String? _selectedClientId;

  // Selected currency (if applicable)
  String _selectedCurrency = 'YER';

  // List of clients
  List<ClientModel> _clients = [];

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  void _loadClients() {
    // Load clients using BLoC
    context.read<ClientBloc>().add(const ClientLoadAllEvent());
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.reports),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report Type Selection
            Text(
              localization.reportType,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildReportTypeSelector(context),
            const SizedBox(height: 24),

            // Date Range Selection
            Text(
              localization.dateRange,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildDateRangeSelector(context),
            const SizedBox(height: 24),

            // Additional Filters (based on report type)
            if (_selectedReportType == 'client') _buildClientSelector(context),

            if (_selectedReportType != 'SingleTransaction')
              _buildCurrencySelector(context),

            const SizedBox(height: 32),

            // Generate Report Button
            Center(
              child: CustomButton(
                text: localization.generateReport,
                onPressed: () => _generateReport(context),
                widthPercentage: 70, // 70% of screen width
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build report type selector
  Widget _buildReportTypeSelector(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
             RadioListTile<String>(
              title: Text(localization.clientReport),
              value: 'AllClients',
              groupValue: _selectedReportType,
              onChanged: (value) {
                setState(() {
                  _selectedReportType = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Text(localization.clientReport),
              value: 'client',
              groupValue: _selectedReportType,
              onChanged: (value) {
                setState(() {
                  _selectedReportType = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Text(localization.transactionReport),
              value: 'SingleTransaction',
              groupValue: _selectedReportType,
              onChanged: (value) {
                setState(() {
                  _selectedReportType = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Text(localization.currencyReport),
              value: 'SingleCurrency',
              groupValue: _selectedReportType,
              onChanged: (value) {
                setState(() {
                  _selectedReportType = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // Build date range selector
  Widget _buildDateRangeSelector(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(localization.startDate),
                    subtitle: Text(_startDate != null
                        ? _formatDate(_startDate!)
                        : localization.notSelected),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context, true),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(localization.endDate),
                    subtitle: Text(_endDate != null
                        ? _formatDate(_endDate!)
                        : localization.notSelected),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context, false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build client selector
  Widget _buildClientSelector(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return BlocBuilder<ClientBloc, ClientState>(
      builder: (context, state) {
        if (state is ClientLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ClientLoadedState) {
          _clients = state.clients;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.selectClient,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: localization.client,
                      border: const OutlineInputBorder(),
                    ),
                    value: _selectedClientId,
                    items: _clients.map((client) {
                      return DropdownMenuItem<String>(
                        value: client.id,
                        child: Text(client.name ?? client.phoneNumber),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedClientId = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        } else if (state is ClientErrorState) {
          return Center(
            child: Text('Error: ${state.message}'),
          );
        } else {
          return const Center(
            child: Text('No clients available'),
          );
        }
      },
    );
  }

  // Build currency selector
  Widget _buildCurrencySelector(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.selectCurrency,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: localization.currency,
                border: const OutlineInputBorder(),
              ),
              value: _selectedCurrency,
              items: AppConstants.supportedCurrencies.map((currency) {
                return DropdownMenuItem<String>(
                  value: currency['code'] as String,
                  child: Text(
                      '${currency['code']} (${currency['symbol']}) - ${currency['name']}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // Format date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Select date from date picker
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // Generate report based on selected options
  void _generateReport(BuildContext context) {
    final localization = AppLocalizations.of(context);

    try {
      // Get repositories from BLoC
      final clientRepository = context.read<ClientBloc>().clientRepository;
      final transactionRepository =
          context.read<TransactionBloc>().transactionRepository;

      // Prepare report data based on selected type
      String reportTitle;
      List<String> tableHeaders;
      List<String> tableFooterData=[];
      List<List<String>> tableData = [];

      switch (_selectedReportType) {
        case 'AllClients':
          // Get all clients with financial data for the selected currency
          final clients = DataUtils.getAllClientsWithFinancialData(
            clientRepository,
            transactionRepository,
            currencyCode: _selectedCurrency,
          );

          // Set report title and table headers
          reportTitle = localization.allClients;
          tableHeaders = [
            localization.client,
            localization.totalCredit,
            localization.totalDebit,
            localization.balance,
          ];

          // Prepare report data
          for (final client in clients) {
            final sumCredit = client.sumCredit ?? 0.0;
            final sumDebit = client.sumDebit ?? 0.0;
            final balance = client.balance;

            tableData.add([
              client.name ?? client.phoneNumber,
              sumCredit.toString(),
              sumDebit.toString(),
              balance.toString(),
            ]);
          }
          tableFooterData = [
            'Total',
            '',
            '',
           '',
          ];


          
          break;




        case 'client':
          // Check if client is selected
          if (_selectedClientId == null) {
            SnackBarUtils.showErrorSnackBar(
              context,
              message: 'Please select a client',
            );
            return;
          }

          // Get client details
          final client = clientRepository.getClientById(_selectedClientId!);
          if (client == null) {
            SnackBarUtils.showErrorSnackBar(
              context,
              message: 'Client not found',
            );
            return;
          }

          // Get client transactions
          List<TransactionModel> transactions = DataUtils.getClientTransactions(
            transactionRepository,
            client.id,
            currencyCode: _selectedCurrency,
            startDate: _startDate,
            endDate: _endDate,
          );

          // Sort transactions by date
          transactions = DataUtils.sortTransactionsByDate(transactions);

          // Set report title and table headers
          reportTitle =
              '${localization.clientReport} / ${client.name ?? client.phoneNumber}';
          tableHeaders = [
            localization.date,
            localization.Credit,
            localization.Debit,
            localization.currency,
            localization.notes,
          ];

          // Prepare report data
          for (final transaction in transactions) {
            final creditAmount =
                transaction.type == AppConstants.transactionTypeCredit
                    ? transaction.amount.toString()
                    : ' ';
            final debitAmount =
                transaction.type == AppConstants.transactionTypeDebit
                    ? transaction.amount.toString()
                    : ' ';

            tableData.add([
              DataUtils.formatDate(transaction.date),
              creditAmount,
              debitAmount,
              transaction.currency,
              transaction.notes ?? '',
            ]);
            tableFooterData = [
              _formatDate(DateTime.now()),
              DataUtils.calculateSumCredit(transactions).toString(),
              DataUtils.calculateSumDebit(transactions).toString(),
              DataUtils.calculateBalance(transactions).toString(),
              _selectedCurrency
            ];
          }
          break;

        case 'SingleTransaction':
          // Get all transactions with filters
          List<TransactionModel> transactions = [];

          if (_startDate != null && _endDate != null) {
            transactions = transactionRepository.getTransactionsByDateRange(
              _startDate!,
              _endDate!,
            );
          } else {
            transactions = transactionRepository.getAllTransactions();
          }

          // Sort transactions by date
          transactions = DataUtils.sortTransactionsByDate(transactions);

          // Set report title and table headers
          reportTitle = localization.transactionReport;
          tableHeaders = [
            localization.date,
            localization.client,
            localization.amount,
            localization.transactionType,
            localization.currency,
            localization.notes,
          ];

          // Prepare report data
          for (final transaction in transactions) {
            // Get client name
            final client = clientRepository.getClientById(transaction.clientId);
            final clientName =
                client?.name ?? client?.phoneNumber ?? transaction.clientId;

            tableData.add([
              DataUtils.formatDate(transaction.date),
              clientName,
              transaction.amount.toString(),
              transaction.type,
              transaction.currency,
              transaction.notes ?? '',
            ]);
            tableFooterData = [
              _formatDate(DateTime.now()),
              DataUtils.calculateSumCredit(transactions).toString(),
              DataUtils.calculateSumDebit(transactions).toString(),
              DataUtils.calculateBalance(transactions).toString(),
              _selectedCurrency,
              ''
            ];
          }
          break;

        case 'SingleCurrency':
          // Check if client is selected
          if (_selectedClientId == null) {
            // Get all clients with financial data for the selected currency
            final clients = DataUtils.getAllClientsWithFinancialData(
              clientRepository,
              transactionRepository,
              currencyCode: _selectedCurrency,
            );

            // Set report title and table headers
            reportTitle = '${localization.currencyReport}: $_selectedCurrency';
            tableHeaders = [
              localization.client,
              localization.totalCredit,
              localization.totalDebit,
              localization.balance,
            ];

            // Prepare report data
            for (final client in clients) {
              final sumCredit = client.sumCredit ?? 0.0;
              final sumDebit = client.sumDebit ?? 0.0;
              final balance = sumCredit - sumDebit;

              tableData.add([
                client.name ?? client.phoneNumber,
                sumCredit.toString(),
                sumDebit.toString(),
                balance.toString(),
              ]);
              tableFooterData = [
                'Total',
                sumCredit.toString(),
                sumDebit.toString(),
                balance.toString(),
              ];
            }
          } else {
            // Get client details
            final client = clientRepository.getClientById(_selectedClientId!);
            if (client == null) {
              SnackBarUtils.showErrorSnackBar(
                context,
                message: 'Client not found',
              );
              return;
            }

            // Get client transactions for the selected currency
            List<TransactionModel> transactions =
                DataUtils.getClientTransactions(
              transactionRepository,
              client.id,
              currencyCode: _selectedCurrency,
              startDate: _startDate,
              endDate: _endDate,
            );

            // Sort transactions by date
            transactions = DataUtils.sortTransactionsByDate(transactions);

            // Set report title and table headers
            reportTitle =
                '${localization.currencyReport}: ${client.name ?? client.phoneNumber} - $_selectedCurrency';
            tableHeaders = [
              localization.date,
              localization.Credit,
              localization.Debit,
              localization.notes,
            ];

            // Prepare report data
            for (final transaction in transactions) {
              final creditAmount =
                  transaction.type == AppConstants.transactionTypeCredit
                      ? transaction.amount.toString()
                      : '0';
              final debitAmount =
                  transaction.type == AppConstants.transactionTypeDebit
                      ? transaction.amount.toString()
                      : '0';

              tableData.add([
                DataUtils.formatDate(transaction.date),
                creditAmount,
                debitAmount,
                transaction.notes ?? '',
              ]);
              tableFooterData = [
                'Total',
                DataUtils.calculateSumCredit(transactions).toString(),
                DataUtils.calculateSumDebit(transactions).toString(),
                DataUtils.calculateBalance(transactions).toString(),
              ];
            }
          }
          break;

        default: // 'all' or any other type
          // Get all clients with financial data for the selected currency
          final clients = DataUtils.getAllClientsWithFinancialData(
            clientRepository,
            transactionRepository,
            currencyCode: _selectedCurrency,
          );

          // Set report title and table headers
          reportTitle = 'All Clients';
          tableHeaders = [
            localization.client,
            localization.Credit,
            localization.Debit,
            localization.currency,
            localization.balance,
          ];

          // Prepare report data
          for (final client in clients) {
            final sumCredit = client.sumCredit ?? 0.0;
            final sumDebit = client.sumDebit ?? 0.0;
            final balance = sumCredit - sumDebit;

            tableData.add([
              client.name ?? client.phoneNumber,
              sumCredit.toString(),
              sumDebit.toString(),
              _selectedCurrency,
              balance.toString(),
            ]);
          }
         
          break;
      }

      // Navigate to report preview
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ReportPreview(
            reportTitle: reportTitle,
            tableHeaderTitles: tableHeaders,
            tableData: tableData,
            tableFooterData: tableFooterData,
            fromDate: _startDate != null ? _formatDate(_startDate!) : 'All',
            toDate: _endDate != null ? _formatDate(_endDate!) : 'All',
          ),
        ),
      );
    } catch (e) {
      SnackBarUtils.showErrorSnackBar(
        context,
        message: 'Error generating report: $e',
      );
    }
  }
}
