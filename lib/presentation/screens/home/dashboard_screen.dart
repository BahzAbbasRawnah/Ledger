import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/client_model.dart';
import '../../../data/models/transaction_model.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/client/client_bloc.dart';
import '../../bloc/client/client_state.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_state.dart';
import '../../widgets/dashboard_card.dart';
import '../clients/add_client_screen.dart';
import '../clients/client_details_screen.dart';
import '../transactions/add_transaction_screen.dart';
import '../transactions/transaction_details_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.dashboard),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthAuthenticatedState) {
            return RefreshIndicator(
              onRefresh: () async {
                // Refresh data
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome message
                    Text(
                      '${localizations.welcome}, ${authState.user.businessName ?? localizations.user}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Trial info
                    if (!authState.user.isPremium)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.warningColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.warningColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info,
                              color: AppTheme.warningColor,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${localizations.trialDaysLeft} ${_getRemainingDays(authState.user.trialEndDate)}',
                                style: const TextStyle(
                                  color: AppTheme.warningColor,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to subscription screen
                              },
                              child: Text(localizations.upgradeToPremium),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),

                    // Quick actions
                    Text(
                      localizations.quickActions,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Quick action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildQuickActionButton(
                          context,
                          Icons.person_add,
                          localizations.addClient,
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const AddClientScreen(),
                              ),
                            );
                          },
                        ),
                        _buildQuickActionButton(
                          context,
                          Icons.add_chart,
                          localizations.addTransaction,
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const AddTransactionScreen(),
                              ),
                            );
                          },
                        ),
                        _buildQuickActionButton(
                          context,
                          Icons.bar_chart,
                          localizations.generateReport,
                          () {
                            // Navigate to reports screen
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Summary cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildClientsSummary(context),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTransactionsSummary(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Recent clients
                    Text(
                      localizations.recentClients,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRecentClients(context),
                    const SizedBox(height: 24),

                    // Recent transactions
                    Text(
                      localizations.recentTransactions,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRecentTransactions(context),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
          child: Icon(icon),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildClientsSummary(BuildContext context) {
    return BlocBuilder<ClientBloc, ClientState>(
      builder: (context, state) {
        int clientCount = 0;

        if (state is ClientLoadedState) {
          clientCount = state.clients.length;
        }

        return DashboardCard(
          title: AppLocalizations.of(context).clients,
          value: clientCount.toString(),
          icon: Icons.people,
          color: AppTheme.primaryColor,
        );
      },
    );
  }

  Widget _buildTransactionsSummary(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        int transactionCount = 0;

        if (state is TransactionLoadedState) {
          transactionCount = state.transactions.length;
        }

        return DashboardCard(
          title: AppLocalizations.of(context).transactions,
          value: transactionCount.toString(),
          icon: Icons.receipt_long,
          color: AppTheme.secondaryColor,
        );
      },
    );
  }

  Widget _buildRecentClients(BuildContext context) {
    return BlocBuilder<ClientBloc, ClientState>(
      builder: (context, state) {
        if (state is ClientLoadedState) {
          final clients = state.clients;

          if (clients.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context).noClients),
            );
          }

          // Sort by creation date (newest first) and take up to 5
          final recentClients = List<ClientModel>.from(clients)
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          final displayClients = recentClients.take(5).toList();

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayClients.length,
            itemBuilder: (context, index) {
              final client = displayClients[index];

              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    client.name?.isNotEmpty == true
                        ? client.name![0].toUpperCase()
                        : client.phoneNumber[0],
                  ),
                ),
                title: Text(client.name ?? client.phoneNumber),
                subtitle: Text(client.phoneNumber),
                trailing: Text(
                  DateFormat.yMd().format(client.createdAt),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ClientDetailsScreen(clientId: client.id),
                    ),
                  );
                },
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoadedState) {
          final transactions = state.transactions;

          if (transactions.isEmpty) {
            return Center(
              child: Text(localizations.noTransactions),
            );
          }

          // Sort by date (newest first) and take up to 5
          final recentTransactions = List<TransactionModel>.from(transactions)
            ..sort((a, b) => b.date.compareTo(a.date));

          final displayTransactions = recentTransactions.take(5).toList();

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayTransactions.length,
            itemBuilder: (context, index) {
              final transaction = displayTransactions[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: transaction.type == 'Credit'
                      ? AppTheme.successColor
                      : AppTheme.errorColor,
                  child: Icon(
                    transaction.type == 'Credit'
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  '${transaction.currency} ${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: transaction.type == 'Credit'
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  transaction.notes ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  DateFormat.yMd().format(transaction.date),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
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
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  int _getRemainingDays(DateTime endDate) {
    final now = DateTime.now();
    return endDate.difference(now).inDays;
  }
}
