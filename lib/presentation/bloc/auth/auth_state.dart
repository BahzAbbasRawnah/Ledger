import 'package:equatable/equatable.dart';

import '../../../data/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthAuthenticatedState extends AuthState {
  final UserModel user;

  const AuthAuthenticatedState({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class AuthPhoneVerificationSentState extends AuthState {
  final String phoneNumber;

  const AuthPhoneVerificationSentState({
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [phoneNumber];
}

class AuthRegistrationSuccessState extends AuthState {
  final UserModel user;

  const AuthRegistrationSuccessState({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}

class AuthBusinessInfoUpdatedState extends AuthState {
  final UserModel user;

  const AuthBusinessInfoUpdatedState({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}

class AuthCurrencyUpdatedState extends AuthState {
  final UserModel user;

  const AuthCurrencyUpdatedState({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}

class AuthPremiumUpgradedState extends AuthState {
  final UserModel user;

  const AuthPremiumUpgradedState({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}
