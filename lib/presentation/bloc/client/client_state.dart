import 'package:equatable/equatable.dart';

import '../../../data/models/client_model.dart';

abstract class ClientState extends Equatable {
  const ClientState();

  @override
  List<Object?> get props => [];
}

class ClientInitialState extends ClientState {}

class ClientLoadingState extends ClientState {}

class ClientLoadedState extends ClientState {
  final List<ClientModel> clients;

  const ClientLoadedState({
    required this.clients,
  });

  @override
  List<Object?> get props => [clients];
}

class ClientDetailsLoadedState extends ClientState {
  final ClientModel client;

  const ClientDetailsLoadedState({
    required this.client,
  });

  @override
  List<Object?> get props => [client];
}

class ClientAddedState extends ClientState {
  final ClientModel client;

  const ClientAddedState({
    required this.client,
  });

  @override
  List<Object?> get props => [client];
}

class ClientUpdatedState extends ClientState {
  final ClientModel client;

  const ClientUpdatedState({
    required this.client,
  });

  @override
  List<Object?> get props => [client];
}

class ClientDeletedState extends ClientState {
  final String id;

  const ClientDeletedState({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

class ClientErrorState extends ClientState {
  final String message;

  const ClientErrorState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class ClientVerifiedState extends ClientState {
  final ClientModel client;

  const ClientVerifiedState({
    required this.client,
  });

  @override
  List<Object?> get props => [client];
}

class ClientVerificationFailedState extends ClientState {}
