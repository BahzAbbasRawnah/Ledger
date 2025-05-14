import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger/presentation/screens/reports/reports_screen.dart';

import '../../../core/localization/app_localizations.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/client/client_bloc.dart';
import '../../bloc/client/client_event.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../clients/clients_screen.dart';
import '../reports/report_body.dart';
import '../settings/settings_screen.dart';
import '../transactions/transactions_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ClientsScreen(),
    const TransactionsScreen(),
    const ReportsScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();

    // Load initial data
    _loadData();
  }

  void _loadData() {
    // Load clients
    context.read<ClientBloc>().add(ClientLoadAllEvent());

    // Load transactions
    context.read<TransactionBloc>().add(TransactionLoadAllEvent());
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticatedState) {
          return Scaffold(
            body: _screens[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.dashboard),
                  label: localizations.dashboard,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.people),
                  label: localizations.clients,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.receipt_long),
                  label: localizations.transactions,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.bar_chart),
                  label: localizations.reports,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings),
                  label: localizations.settings,
                ),
              ],
            ),
          );
        } else {
          // If not authenticated, show loading indicator
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
