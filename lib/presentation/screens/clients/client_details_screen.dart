import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/client_model.dart';
import '../../bloc/client/client_bloc.dart';
import '../../bloc/client/client_event.dart';
import '../../bloc/client/client_state.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../bloc/transaction/transaction_state.dart';
import '../../widgets/custom_button.dart';
import '../transactions/add_transaction_screen.dart';
import '../transactions/transaction_details_screen.dart';
import 'edit_client_screen.dart';

class ClientDetailsScreen extends StatefulWidget {
  final String clientId;

  const ClientDetailsScreen({
    super.key,
    required this.clientId,
  });

  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ClientModel? _client;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load client details
    context.read<ClientBloc>().add(ClientLoadDetailsEvent(id: widget.clientId));

    // Load client transactions
    context.read<TransactionBloc>().add(
          TransactionLoadByClientEvent(clientId: widget.clientId),
        );

    // Calculate client balance
    context.read<TransactionBloc>().add(
          TransactionCalculateBalanceEvent(clientId: widget.clientId),
        );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _deleteClient() {
    final localizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.deleteClient),
          content: Text(localizations.confirmDeleteClient),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localizations.cancel),
            ),
            TextButton(
              onPressed: () {
                context.read<ClientBloc>().add(
                      ClientDeleteEvent(id: widget.clientId),
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.clientDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (_client != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EditClientScreen(client: _client!),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteClient,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: localizations.info),
            Tab(text: localizations.transactions),
          ],
        ),
      ),
      body: BlocListener<ClientBloc, ClientState>(
        listener: (context, state) {
          if (state is ClientDeletedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.clientDeletedSuccess),
                backgroundColor: AppTheme.successColor,
              ),
            );

            Navigator.of(context).pop();
          } else if (state is ClientDetailsLoadedState) {
            setState(() {
              _client = state.client;
            });
          } else if (state is ClientErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            // Info tab
            _buildInfoTab(context),

            // Transactions tab
            _buildTransactionsTab(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddTransactionScreen(clientId: widget.clientId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoTab(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<ClientBloc, ClientState>(
      buildWhen: (previous, current) => current is ClientDetailsLoadedState,
      builder: (context, state) {
        if (state is ClientDetailsLoadedState) {
          final client = state.client;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Client avatar
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      client.name?.isNotEmpty == true
                          ? client.name![0].toUpperCase()
                          : client.phoneNumber[0],
                      style: const TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Client name
                _buildInfoItem(
                  context,
                  Icons.person,
                  localizations.clientName,
                  client.name ?? localizations.notProvided,
                ),

                // Client phone
                _buildInfoItem(
                  context,
                  Icons.phone,
                  localizations.clientPhone,
                  client.phoneNumber,
                ),

                // Financial ceiling
                _buildInfoItem(
                  context,
                  Icons.attach_money,
                  localizations.financialCeiling,
                  client.financialCeiling > 0
                      ? client.financialCeiling.toString()
                      : localizations.notSet,
                ),

                // Created at
                _buildInfoItem(
                  context,
                  Icons.calendar_today,
                  localizations.createdAt,
                  DateFormat.yMMMd().format(client.createdAt),
                ),

                // Balance
                BlocBuilder<TransactionBloc, TransactionState>(
                  buildWhen: (previous, current) =>
                      current is TransactionBalanceCalculatedState,
                  builder: (context, state) {
                    if (state is TransactionBalanceCalculatedState &&
                        state.clientId == widget.clientId) {
                      return _buildInfoItem(
                        context,
                        Icons.account_balance_wallet,
                        localizations.balance,
                        state.balance.toString(),
                        valueColor: state.balance >= 0
                            ? AppTheme.successColor
                            : AppTheme.errorColor,
                      );
                    } else {
                      return _buildInfoItem(
                        context,
                        Icons.account_balance_wallet,
                        localizations.balance,
                        localizations.calculating,
                      );
                    }
                  },
                ),
              ],
            ),
          );
        } else if (state is ClientLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: Text(localizations.clientNotFound),
          );
        }
      },
    );
  }

  Widget _buildInfoItem(
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

  Widget _buildTransactionsTab(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<TransactionBloc, TransactionState>(
      buildWhen: (previous, current) =>
          current is TransactionLoadedState ||
          current is TransactionLoadingState,
      builder: (context, state) {
        if (state is TransactionLoadedState) {
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
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddTransactionScreen(
                            clientId: widget.clientId,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: transaction.type == 'incoming'
                      ? AppTheme.successColor
                      : AppTheme.errorColor,
                  child: Icon(
                    transaction.type == 'incoming'
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
                        color: transaction.type == 'incoming'
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
          );
        } else if (state is TransactionLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: Text(localizations.noTransactions),
          );
        }
      },
    );
  }
}
