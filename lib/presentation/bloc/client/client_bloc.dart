import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/client_repository.dart';
import 'client_event.dart';
import 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final ClientRepository clientRepository;

  ClientBloc({
    required this.clientRepository,
  }) : super(ClientInitialState()) {
    on<ClientLoadAllEvent>(_onLoadAll);
    on<ClientSearchEvent>(_onSearch);
    on<ClientAddEvent>(_onAdd);
    on<ClientUpdateEvent>(_onUpdate);
    on<ClientDeleteEvent>(_onDelete);
    on<ClientLoadDetailsEvent>(_onLoadDetails);
    on<ClientVerifyCredentialsEvent>(_onVerifyCredentials);
  }

  Future<void> _onLoadAll(
    ClientLoadAllEvent event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoadingState());

    try {
      final clients =
          clientRepository.getAllClients(currencyCode: event.currencyCode);
      emit(ClientLoadedState(clients: clients));
    } catch (e) {
      emit(ClientErrorState(message: e.toString()));
    }
  }

  Future<void> _onSearch(
    ClientSearchEvent event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoadingState());

    try {
      final clients = clientRepository.searchClients(
        event.query,
        currencyCode: event.currencyCode,
      );
      emit(ClientLoadedState(clients: clients));
    } catch (e) {
      emit(ClientErrorState(message: e.toString()));
    }
  }

  Future<void> _onAdd(
    ClientAddEvent event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoadingState());

    try {
      // Validate phone number (simple validation)
      if (event.phoneNumber.isEmpty || event.phoneNumber.length < 10) {
        emit(const ClientErrorState(message: 'Invalid phone number'));
        return;
      }

      // Validate password
      if (event.password.isEmpty || event.password.length < 6) {
        emit(const ClientErrorState(
            message: 'Password must be at least 6 characters'));
        return;
      }

      final client = await clientRepository.addClient(
        name: event.name,
        phoneNumber: event.phoneNumber,
        password: event.password,
        financialCeiling: event.financialCeiling,
      );

      emit(ClientAddedState(client: client));
    } catch (e) {
      emit(ClientErrorState(message: e.toString()));
    }
  }

  Future<void> _onUpdate(
    ClientUpdateEvent event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoadingState());

    try {
      final updatedClient = await clientRepository.updateClient(event.client);
      emit(ClientUpdatedState(client: updatedClient));
    } catch (e) {
      emit(ClientErrorState(message: e.toString()));
    }
  }

  Future<void> _onDelete(
    ClientDeleteEvent event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoadingState());

    try {
      await clientRepository.deleteClient(event.id);
      emit(ClientDeletedState(id: event.id));
    } catch (e) {
      emit(ClientErrorState(message: e.toString()));
    }
  }

  Future<void> _onLoadDetails(
    ClientLoadDetailsEvent event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoadingState());

    try {
      final client = clientRepository.getClientById(
        event.id,
        currencyCode: event.currencyCode,
      );

      if (client != null) {
        emit(ClientDetailsLoadedState(client: client));
      } else {
        emit(const ClientErrorState(message: 'Client not found'));
      }
    } catch (e) {
      emit(ClientErrorState(message: e.toString()));
    }
  }

  Future<void> _onVerifyCredentials(
    ClientVerifyCredentialsEvent event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoadingState());

    try {
      final client = clientRepository.verifyClientCredentials(
        event.phoneNumber,
        event.password,
      );

      if (client != null) {
        emit(ClientVerifiedState(client: client));
      } else {
        emit(ClientVerificationFailedState());
      }
    } catch (e) {
      emit(ClientErrorState(message: e.toString()));
    }
  }
}
