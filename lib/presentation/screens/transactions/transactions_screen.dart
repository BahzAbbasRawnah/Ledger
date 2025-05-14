import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../bloc/transaction/transaction_state.dart';
import '../../widgets/custom_button.dart';
import 'add_transaction_screen.dart';
import 'transaction_details_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedClientId;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    if (_startDate != null && _endDate != null) {
      context.read<TransactionBloc>().add(
            TransactionLoadByDateRangeEvent(
              startDate: _startDate!,
              endDate: _endDate!,
              clientId: _selectedClientId,
            ),
          );
    } else {
      context.read<TransactionBloc>().add(TransactionLoadAllEvent());
    }
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedClientId = null;
    });

    _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.transactions),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter dialog
              _showFilterDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTransactions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          if (_startDate != null ||
              _endDate != null ||
              _selectedClientId != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (_startDate != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Chip(
                          label: Text(
                            '${localizations.startDate}: ${DateFormat.yMd().format(_startDate!)}',
                          ),
                          onDeleted: () {
                            setState(() {
                              _startDate = null;
                            });
                            _loadTransactions();
                          },
                        ),
                      ),
                    if (_endDate != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Chip(
                          label: Text(
                            '${localizations.endDate}: ${DateFormat.yMd().format(_endDate!)}',
                          ),
                          onDeleted: () {
                            setState(() {
                              _endDate = null;
                            });
                            _loadTransactions();
                          },
                        ),
                      ),
                    if (_selectedClientId != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Chip(
                          label: Text(
                            '${localizations.client}: $_selectedClientId',
                          ),
                          onDeleted: () {
                            setState(() {
                              _selectedClientId = null;
                            });
                            _loadTransactions();
                          },
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextButton(
                        onPressed: _clearFilters,
                        child: Text(localizations.clearFilters),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Transactions list
          Expanded(
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TransactionLoadedState) {
                  final transactions = state.transactions;

                  if (transactions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.receipt_long,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            localizations.noTransactions,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: localizations.addTransaction,
                            icon: Icons.add,
                            widthPercentage: 70, // 70% of screen width
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const AddTransactionScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      _loadTransactions();
                    },
                    child: ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: transaction.type ==
                                    AppConstants.transactionTypeCredit
                                ? AppTheme.successColor
                                : AppTheme.errorColor,
                            child: Icon(
                              transaction.type ==
                                      AppConstants.transactionTypeCredit
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: Colors.white,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                '${transaction.currency} ${transaction.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: transaction.type ==
                                          AppConstants.transactionTypeCredit
                                      ? AppTheme.successColor
                                      : AppTheme.errorColor,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                DateFormat.yMd().format(transaction.date),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            transaction.notes ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: transaction.receiptImagePath != null
                              ? const Icon(Icons.receipt)
                              : null,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => TransactionDetailsScreen(
                                  transactionId: transaction.id,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                } else if (state is TransactionErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppTheme.errorColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppTheme.errorColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: localizations.retry,
                          onPressed: _loadTransactions,
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddTransactionScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showFilterDialog(BuildContext context) async {
    final localizations = AppLocalizations.of(context);

    // Temporary variables for the dialog
    DateTime? tempStartDate = _startDate;
    DateTime? tempEndDate = _endDate;
    String? tempClientId = _selectedClientId;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.filterTransactions),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Date range
              ListTile(
                title: Text(localizations.startDate),
                subtitle: tempStartDate != null
                    ? Text(DateFormat.yMd().format(tempStartDate!))
                    : null,
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: tempStartDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (date != null) {
                    tempStartDate = date;
                    // Force rebuild
                    setState(() {});
                  }
                },
              ),
              ListTile(
                title: Text(localizations.endDate),
                subtitle: tempEndDate != null
                    ? Text(DateFormat.yMd().format(tempEndDate!))
                    : null,
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: tempEndDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (date != null) {
                    tempEndDate = date;
                    // Force rebuild
                    setState(() {});
                  }
                },
              ),

              // Client selection (simplified for now)
              ListTile(
                title: Text(localizations.selectClient),
                subtitle: tempClientId != null
                    ? Text(tempClientId!)
                    : Text(localizations.allClients),
                trailing: const Icon(Icons.people),
                onTap: () {
                  // In a real app, we would show a client selection dialog
                  // For now, we'll just toggle between null and a dummy value
                  tempClientId = tempClientId == null ? 'Client 1' : null;
                  // Force rebuild
                  setState(() {});
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localizations.cancel),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _startDate = tempStartDate;
                  _endDate = tempEndDate;
                  _selectedClientId = tempClientId;
                });

                _loadTransactions();
                Navigator.of(context).pop();
              },
              child: Text(localizations.apply),
            ),
          ],
        );
      },
    );
  }
}
