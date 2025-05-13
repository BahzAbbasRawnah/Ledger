import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitialState extends SettingsState {}

class SettingsLoadingState extends SettingsState {}

class SettingsLoadedState extends SettingsState {
  final String languageCode;
  final ThemeMode themeMode;
  final String currencyCode;

  const SettingsLoadedState({
    required this.languageCode,
    required this.themeMode,
    required this.currencyCode,
  });

  @override
  List<Object?> get props => [languageCode, themeMode, currencyCode];
}

class SettingsLanguageChangedState extends SettingsState {
  final String languageCode;

  const SettingsLanguageChangedState({
    required this.languageCode,
  });

  @override
  List<Object?> get props => [languageCode];
}

class SettingsThemeChangedState extends SettingsState {
  final ThemeMode themeMode;

  const SettingsThemeChangedState({
    required this.themeMode,
  });

  @override
  List<Object?> get props => [themeMode];
}

class SettingsCurrencyChangedState extends SettingsState {
  final String currencyCode;

  const SettingsCurrencyChangedState({
    required this.currencyCode,
  });

  @override
  List<Object?> get props => [currencyCode];
}

class SettingsBackupSuccessState extends SettingsState {
  final String backupPath;

  const SettingsBackupSuccessState({
    required this.backupPath,
  });

  @override
  List<Object?> get props => [backupPath];
}

class SettingsRestoreSuccessState extends SettingsState {}

class SettingsErrorState extends SettingsState {
  final String message;

  const SettingsErrorState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
