import '../../data/models/client_model.dart';
import '../../data/models/transaction_model.dart';
import 'data_utils.dart';

/// A utility class for preparing data for various types of reports
///
/// Supported report types:
/// 1. Single Transaction Report - Data for a single transaction
/// 2. Supplementary Account Report - Summary of client transactions
/// 3. Detailed Account Report - Detailed client transactions with running balances
/// 4. Account Currency Report - Client transactions grouped by currency
class ReportUtils {
  /// Generate a single transaction report data
  /// Returns a map with report data formatted for ReportBody
  static Map<String, dynamic> generateTransactionReport(
    ClientModel client,
    TransactionModel transaction,
  ) {
    // Prepare the report title
    final reportTitle = 'Transaction Receipt';

    // Prepare table headers
    final tableHeaders = [
      'Date',
      'Type',
      'Amount',
      'Currency',
      'Notes',
    ];

    // Prepare table data (single row for transaction)
    final tableData = [
      [
        DataUtils.formatDate(transaction.date),
        transaction.type,
        transaction.amount.toString(),
        transaction.currency,
        transaction.notes ?? 'No notes',
      ]
    ];

    // Return formatted data for ReportBody
    return {
      'reportTitle': reportTitle,
      'tableHeaders': tableHeaders,
      'tableData': tableData,
      'fromDate': DataUtils.formatDate(transaction.date),
      'toDate': DataUtils.formatDate(transaction.date),
    };
  }

