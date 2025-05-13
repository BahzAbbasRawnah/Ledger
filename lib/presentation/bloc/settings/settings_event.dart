import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class SettingsLoadEvent extends SettingsEvent {}

class SettingsChangeLanguageEvent extends SettingsEvent {
  final String languageCode;

  const SettingsChangeLanguageEvent({
    required this.languageCode,
  });

  @override
  List<Object?> get props => [languageCode];
}

class SettingsChangeThemeEvent extends SettingsEvent {
  final ThemeMode themeMode;

  const SettingsChangeThemeEvent({
    required this.themeMode,
  });

  @override
  List<Object?> get props => [themeMode];
}

class SettingsChangeCurrencyEvent extends SettingsEvent {
  final String currencyCode;

  const SettingsChangeCurrencyEvent({
    required this.currencyCode,
  });

  @override
  List<Object?> get props => [currencyCode];
}

class SettingsBackupDataEvent extends SettingsEvent {}

class SettingsRestoreDataEvent extends SettingsEvent {}
