import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/client_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/client_repository.dart';
import '../../data/repositories/transaction_repository.dart';
import '../constants/app_constants.dart';

/// A utility class that provides reusable methods for data operations
/// that are commonly used across multiple screens.
class DataUtils {
  /// Get a client by ID with optional currency filtering
  static ClientModel? getClientById(
    ClientRepository clientRepository,
    String clientId, {
    String? currencyCode,
  }) {
    return clientRepository.getClientById(
      clientId,
      currencyCode: currencyCode,
    );
  }

  /// Get all clients with optional currency filtering
  static List<ClientModel> getAllClients(
    ClientRepository clientRepository, {
    String? currencyCode,
  }) {
    return clientRepository.getAllClients(
      currencyCode: currencyCode,
    );
  }

  /// Search clients by query with optional currency filtering
  static List<ClientModel> searchClients(
    ClientRepository clientRepository,
    String query, {
    String? currencyCode,
  }) {
    return clientRepository.searchClients(
      query,
      currencyCode: currencyCode,
    );
  }

  /// Get transactions for a client with optional filtering
  static List<TransactionModel> getClientTransactions(
    TransactionRepository transactionRepository,
    String clientId, {
    String? currencyCode,
    String? transactionType,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    // Get all transactions for the client
    List<TransactionModel> transactions =
        transactionRepository.getTransactionsByClientId(clientId);

    // Apply currency filter if specified
    if (currencyCode != null) {
      transactions =
          transactions.where((t) => t.currency == currencyCode).toList();
    }

    // Apply transaction type filter if specified
    if (transactionType != null) {
      transactions =
          transactions.where((t) => t.type == transactionType).toList();
    }

    // Apply date range filter if specified
    if (startDate != null && endDate != null) {
      transactions = transactions.where((t) {
        return t.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
            t.date.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
    }

    return transactions;
  }

  /// Calculate sum of credit transactions for a client
  static double calculateSumCredit(
    List<TransactionModel> transactions, {
    String? currencyCode,
  }) {
    // Filter by currency if specified
    final filteredTransactions = currencyCode != null
        ? transactions.where((t) => t.currency == currencyCode).toList()
        : transactions;

    // Sum up credit transactions
    return filteredTransactions
        .where((t) => t.type == AppConstants.transactionTypeCredit)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Calculate sum of debit transactions for a client
  static double calculateSumDebit(
    List<TransactionModel> transactions, {
    String? currencyCode,
  }) {
    // Filter by currency if specified
    final filteredTransactions = currencyCode != null
        ? transactions.where((t) => t.currency == currencyCode).toList()
        : transactions;

    // Sum up debit transactions
    return filteredTransactions
        .where((t) => t.type == AppConstants.transactionTypeDebit)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Calculate balance (credit - debit) for a client
  static double calculateBalance(
    List<TransactionModel> transactions, {
    String? currencyCode,
  }) {
    final sumCredit =
        calculateSumCredit(transactions, currencyCode: currencyCode);
    final sumDebit =
        calculateSumDebit(transactions, currencyCode: currencyCode);
    return sumCredit - sumDebit;
  }

  /// Format currency amount with proper formatting
  static String formatCurrency(
    double amount, {
    String? currencyCode,
    int decimalPlaces = 2,
  }) {
    final formatter = NumberFormat.currency(
      symbol: currencyCode ?? '',
      decimalDigits: decimalPlaces,
    );
    return formatter.format(amount);
  }

  /// Format date to a readable string
  static String formatDate(
    DateTime date, {
    String format = 'yyyy-MM-dd',
  }) {
    return DateFormat(format).format(date);
  }

  /// Sort clients by creation date
  static List<ClientModel> sortClientsByDate(
    List<ClientModel> clients, {
    bool ascending = true,
  }) {
    final sortedClients = List<ClientModel>.from(clients);
    sortedClients.sort((a, b) {
      return ascending
          ? a.createdAt.compareTo(b.createdAt)
          : b.createdAt.compareTo(a.createdAt);
    });
    return sortedClients;
  }

  /// Sort transactions by date
  static List<TransactionModel> sortTransactionsByDate(
    List<TransactionModel> transactions, {
    bool ascending = true,
  }) {
    final sortedTransactions = List<TransactionModel>.from(transactions);
    sortedTransactions.sort((a, b) {
      return ascending ? a.date.compareTo(b.date) : b.date.compareTo(a.date);
    });
    return sortedTransactions;
  }

  /// Sort transactions by amount
  static List<TransactionModel> sortTransactionsByAmount(
    List<TransactionModel> transactions, {
    bool ascending = true,
  }) {
    final sortedTransactions = List<TransactionModel>.from(transactions);
    sortedTransactions.sort((a, b) {
      return ascending
          ? a.amount.compareTo(b.amount)
          : b.amount.compareTo(a.amount);
    });
    return sortedTransactions;
  }

  /// Filter transactions by date range
  static List<TransactionModel> filterTransactionsByDateRange(
    List<TransactionModel> transactions,
    DateTime startDate,
    DateTime endDate,
  ) {
    return transactions.where((t) {
      return t.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          t.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  /// Calculate running balance for a list of transactions
  static List<double> calculateRunningBalances(
    List<TransactionModel> transactions,
  ) {
    final runningBalances = <double>[];
    double balance = 0.0;

    for (final transaction in transactions) {
      if (transaction.type == AppConstants.transactionTypeCredit) {
        balance += transaction.amount;
      } else if (transaction.type == AppConstants.transactionTypeDebit) {
        balance -= transaction.amount;
      }
      runningBalances.add(balance);
    }

    return runningBalances;
  }

  /// Group transactions by month
  static Map<String, List<TransactionModel>> groupTransactionsByMonth(
    List<TransactionModel> transactions,
  ) {
    final groupedTransactions = <String, List<TransactionModel>>{};

    for (final transaction in transactions) {
      final monthYear = DateFormat('yyyy-MM').format(transaction.date);

      if (!groupedTransactions.containsKey(monthYear)) {
        groupedTransactions[monthYear] = [];
      }

      groupedTransactions[monthYear]!.add(transaction);
    }

    return groupedTransactions;
  }

  /// Check if a client is approaching their financial ceiling
  static bool isApproachingFinancialCeiling(
    ClientModel client,
    double balance,
  ) {
    if (client.financialCeiling <= 0) {
      return false;
    }

    // Consider approaching if balance is 80% or more of ceiling
    return balance >= (client.financialCeiling * 0.8);
  }

  /// Get client with calculated financial data (sumCredit, sumDebit, balance)
  static ClientModel getClientWithFinancialData(
    ClientModel client,
    List<TransactionModel> transactions, {
    String? currencyCode,
  }) {
    // Filter transactions by currency if specified
    final filteredTransactions = currencyCode != null
        ? transactions.where((t) => t.currency == currencyCode).toList()
        : transactions;

    // Calculate sumCredit and sumDebit
    final sumCredit = calculateSumCredit(filteredTransactions);
    final sumDebit = calculateSumDebit(filteredTransactions);

    // Return client with calculated financial data
    return client.copyWith(
      sumCredit: sumCredit,
      sumDebit: sumDebit,
    );
  }

  /// Get all unique currencies used in transactions
  static List<String> getUniqueCurrencies(
    List<TransactionModel> transactions,
  ) {
    final currencies = transactions.map((t) => t.currency).toSet().toList();
    return currencies;
  }

  /// Get transactions summary by currency
  static Map<String, Map<String, double>> getTransactionsSummaryByCurrency(
    List<TransactionModel> transactions,
  ) {
    final summary = <String, Map<String, double>>{};
    final currencies = getUniqueCurrencies(transactions);

    for (final currency in currencies) {
      final filteredTransactions =
          transactions.where((t) => t.currency == currency).toList();
      final sumCredit = calculateSumCredit(filteredTransactions);
      final sumDebit = calculateSumDebit(filteredTransactions);
      final balance = sumCredit - sumDebit;

      summary[currency] = {
        'sumCredit': sumCredit,
        'sumDebit': sumDebit,
        'balance': balance,
      };
    }

    return summary;
  }

  ///get all clients with calculated them financial data
  static List<ClientModel> getAllClientsWithFinancialData(
    ClientRepository clientRepository,
    TransactionRepository transactionRepository, {
    String? currencyCode,
  }) {
    final clients = clientRepository.getAllClients();
    return getClientsWithFinancialData(
      clients,
      transactionRepository,
      currencyCode: currencyCode,
    );
  }

  /// Get clients with calculated financial data
  static List<ClientModel> getClientsWithFinancialData(
    List<ClientModel> clients,
    TransactionRepository transactionRepository, {
    String? currencyCode,
  }) {
    return clients.map((client) {
      final transactions = getClientTransactions(
        transactionRepository,
        client.id,
        currencyCode: currencyCode,
      );

      return getClientWithFinancialData(
        client,
        transactions,
        currencyCode: currencyCode,
      );
    }).toList();
  }
}
