import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/client_model.dart';

class ClientRepository {
  final Box<ClientModel> _clientsBox;
  
  ClientRepository(this._clientsBox);
  
  // Get all clients
  List<ClientModel> getAllClients() {
    return _clientsBox.values.toList();
  }
  
  // Get client by ID
  ClientModel? getClientById(String id) {
    return _clientsBox.values.firstWhere(
      (client) => client.id == id,
      orElse: () => throw Exception('Client not found'),
    );
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
  List<ClientModel> searchClients(String query) {
    final lowercaseQuery = query.toLowerCase();
    
    return _clientsBox.values.where((client) {
      final nameMatch = client.name?.toLowerCase().contains(lowercaseQuery) ?? false;
      final phoneMatch = client.phoneNumber.toLowerCase().contains(lowercaseQuery);
      
      return nameMatch || phoneMatch;
    }).toList();
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
        (client) => client.phoneNumber == phoneNumber && client.password == password,
      );
    } catch (e) {
      return null;
    }
  }
}