  /// Generate a supplementary account report (summary)
  /// Returns a map with report data formatted for ReportBody
  static Map<String, dynamic> generateSupplementaryReport(
    ClientModel client,
    List<TransactionModel> transactions, {
    String? currencyCode,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    // Filter transactions by date range if specified
    List<TransactionModel> filteredTransactions = transactions;
    if (startDate != null && endDate != null) {
      filteredTransactions = DataUtils.filterTransactionsByDateRange(
        transactions,
        startDate,
        endDate,
      );
    }

    // Filter transactions by currency if specified
    if (currencyCode != null) {
      filteredTransactions = filteredTransactions
          .where((t) => t.currency == currencyCode)
          .toList();
    }

    // Sort transactions by date
    filteredTransactions = DataUtils.sortTransactionsByDate(
      filteredTransactions,
      ascending: true,
    );

    // Calculate totals
    final totalCredit = DataUtils.calculateSumCredit(
      filteredTransactions,
      currencyCode: currencyCode,
    );

    final totalDebit = DataUtils.calculateSumDebit(
      filteredTransactions,
      currencyCode: currencyCode,
    );

    final balance = DataUtils.calculateBalance(
      filteredTransactions,
      currencyCode: currencyCode,
    );

    // Prepare the report title
    final reportTitle = 'Client Statement: ${client.name}';

    // Prepare table headers
    final tableHeaders = [
      'Date',
      'Type',
      'Amount',
      'Currency',
      'Notes',
    ];

    // Prepare table data (row for each transaction)
    final tableData = filteredTransactions.map((transaction) {
      return [
        DataUtils.formatDate(transaction.date),
        transaction.type,
        transaction.amount.toString(),
        transaction.currency,
        transaction.notes ?? '',
      ];
    }).toList();

    // Add a summary row at the end
    tableData.add([
      'Total',
      '',
      'Credit: ${totalCredit.toString()}',
      'Debit: ${totalDebit.toString()}',
      'Balance: ${balance.toString()}',
    ]);

    // Format dates for report
    final fromDateStr =
        startDate != null ? DataUtils.formatDate(startDate) : 'All';
    final toDateStr = endDate != null ? DataUtils.formatDate(endDate) : 'All';

    // Return formatted data for ReportBody
    return {
      'reportTitle': reportTitle,
      'tableHeaders': tableHeaders,
      'tableData': tableData,
      'fromDate': fromDateStr,
      'toDate': toDateStr,
      'totalCredit': totalCredit,
      'totalDebit': totalDebit,
      'balance': balance,
    };
  }

  /// Generate a detailed account report with running balances
  /// Returns a map with report data formatted for ReportBody
  static Map<String, dynamic> generateDetailedReport(
    ClientModel client,
    List<TransactionModel> transactions, {
    String? currencyCode,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    // Filter transactions by date range if specified
    List<TransactionModel> filteredTransactions = transactions;
    if (startDate != null && endDate != null) {
      filteredTransactions = DataUtils.filterTransactionsByDateRange(
        transactions,
        startDate,
        endDate,
      );
    }

    // Filter transactions by currency if specified
    if (currencyCode != null) {
      filteredTransactions = filteredTransactions
          .where((t) => t.currency == currencyCode)
          .toList();
    }

    // Sort transactions by date
    filteredTransactions = DataUtils.sortTransactionsByDate(
      filteredTransactions,
      ascending: true,
    );

    // Calculate running balances
    final runningBalances =
        DataUtils.calculateRunningBalances(filteredTransactions);

    // Calculate totals
    final totalCredit = DataUtils.calculateSumCredit(
      filteredTransactions,
      currencyCode: currencyCode,
    );

    final totalDebit = DataUtils.calculateSumDebit(
      filteredTransactions,
      currencyCode: currencyCode,
    );

    final balance = DataUtils.calculateBalance(
      filteredTransactions,
      currencyCode: currencyCode,
    );

    // Prepare the report title
    final reportTitle = 'Detailed Account Report: ${client.name}';

    // Prepare table headers
    final tableHeaders = [
      'Date',
      'Type',
      'Amount',
      'Currency',
      'Notes',
      'Balance',
    ];

    // Prepare table data (row for each transaction with running balance)
    final tableData = <List<String>>[];
    for (int i = 0; i < filteredTransactions.length; i++) {
      final transaction = filteredTransactions[i];
      final runningBalance =
          i < runningBalances.length ? runningBalances[i] : 0.0;

      tableData.add([
        DataUtils.formatDate(transaction.date),
        transaction.type,
        transaction.amount.toString(),
        transaction.currency,
        transaction.notes ?? '',
        runningBalance.toString(),
      ]);
    }

    // Add a summary row at the end
    tableData.add([
      'Total',
      '',
      'Credit: ${totalCredit.toString()}',
      'Debit: ${totalDebit.toString()}',
      'Balance: ${balance.toString()}',
      '',
    ]);

    // Format dates for report
    final fromDateStr =
        startDate != null ? DataUtils.formatDate(startDate) : 'All';
    final toDateStr = endDate != null ? DataUtils.formatDate(endDate) : 'All';

    // Return formatted data for ReportBody
    return {
      'reportTitle': reportTitle,
      'tableHeaders': tableHeaders,
      'tableData': tableData,
      'fromDate': fromDateStr,
      'toDate': toDateStr,
      'totalCredit': totalCredit,
      'totalDebit': totalDebit,
      'balance': balance,
    };
  }

  /// Generate an account currency report
  /// Returns a map with report data formatted for ReportBody
  static Map<String, dynamic> generateCurrencyReport(
    ClientModel client,
    List<TransactionModel> transactions,
  ) {
    // Get unique currencies
    final currencies = DataUtils.getUniqueCurrencies(transactions);

    // Get summary by currency
    final currencySummary =
        DataUtils.getTransactionsSummaryByCurrency(transactions);

    // Prepare the report title
    final reportTitle = 'Currency Report: ${client.name}';

    // Prepare table headers
    final tableHeaders = [
      'Currency',
      'Credit',
      'Debit',
      'Balance',
    ];

    // Prepare table data (row for each currency)
    final tableData = currencies.map((currency) {
      final summary = currencySummary[currency];
      final credit = summary?['sumCredit'] ?? 0.0;
      final debit = summary?['sumDebit'] ?? 0.0;
      final balance = summary?['balance'] ?? 0.0;

      return [
        currency,
        credit.toString(),
        debit.toString(),
        balance.toString(),
      ];
    }).toList();

    // Return formatted data for ReportBody
    return {
      'reportTitle': reportTitle,
      'tableHeaders': tableHeaders,
      'tableData': tableData,
      'fromDate': 'All',
      'toDate': 'All',
    };
  }
}
