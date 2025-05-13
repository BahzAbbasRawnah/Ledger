import 'package:equatable/equatable.dart';

import '../../../data/models/client_model.dart';

abstract class ClientEvent extends Equatable {
  const ClientEvent();

  @override
  List<Object?> get props => [];
}

class ClientLoadAllEvent extends ClientEvent {}

class ClientSearchEvent extends ClientEvent {
  final String query;

  const ClientSearchEvent({
    required this.query,
  });

  @override
  List<Object?> get props => [query];
}

class ClientAddEvent extends ClientEvent {
  final String? name;
  final String phoneNumber;
  final String password;
  final double? financialCeiling;

  const ClientAddEvent({
    this.name,
    required this.phoneNumber,
    required this.password,
    this.financialCeiling,
  });

  @override
  List<Object?> get props => [name, phoneNumber, password, financialCeiling];
}

class ClientUpdateEvent extends ClientEvent {
  final ClientModel client;

  const ClientUpdateEvent({
    required this.client,
  });

  @override
  List<Object?> get props => [client];
}

class ClientDeleteEvent extends ClientEvent {
  final String id;

  const ClientDeleteEvent({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

class ClientLoadDetailsEvent extends ClientEvent {
  final String id;

  const ClientLoadDetailsEvent({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

class ClientVerifyCredentialsEvent extends ClientEvent {
  final String phoneNumber;
  final String password;

  const ClientVerifyCredentialsEvent({
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [phoneNumber, password];
}
