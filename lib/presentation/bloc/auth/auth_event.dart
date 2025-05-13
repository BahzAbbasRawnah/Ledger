import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckStatusEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String phoneNumber;
  final String password;

  const AuthLoginEvent({
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [phoneNumber, password];
}

class AuthRegisterEvent extends AuthEvent {
  final String phoneNumber;
  final String password;
  final String confirmPassword;

  const AuthRegisterEvent({
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [phoneNumber, password, confirmPassword];
}

class AuthVerifyPhoneEvent extends AuthEvent {
  final String phoneNumber;
  final String verificationCode;

  const AuthVerifyPhoneEvent({
    required this.phoneNumber,
    required this.verificationCode,
  });

  @override
  List<Object?> get props => [phoneNumber, verificationCode];
}

class AuthLogoutEvent extends AuthEvent {}

class AuthUpdateBusinessInfoEvent extends AuthEvent {
  final String businessName;
  final String businessPhone;
  final String? businessLogo;

  const AuthUpdateBusinessInfoEvent({
    required this.businessName,
    required this.businessPhone,
    this.businessLogo,
  });

  @override
  List<Object?> get props => [businessName, businessPhone, businessLogo];
}

class AuthUpdateCurrencyEvent extends AuthEvent {
  final String currencyCode;

  const AuthUpdateCurrencyEvent({
    required this.currencyCode,
  });

  @override
  List<Object?> get props => [currencyCode];
}

class AuthUpgradeToPremiumEvent extends AuthEvent {}
