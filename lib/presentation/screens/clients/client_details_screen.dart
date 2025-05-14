import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/data_utils.dart';
import '../../../core/utils/report_utils.dart';
import '../../../core/utils/ui_utils.dart';
import '../../../data/models/client_model.dart';
import '../../../data/models/transaction_model.dart';
import '../../bloc/client/client_bloc.dart';
import '../../bloc/client/client_event.dart';
import '../../bloc/client/client_state.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../bloc/transaction/transaction_state.dart';
import '../../utils/snackbar_utils.dart';
import '../../widgets/app_widgets.dart';
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

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  ClientModel? _client;

  // Transaction filtering and sorting
  final _searchController = TextEditingController();
  String? _selectedCurrency;
  String? _selectedType;
  bool _sortByAmountAsc = true;
  bool _sortByDateAsc = false;
  bool _isSortingByAmount = false;

  List<TransactionModel> _transactions = [];
  List<TransactionModel> _filteredTransactions = [];

  @override
  void initState() {
    super.initState();

    // Set default currency
    _selectedCurrency = 'YER';

    // Load client details with currency filter
    context.read<ClientBloc>().add(
          ClientLoadDetailsEvent(
            id: widget.clientId,
            currencyCode: _selectedCurrency,
          ),
        );

    // Load client transactions
    context.read<TransactionBloc>().add(
          TransactionLoadByClientEvent(clientId: widget.clientId),
        );

    // Calculate client balance
    context.read<TransactionBloc>().add(
          TransactionCalculateBalanceEvent(
            clientId: widget.clientId,
            currencyCode: _selectedCurrency,
          ),
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _sortTransactions() {
    if (_isSortingByAmount) {
      // Sort by amount using utility method
      _filteredTransactions = DataUtils.sortTransactionsByAmount(
        _filteredTransactions,
        ascending: _sortByAmountAsc,
      );
    } else {
      // Sort by date using utility method
      _filteredTransactions = DataUtils.sortTransactionsByDate(
        _filteredTransactions,
        ascending: _sortByDateAsc,
      );
    }
  }

  // Generate and share client report
  Future<void> _generateAndSharePdf(BuildContext context) async {
    if (_client == null) return;

    // Prepare report data (not used yet, but demonstrates the API)
    ReportUtils.generateSupplementaryReport(
      _client!,
      _filteredTransactions,
      currencyCode: _selectedCurrency,
    );

    // Show a message for now since PDF generation is not implemented
    SnackBarUtils.showInfoSnackBar(
      context,
      message:
          'PDF generation not implemented yet. Report data prepared successfully.',
    );
  }

  // Generate and save client report
  Future<void> _generateAndPrintPdf(BuildContext context) async {
    if (_client == null) return;

    // Prepare report data (not used yet, but demonstrates the API)
    ReportUtils.generateSupplementaryReport(
      _client!,
      _filteredTransactions,
      currencyCode: _selectedCurrency,
    );

    // Show a message for now since PDF generation is not implemented
    SnackBarUtils.showInfoSnackBar(
      context,
      message:
          'PDF printing not implemented yet. Report data prepared successfully.',
    );
  }

  // Generate and share transaction report
  Future<void> _generateTransactionPdf(TransactionModel transaction) async {
    if (_client == null) return;

    // Prepare report data (not used yet, but demonstrates the API)
    ReportUtils.generateTransactionReport(
      _client!,
      transaction,
    );

    // Show a message for now since PDF generation is not implemented
    SnackBarUtils.showInfoSnackBar(
      context,
      message:
          'Transaction PDF generation not implemented yet. Report data prepared successfully.',
    );
  }

  void _deleteClient() async {
    final localizations = AppLocalizations.of(context);

    final confirmed = await UiUtils.showConfirmationDialog(
      context,
      title: localizations.deleteClient,
      content: localizations.confirmDeleteClient,
      confirmText: localizations.delete,
      confirmColor: AppTheme.errorColor,
    );

    if (confirmed) {
      context.read<ClientBloc>().add(
            ClientDeleteEvent(id: widget.clientId),
          );
    }
  }

  void _showAddTransactionBottomSheet(BuildContext context) {
    UiUtils.showAddTransactionBottomSheet(context, widget.clientId);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_client?.name ?? localizations.clientDetails),
        actions: [
          // Share button
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share',
            onPressed: () {
              _generateAndSharePdf(context);
            },
          ),
          // Print button
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: 'Print',
            onPressed: () {
              _generateAndPrintPdf(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
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
            tooltip: 'Delete',
            onPressed: _deleteClient,
          ),
        ],
      ),
      body: BlocListener<ClientBloc, ClientState>(
        listener: (context, state) {
          if (state is ClientDeletedState) {
            SnackBarUtils.showSuccessSnackBar(
              context,
              message: localizations.clientDeletedSuccess,
            );

            Navigator.of(context).pop();
          } else if (state is ClientDetailsLoadedState) {
            setState(() {
              _client = state.client;
            });
          } else if (state is ClientErrorState) {
            SnackBarUtils.showErrorSnackBar(
              context,
              message: state.message,
            );
          }
        },
        child: Column(
          children: [
            // Client info card
            _buildClientInfoCard(context),

            // Divider
            const Divider(height: 1, thickness: 1),

            // Transactions section
            Expanded(
              child: _buildTransactionsSection(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildClientInfoCard(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<ClientBloc, ClientState>(
      buildWhen: (previous, current) => current is ClientDetailsLoadedState,
      builder: (context, clientState) {
        if (clientState is ClientDetailsLoadedState) {
          final client = clientState.client;

          return BlocBuilder<TransactionBloc, TransactionState>(
            buildWhen: (previous, current) {
              if (current is TransactionBalanceCalculatedState) {
                return current.clientId == widget.clientId;
              }
              return false;
            },
            builder: (context, balanceState) {
              double balance = 0.0;
              bool isCredit = true;

              if (balanceState is TransactionBalanceCalculatedState) {
                balance = balanceState.balance;
                isCredit = balance >= 0;
              }

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Financial info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Credit
                          _buildInfoColumn(
                            icon: Icons.arrow_downward,
                            iconColor: AppTheme.successColor,
                            label: localizations.Credit,
                            value: balanceState
                                    is TransactionBalanceCalculatedState
                                ? (balance > 0
                                    ? DataUtils.formatCurrency(balance,
                                        currencyCode: _selectedCurrency)
                                    : DataUtils.formatCurrency(0.0,
                                        currencyCode: _selectedCurrency))
                                : "...",
                          ),

                          // Debit
                          _buildInfoColumn(
                            icon: Icons.arrow_upward,
                            iconColor: AppTheme.errorColor,
                            label: localizations.Debit,
                            value: balanceState
                                    is TransactionBalanceCalculatedState
                                ? (balance < 0
                                    ? DataUtils.formatCurrency(balance.abs(),
                                        currencyCode: _selectedCurrency)
                                    : DataUtils.formatCurrency(0.0,
                                        currencyCode: _selectedCurrency))
                                : "...",
                          ),

                          // Balance
                          _buildInfoColumn(
                            icon: isCredit
                                ? Icons.trending_down
                                : Icons.trending_up,
                            iconColor: isCredit
                                ? AppTheme.successColor
                                : AppTheme.errorColor,
                            label: localizations.balance,
                            value: balanceState
                                    is TransactionBalanceCalculatedState
                                ? DataUtils.formatCurrency(balance.abs(),
                                    currencyCode: _selectedCurrency)
                                : localizations.calculating,
                          ),

                          // Financial ceiling
                          if (client.financialCeiling > 0)
                            _buildInfoColumn(
                              icon: Icons.warning_amber_rounded,
                              iconColor: AppTheme.warningColor,
                              label: localizations.ceiling,
                              value: DataUtils.formatCurrency(
                                  client.financialCeiling,
                                  currencyCode: _selectedCurrency),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (clientState is ClientLoadingState) {
          return const Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        } else {
          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(child: Text(localizations.clientNotFound)),
            ),
          );
        }
      },
    );
  }

  Widget _buildInfoColumn({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            Icon(icon, color: iconColor, size: 16),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: iconColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsSection(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocConsumer<TransactionBloc, TransactionState>(
      listenWhen: (previous, current) => current is TransactionLoadedState,
      listener: (context, state) {
        if (state is TransactionLoadedState) {
          setState(() {
            _transactions = state.transactions;
            _filteredTransactions = List.from(_transactions);
            _sortTransactions();
          });
        }
      },
      buildWhen: (previous, current) =>
          current is TransactionLoadingState ||
          current is TransactionLoadedState ||
          current is TransactionErrorState,
      builder: (context, state) {
        // Show loading indicator only on initial load
        if (state is TransactionLoadingState && _transactions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        // Show error widget
        else if (state is TransactionErrorState) {
          return EmptyWidget(
            message: state.message,
            icon: Icons.error_outline,
            iconColor: AppTheme.errorColor,
            actionText: localizations.retry,
            onAction: () {
              context.read<TransactionBloc>().add(
                    TransactionLoadByClientEvent(clientId: widget.clientId),
                  );
            },
          );
        }
        // Show empty widget when transactions are loaded but empty
        else if (state is TransactionLoadedState &&
            state.transactions.isEmpty) {
          return EmptyWidget(
            message: localizations.noTransactions,
            icon: Icons.receipt_long,
            iconSize: 80,
            iconColor: Colors.grey.shade400,
            actionText: localizations.addTransaction,
            onAction: () => _showAddTransactionBottomSheet(context),
          );
        }

        // We've already handled the empty state in the BlocConsumer

        // Transactions list with filters
        return Column(
          children: [
            // Search and filter section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Search field
                  // TextField(
                  //   controller: _searchController,
                  //   decoration: InputDecoration(
                  //     hintText: localizations.search,
                  //     prefixIcon: const Icon(Icons.search),
                  //     suffixIcon: IconButton(
                  //       icon: const Icon(Icons.clear),
                  //       onPressed: () {
                  //         _searchController.clear();
                  //         setState(() {
                  //           _filteredTransactions = List.from(_transactions);
                  //           _sortTransactions();
                  //         });
                  //       },
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //   ),
                  //   onChanged: (value) {
                  //     setState(() {
                  //       if (value.isEmpty) {
                  //         _filteredTransactions = List.from(_transactions);
                  //       } else {
                  //         final searchQuery = value.toLowerCase();
                  //         _filteredTransactions =
                  //             _transactions.where((transaction) {
                  //           final notesMatch = transaction.notes
                  //                   ?.toLowerCase()
                  //                   .contains(searchQuery) ??
                  //               false;
                  //           final amountMatch = transaction.amount
                  //               .toString()
                  //               .contains(searchQuery);
                  //           final currencyMatch = transaction.currency
                  //               .toLowerCase()
                  //               .contains(searchQuery);
                  //           final dateMatch = DateFormat.yMd()
                  //               .format(transaction.date)
                  //               .toLowerCase()
                  //               .contains(searchQuery);

                  //           return notesMatch ||
                  //               amountMatch ||
                  //               currencyMatch ||
                  //               dateMatch;
                  //         }).toList();
                  //       }
                  //       _sortTransactions();
                  //     });
                  //   },
                  // ),

                  const SizedBox(height: 8),

                  // Filter and sort options
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Type filter
                        DropdownButtonHideUnderline(
                          child: IntrinsicWidth(
                            child: DropdownButton<String>(
                              isDense: true,
                              hint: Row(
                                children: [
                                  Icon(Icons.arrow_downward,
                                      color: _selectedType == 'Credit'
                                          ? AppTheme.successColor
                                          : Colors.grey,
                                      size: 20),
                                  const SizedBox(width: 2),
                                  Icon(Icons.arrow_upward,
                                      color: _selectedType == 'Debit'
                                          ? AppTheme.errorColor
                                          : Colors.grey,
                                      size: 20),
                                ],
                              ),
                              value: _selectedType,
                              items: [
                                DropdownMenuItem(
                                  value: 'Credit',
                                  child: Row(
                                    children: [
                                      const Icon(Icons.arrow_downward,
                                          color: AppTheme.successColor,
                                          size: 16),
                                      const SizedBox(width: 4),
                                      Text(localizations.Credit),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Debit',
                                  child: Row(
                                    children: [
                                      const Icon(Icons.arrow_upward,
                                          color: AppTheme.errorColor, size: 16),
                                      const SizedBox(width: 4),
                                      Text(localizations.Debit),
                                    ],
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value;
                                  if (value == null) {
                                    _filteredTransactions =
                                        List.from(_transactions);
                                  } else {
                                    _filteredTransactions = _transactions
                                        .where((transaction) =>
                                            transaction.type == value)
                                        .toList();
                                  }
                                  _sortTransactions();
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Currency filter
                        DropdownButtonHideUnderline(
                          child: IntrinsicWidth(
                            child: DropdownButton<String>(
                              isDense: true,
                              hint: Icon(
                                Icons.currency_exchange,
                                color: _selectedCurrency == null
                                    ? Colors.grey
                                    : AppTheme.primaryColor,
                                size: 20,
                              ),
                              value: _selectedCurrency,
                              items: AppConstants.supportedCurrencies
                                  .map<DropdownMenuItem<String>>((currency) {
                                return DropdownMenuItem<String>(
                                  value: currency['code'] as String,
                                  child: Text(
                                      '${currency['code']} (${currency['symbol']})'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCurrency = value;
                                  if (value == null) {
                                    _filteredTransactions =
                                        List.from(_transactions);
                                  } else {
                                    _filteredTransactions = _transactions
                                        .where((transaction) =>
                                            transaction.currency == value)
                                        .toList();
                                  }
                                  _sortTransactions();
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Sort by date
                        TextButton.icon(
                          icon: Icon(
                            !_isSortingByAmount
                                ? (_sortByDateAsc
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward)
                                : Icons.calendar_today,
                            color: !_isSortingByAmount
                                ? AppTheme.primaryColor
                                : Colors.grey,
                          ),
                          label: Text(
                            localizations.date,
                            style: TextStyle(
                              color: !_isSortingByAmount
                                  ? AppTheme.primaryColor
                                  : Colors.grey,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              if (!_isSortingByAmount) {
                                _sortByDateAsc = !_sortByDateAsc;
                              } else {
                                _isSortingByAmount = false;
                              }
                              _sortTransactions();
                            });
                          },
                        ),

                        const SizedBox(width: 12),

                        // Sort by amount
                        TextButton.icon(
                          icon: Icon(
                            _isSortingByAmount
                                ? (_sortByAmountAsc
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward)
                                : Icons.attach_money,
                            color: _isSortingByAmount
                                ? AppTheme.primaryColor
                                : Colors.grey,
                          ),
                          label: Text(
                            localizations.amount,
                            style: TextStyle(
                              color: _isSortingByAmount
                                  ? AppTheme.primaryColor
                                  : Colors.grey,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              if (_isSortingByAmount) {
                                _sortByAmountAsc = !_sortByAmountAsc;
                              } else {
                                _isSortingByAmount = true;
                              }
                              _sortTransactions();
                            });
                          },
                        ),

                        const SizedBox(width: 12),

                        // Reset filters
                        TextButton.icon(
                          icon: const Icon(Icons.clear_all),
                          label: const Text("Reset"),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _selectedCurrency = null;
                              _selectedType = null;
                              _filteredTransactions = List.from(_transactions);
                              _sortTransactions();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Transactions table
            Expanded(
              child: Column(
                children: [
                  // Table header
                  HeaderContainer(
                    padding: EdgeInsets.symmetric(
                        vertical: AppTheme.verticalSmallPadding.vertical / 2,
                        horizontal: 0),
                    child: Row(
                      children: [
                        // Date column
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: AppTheme.smallPadding,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: SmallText(
                              localizations.date,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        // Amount column
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: SmallText(
                              localizations.amount,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        // Description column
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: SmallText(
                              localizations.notes,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        // Balance column
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.center,
                            child: SmallText(
                              localizations.balance,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        // Actions column - small width for PDF icon
                        SizedBox(
                          width: 40,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Table body
                  Expanded(
                    child: _filteredTransactions.isEmpty
                        ? EmptyWidget(
                            message: localizations.noTransactions,
                            icon: Icons.receipt_long,
                            iconColor: Colors.grey.shade400,
                          )
                        : ListView.builder(
                            itemCount: _filteredTransactions.length,
                            itemBuilder: (context, index) {
                              final transaction = _filteredTransactions[index];

                              // Calculate running balance
                              double runningBalance = 0;
                              for (int i = 0; i <= index; i++) {
                                final t = _filteredTransactions[i];
                                if (t.type == 'Credit') {
                                  runningBalance += t.amount;
                                } else {
                                  runningBalance -= t.amount;
                                }
                              }

                              return Container(
                                decoration: BoxDecoration(
                                  color: index % 2 == 0
                                      ? Colors.white
                                      : Colors.grey.shade50,
                                  border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            TransactionDetailsScreen(
                                          transactionId: transaction.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      // Date column
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          alignment: Alignment.center,
                                          child: Text(
                                            DateFormat('yyyy-MM-dd\nHH:mm')
                                                .format(transaction.date),
                                            textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      // Amount column
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${transaction.amount.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  transaction.type == 'Credit'
                                                      ? AppTheme.successColor
                                                      : AppTheme.errorColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Description column
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          alignment: Alignment.center,
                                          child: Text(
                                            transaction.notes ??
                                                'No description',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      // Balance column
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          alignment: Alignment.center,
                                          child: Text(
                                            runningBalance.toStringAsFixed(2),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: runningBalance >= 0
                                                  ? AppTheme.successColor
                                                  : AppTheme.errorColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // PDF icon for individual transaction
                                      SizedBox(
                                        width: 40,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.picture_as_pdf,
                                            size: 16,
                                            color: Colors.red,
                                          ),
                                          onPressed: () =>
                                              _generateTransactionPdf(
                                                  transaction),
                                          tooltip: 'Export as PDF',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  // Summary footer
                  if (_filteredTransactions.isNotEmpty)
                    Column(
                      children: [
                        FooterContainer(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  AppTheme.verticalSmallPadding.vertical / 2,
                              horizontal: 0),
                          child: Row(
                            children: [
                              // Date column
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                  ),
                                  child: SmallText(
                                    DateFormat('yyyy-MM-dd')
                                        .format(DateTime.now()),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),

                              // Credit column
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                  ),
                                  child: SmallText(
                                    '${_filteredTransactions.where((t) => t.type == 'Credit').fold(0.0, (sum, t) => sum + t.amount).toStringAsFixed(2)}',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),

                              // Debit column
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                  ),
                                  child: SmallText(
                                    '${_filteredTransactions.where((t) => t.type != 'Credit').fold(0.0, (sum, t) => sum + t.amount).toStringAsFixed(2)}',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),

                              // Balance column
                              Expanded(
                                flex: 2,
                                child: BlocBuilder<TransactionBloc,
                                    TransactionState>(
                                  buildWhen: (previous, current) {
                                    if (current
                                        is TransactionBalanceCalculatedState) {
                                      return current.clientId ==
                                          widget.clientId;
                                    }
                                    return false;
                                  },
                                  builder: (context, state) {
                                    double balance = 0.0;
                                    if (state
                                        is TransactionBalanceCalculatedState) {
                                      balance = state.balance;
                                    }

                                    return Container(
                                      padding: const EdgeInsets.all(8),
                                      alignment: Alignment.center,
                                      child: SmallText(
                                        '${balance.toStringAsFixed(2)}',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Empty space for the actions column
                              const SizedBox(width: 40),
                            ],
                          ),
                        ),

                        // Add space at the bottom
                        SizedBox(
                            height: AppTheme.verticalMediumPadding.vertical),
                      ],
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
