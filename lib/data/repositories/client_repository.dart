import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../models/client_model.dart';
import '../models/transaction_model.dart';
import 'transaction_repository.dart';

class ClientRepository {
  final Box<ClientModel> _clientsBox;
  final TransactionRepository? _transactionRepository;

  ClientRepository(this._clientsBox, [this._transactionRepository]);

  // Get all clients
  List<ClientModel> getAllClients({String? currencyCode}) {
    final clients = _clientsBox.values.toList();

    // If transaction repository is available, calculate credit and debit sums
    if (_transactionRepository != null) {
      return clients.map((client) {
        final transactionRepo = _transactionRepository;
        final transactions =
            transactionRepo.getTransactionsByClientId(client.id);

        // Filter transactions by currency if specified
        final filteredTransactions = currencyCode != null
            ? transactions.where((t) => t.currency == currencyCode).toList()
            : transactions;

        double sumCredit = 0.0;
        double sumDebit = 0.0;

        for (final transaction in filteredTransactions) {
          if (transaction.type == AppConstants.transactionTypeCredit) {
            sumCredit += transaction.amount;
          } else if (transaction.type == AppConstants.transactionTypeDebit) {
            sumDebit += transaction.amount;
          }
        }

        return client.copyWith(
          sumCredit: sumCredit,
          sumDebit: sumDebit,
        );
      }).toList();
    }

    return clients;
  }

  // Get client by ID
  ClientModel? getClientById(String id, {String? currencyCode}) {
    try {
      final client = _clientsBox.values.firstWhere(
        (client) => client.id == id,
      );

      // If transaction repository is available, calculate credit and debit sums
      if (_transactionRepository != null) {
        final transactionRepo = _transactionRepository;
        final transactions =
            transactionRepo.getTransactionsByClientId(client.id);

        // Filter transactions by currency if specified
        final filteredTransactions = currencyCode != null
            ? transactions.where((t) => t.currency == currencyCode).toList()
            : transactions;

        double sumCredit = 0.0;
        double sumDebit = 0.0;

        // Calculate sums for the specified or default currency
        for (final transaction in filteredTransactions) {
          if (transaction.type == AppConstants.transactionTypeCredit) {
            sumCredit += transaction.amount;
          } else if (transaction.type == AppConstants.transactionTypeDebit) {
            sumDebit += transaction.amount;
          }
        }

        return client.copyWith(
          sumCredit: sumCredit,
          sumDebit: sumDebit,
        );
      }

      return client;
    } catch (e) {
      return null;
    }
  }

  // Add new client
  Future<ClientModel> addClient({
    required String phoneNumber,
    required String password,
    String? name,
    double? financialCeiling,
  }) async {
    final now = DateTime.now();

    final client = ClientModel(
      id: const Uuid().v4(),
      name: name,
      phoneNumber: phoneNumber,
      password: password,
      financialCeiling: financialCeiling ?? 0.0,
      createdAt: now,
      updatedAt: now,
    );

    await _clientsBox.add(client);
    return client;
  }

  // Update client
  Future<ClientModel> updateClient(ClientModel updatedClient) async {
    final index = _clientsBox.values.toList().indexWhere(
          (client) => client.id == updatedClient.id,
        );

    if (index == -1) {
      throw Exception('Client not found');
    }

    final clientWithUpdatedTimestamp = updatedClient.copyWith(
      updatedAt: DateTime.now(),
    );

    await _clientsBox.putAt(index, clientWithUpdatedTimestamp);
    return clientWithUpdatedTimestamp;
  }

  // Delete client
  Future<void> deleteClient(String id) async {
    final index = _clientsBox.values.toList().indexWhere(
          (client) => client.id == id,
        );

    if (index == -1) {
      throw Exception('Client not found');
    }

    await _clientsBox.deleteAt(index);
  }

  // Search clients by name or phone
  List<ClientModel> searchClients(String query, {String? currencyCode}) {
    final lowercaseQuery = query.toLowerCase();

    final clients = _clientsBox.values.where((client) {
      final nameMatch =
          client.name?.toLowerCase().contains(lowercaseQuery) ?? false;
      final phoneMatch =
          client.phoneNumber.toLowerCase().contains(lowercaseQuery);

      return nameMatch || phoneMatch;
    }).toList();

    // If transaction repository is available, calculate credit and debit sums
    if (_transactionRepository != null) {
      return clients.map((client) {
        final transactionRepo = _transactionRepository;
        final transactions =
            transactionRepo.getTransactionsByClientId(client.id);

        // Filter transactions by currency if specified
        final filteredTransactions = currencyCode != null
            ? transactions.where((t) => t.currency == currencyCode).toList()
            : transactions;

        double sumCredit = 0.0;
        double sumDebit = 0.0;

        for (final transaction in filteredTransactions) {
          if (transaction.type == AppConstants.transactionTypeCredit) {
            sumCredit += transaction.amount;
          } else if (transaction.type == AppConstants.transactionTypeDebit) {
            sumDebit += transaction.amount;
          }
        }

        return client.copyWith(
          sumCredit: sumCredit,
          sumDebit: sumDebit,
        );
      }).toList();
    }

    return clients;
  }

  // Check if client is approaching financial ceiling
  bool isApproachingCeiling(String clientId, double currentBalance) {
    final client = getClientById(clientId);

    if (client == null || client.financialCeiling <= 0) {
      return false;
    }

    // Consider approaching if balance is 80% or more of ceiling
    return currentBalance >= (client.financialCeiling * 0.8);
  }

  // Verify client credentials (for client login in premium version)
  ClientModel? verifyClientCredentials(String phoneNumber, String password) {
    try {
      return _clientsBox.values.firstWhere(
        (client) =>
            client.phoneNumber == phoneNumber && client.password == password,
      );
    } catch (e) {
      return null;
    }
  }
}
