import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/transaction_model.dart';
import '../../bloc/client/client_bloc.dart';
import '../../bloc/client/client_event.dart';
import '../../bloc/client/client_state.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../bloc/transaction/transaction_state.dart';
import '../../widgets/custom_button.dart';
import 'edit_transaction_screen.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final String transactionId;

  const TransactionDetailsScreen({
    super.key,
    required this.transactionId,
  });

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  TransactionModel? _transaction;
  String? _clientName;

  @override
  void initState() {
    super.initState();

    // Load transaction details
    context.read<TransactionBloc>().add(
          TransactionLoadDetailsEvent(id: widget.transactionId),
        );
  }

  void _loadClientDetails(String clientId) {
    context.read<ClientBloc>().add(ClientLoadDetailsEvent(id: clientId));
  }

  void _deleteTransaction() {
    final localizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.deleteTransaction),
          content: Text(localizations.confirmDeleteTransaction),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localizations.cancel),
            ),
            TextButton(
              onPressed: () {
                context.read<TransactionBloc>().add(
                      TransactionDeleteEvent(id: widget.transactionId),
                    );
                Navigator.of(context).pop();
              },
              child: Text(
                localizations.delete,
                style: const TextStyle(color: AppTheme.errorColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _viewReceipt() {
    if (_transaction?.receiptImagePath != null) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: Text(AppLocalizations.of(context).receipt),
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Flexible(
                  child: Image.file(
                    File(_transaction!.receiptImagePath!),
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.transactionDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (_transaction != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        EditTransactionScreen(transaction: _transaction!),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteTransaction,
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TransactionBloc, TransactionState>(
            listener: (context, state) {
              if (state is TransactionDetailsLoadedState) {
                setState(() {
                  _transaction = state.transaction;
                });

                // Load client details
                _loadClientDetails(state.transaction.clientId);
              } else if (state is TransactionDeletedState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(localizations.transactionDeletedSuccess),
                    backgroundColor: AppTheme.successColor,
                  ),
                );

                Navigator.of(context).pop();
              } else if (state is TransactionErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppTheme.errorColor,
                  ),
                );
              }
            },
          ),
          BlocListener<ClientBloc, ClientState>(
            listener: (context, state) {
              if (state is ClientDetailsLoadedState &&
                  _transaction != null &&
                  state.client.id == _transaction!.clientId) {
                setState(() {
                  _clientName = state.client.name ?? state.client.phoneNumber;
                });
              }
            },
          ),
        ],
        child: BlocBuilder<TransactionBloc, TransactionState>(
          buildWhen: (previous, current) =>
              current is TransactionDetailsLoadedState,
          builder: (context, state) {
            if (state is TransactionDetailsLoadedState) {
              final transaction = state.transaction;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Transaction type icon
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: transaction.type ==
                                AppConstants.transactionTypeCredit
                            ? AppTheme.successColor
                            : AppTheme.errorColor,
                        child: Icon(
                          transaction.type == AppConstants.transactionTypeCredit
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Amount
                    Center(
                      child: Text(
                        '${transaction.currency} ${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: transaction.type ==
                                  AppConstants.transactionTypeCredit
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Transaction details
                    _buildDetailItem(
                      context,
                      Icons.person,
                      localizations.client,
                      _clientName ?? localizations.loading,
                    ),

                    _buildDetailItem(
                      context,
                      Icons.swap_horiz,
                      localizations.transactionType,
                      transaction.type == AppConstants.transactionTypeCredit
                          ? localizations.Credit
                          : localizations.Debit,
                      valueColor:
                          transaction.type == AppConstants.transactionTypeCredit
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                    ),

                    _buildDetailItem(
                      context,
                      Icons.calendar_today,
                      localizations.date,
                      DateFormat.yMMMMd().format(transaction.date),
                    ),

                    if (transaction.notes != null &&
                        transaction.notes!.isNotEmpty)
                      _buildDetailItem(
                        context,
                        Icons.note,
                        localizations.notes,
                        transaction.notes!,
                      ),

                    _buildDetailItem(
                      context,
                      Icons.access_time,
                      localizations.createdAt,
                      DateFormat.yMMMd().add_Hm().format(transaction.createdAt),
                    ),

                    if (transaction.updatedAt != transaction.createdAt)
                      _buildDetailItem(
                        context,
                        Icons.update,
                        localizations.updatedAt,
                        DateFormat.yMMMd()
                            .add_Hm()
                            .format(transaction.updatedAt),
                      ),

                    // Receipt
                    if (transaction.receiptImagePath != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.receipt,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _viewReceipt,
                              child: Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(transaction.receiptImagePath!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: TextButton.icon(
                                onPressed: _viewReceipt,
                                icon: const Icon(Icons.fullscreen),
                                label: Text(localizations.viewFullSize),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            } else if (state is TransactionLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: Text(localizations.transactionNotFound),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
