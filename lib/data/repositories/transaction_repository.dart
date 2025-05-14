import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final Box<TransactionModel> _transactionsBox;

  TransactionRepository(this._transactionsBox);

  // Get all transactions
  List<TransactionModel> getAllTransactions() {
    return _transactionsBox.values.toList();
  }

  // Get transactions by client ID
  List<TransactionModel> getTransactionsByClientId(String clientId) {
    return _transactionsBox.values
        .where((transaction) => transaction.clientId == clientId)
        .toList();
  }

  // Get transaction by ID
  TransactionModel? getTransactionById(String id) {
    try {
      return _transactionsBox.values.firstWhere(
        (transaction) => transaction.id == id,
      );
    } catch (e) {
      return null;
    }
  }

  // Add new transaction
  Future<TransactionModel> addTransaction({
    required String clientId,
    required String type,
    required double amount,
    required DateTime date,
    String? notes,
    String? receiptImagePath,
    required String currency,
  }) async {
    final now = DateTime.now();

    final transaction = TransactionModel(
      id: const Uuid().v4(),
      clientId: clientId,
      type: type,
      amount: amount,
      date: date,
      notes: notes,
      receiptImagePath: receiptImagePath,
      currency: currency,
      createdAt: now,
      updatedAt: now,
    );

    await _transactionsBox.add(transaction);
    return transaction;
  }

  // Update transaction
  Future<TransactionModel> updateTransaction(
      TransactionModel updatedTransaction) async {
    final index = _transactionsBox.values.toList().indexWhere(
          (transaction) => transaction.id == updatedTransaction.id,
        );

    if (index == -1) {
      throw Exception('Transaction not found');
    }

    final transactionWithUpdatedTimestamp = updatedTransaction.copyWith(
      updatedAt: DateTime.now(),
    );

    await _transactionsBox.putAt(index, transactionWithUpdatedTimestamp);
    return transactionWithUpdatedTimestamp;
  }

  // Delete transaction
  Future<void> deleteTransaction(String id) async {
    final index = _transactionsBox.values.toList().indexWhere(
          (transaction) => transaction.id == id,
        );

    if (index == -1) {
      throw Exception('Transaction not found');
    }

    await _transactionsBox.deleteAt(index);
  }

  // Get transactions by date range
  List<TransactionModel> getTransactionsByDateRange(
      DateTime startDate, DateTime endDate) {
    return _transactionsBox.values.where((transaction) {
      return transaction.date
              .isAfter(startDate.subtract(const Duration(days: 1))) &&
          transaction.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  // Get transactions by client ID and date range
  List<TransactionModel> getTransactionsByClientAndDateRange(
      String clientId, DateTime startDate, DateTime endDate) {
    return _transactionsBox.values.where((transaction) {
      return transaction.clientId == clientId &&
          transaction.date
              .isAfter(startDate.subtract(const Duration(days: 1))) &&
          transaction.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  // Calculate client balance
  double calculateClientBalance(String clientId, {String? currencyCode}) {
    final transactions = getTransactionsByClientId(clientId);

    if (currencyCode != null) {
      transactions
          .removeWhere((transaction) => transaction.currency != currencyCode);
    }

    double balance = 0.0;

    for (final transaction in transactions) {
      if (transaction.type == AppConstants.transactionTypeCredit) {
        balance += transaction.amount;
      } else if (transaction.type == AppConstants.transactionTypeDebit) {
        balance -= transaction.amount;
      }
    }

    return balance;
  }

  // Generate monthly report data
  Map<String, dynamic> generateMonthlyReport(int year, int month,
      {String? clientId, String? currencyCode}) {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0); // Last day of month

    List<TransactionModel> transactions;

    if (clientId != null) {
      transactions =
          getTransactionsByClientAndDateRange(clientId, startDate, endDate);
    } else {
      transactions = getTransactionsByDateRange(startDate, endDate);
    }

    if (currencyCode != null) {
      transactions =
          transactions.where((t) => t.currency == currencyCode).toList();
    }

    double totalCredit = 0.0;
    double totalDebit = 0.0;

    for (final transaction in transactions) {
      if (transaction.type == AppConstants.transactionTypeCredit) {
        totalCredit += transaction.amount;
      } else if (transaction.type == AppConstants.transactionTypeDebit) {
        totalDebit += transaction.amount;
      }
    }

    return {
      'startDate': startDate,
      'endDate': endDate,
      'transactions': transactions,
      'totalCredit': totalCredit,
      'totalDebit': totalDebit,
      'balance': totalCredit - totalDebit,
    };
  }

  // Generate custom date range report data
  Map<String, dynamic> generateCustomReport(
      DateTime startDate, DateTime endDate,
      {String? clientId, String? currencyCode}) {
    List<TransactionModel> transactions;

    if (clientId != null) {
      transactions =
          getTransactionsByClientAndDateRange(clientId, startDate, endDate);
    } else {
      transactions = getTransactionsByDateRange(startDate, endDate);
    }

    if (currencyCode != null) {
      transactions =
          transactions.where((t) => t.currency == currencyCode).toList();
    }

    double totalCredit = 0.0;
    double totalDebit = 0.0;

    for (final transaction in transactions) {
      if (transaction.type == AppConstants.transactionTypeCredit) {
        totalCredit += transaction.amount;
      } else if (transaction.type == AppConstants.transactionTypeDebit) {
        totalDebit += transaction.amount;
      }
    }

    return {
      'startDate': startDate,
      'endDate': endDate,
      'transactions': transactions,
      'totalCredit': totalCredit,
      'totalDebit': totalDebit,
      'balance': totalCredit - totalDebit,
    };
  }
}
