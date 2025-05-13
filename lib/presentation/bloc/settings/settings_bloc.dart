import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/repositories/user_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences sharedPreferences;
  final UserRepository userRepository;

  SettingsBloc({
    required this.sharedPreferences,
    required this.userRepository,
  }) : super(SettingsInitialState()) {
    on<SettingsLoadEvent>(_onLoad);
    on<SettingsChangeLanguageEvent>(_onChangeLanguage);
    on<SettingsChangeThemeEvent>(_onChangeTheme);
    on<SettingsChangeCurrencyEvent>(_onChangeCurrency);
    on<SettingsBackupDataEvent>(_onBackupData);
    on<SettingsRestoreDataEvent>(_onRestoreData);
  }

  Future<void> _onLoad(
    SettingsLoadEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoadingState());

    try {
      final languageCode =
          sharedPreferences.getString(AppConstants.prefLanguageCode) ?? 'en';

      final themeModeIndex = sharedPreferences.getInt('theme_mode') ?? 0;
      final themeMode = ThemeMode.values[themeModeIndex];

      final user = userRepository.getCurrentUser();
      final currencyCode = user?.preferredCurrency ?? 'USD';

      emit(SettingsLoadedState(
        languageCode: languageCode,
        themeMode: themeMode,
        currencyCode: currencyCode,
      ));
    } catch (e) {
      emit(SettingsErrorState(message: e.toString()));
    }
  }

  Future<void> _onChangeLanguage(
    SettingsChangeLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoadingState());

    try {
      await sharedPreferences.setString(
          AppConstants.prefLanguageCode, event.languageCode);

      emit(SettingsLanguageChangedState(languageCode: event.languageCode));
    } catch (e) {
      emit(SettingsErrorState(message: e.toString()));
    }
  }

  Future<void> _onChangeTheme(
    SettingsChangeThemeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoadingState());

    try {
      await sharedPreferences.setInt('theme_mode', event.themeMode.index);

      emit(SettingsThemeChangedState(themeMode: event.themeMode));
    } catch (e) {
      emit(SettingsErrorState(message: e.toString()));
    }
  }

  Future<void> _onChangeCurrency(
    SettingsChangeCurrencyEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoadingState());

    try {
      final user = userRepository.getCurrentUser();

      if (user == null) {
        emit(const SettingsErrorState(message: 'User not found'));
        return;
      }

      await userRepository.updatePreferredCurrency(event.currencyCode);

      emit(SettingsCurrencyChangedState(currencyCode: event.currencyCode));
    } catch (e) {
      emit(SettingsErrorState(message: e.toString()));
    }
  }

  Future<void> _onBackupData(
    SettingsBackupDataEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoadingState());

    try {
      // In a real app, we would upload the data to Google Drive
      // For this simulation, we'll just create a backup file in the app's documents directory

      final appDocDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${appDocDir.path}/backups');

      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final backupPath = '${backupDir.path}/ledger_backup_$timestamp.json';

      // Export data from Hive boxes
      final Map<String, dynamic> backupData = {};

      // User data
      final userBox = Hive.box(AppConstants.userBox);
      backupData['users'] =
          userBox.values.map((user) => user.toJson()).toList();

      // Clients data
      final clientsBox = Hive.box(AppConstants.clientsBox);
      backupData['clients'] =
          clientsBox.values.map((client) => client.toJson()).toList();

      // Transactions data
      final transactionsBox = Hive.box(AppConstants.transactionsBox);
      backupData['transactions'] = transactionsBox.values
          .map((transaction) => transaction.toJson())
          .toList();

      // Write to file
      final backupFile = File(backupPath);
      await backupFile.writeAsString(backupData.toString());

      emit(SettingsBackupSuccessState(backupPath: backupPath));
    } catch (e) {
      emit(SettingsErrorState(message: e.toString()));
    }
  }

  Future<void> _onRestoreData(
    SettingsRestoreDataEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoadingState());

    try {
      // In a real app, we would download the data from Google Drive
      // For this simulation, we'll just use the most recent backup file

      final appDocDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${appDocDir.path}/backups');

      if (!await backupDir.exists()) {
        emit(const SettingsErrorState(message: 'No backups found'));
        return;
      }

      final backupFiles = await backupDir.list().toList();

      if (backupFiles.isEmpty) {
        emit(const SettingsErrorState(message: 'No backups found'));
        return;
      }

      // Sort by name (which includes timestamp) to get the most recent
      backupFiles.sort((a, b) => b.path.compareTo(a.path));

      final latestBackup = backupFiles.first;

      if (latestBackup is! File) {
        emit(const SettingsErrorState(message: 'Invalid backup file'));
        return;
      }

      final backupContent = await (latestBackup as File).readAsString();
      final backupData = Map<String, dynamic>.from(backupContent as Map);

      // Clear existing data
      await Hive.box(AppConstants.userBox).clear();
      await Hive.box(AppConstants.clientsBox).clear();
      await Hive.box(AppConstants.transactionsBox).clear();

      // Restore user data
      final userBox = Hive.box(AppConstants.userBox);
      for (final userData in backupData['users']) {
        await userBox.add(userData);
      }

      // Restore clients data
      final clientsBox = Hive.box(AppConstants.clientsBox);
      for (final clientData in backupData['clients']) {
        await clientsBox.add(clientData);
      }

      // Restore transactions data
      final transactionsBox = Hive.box(AppConstants.transactionsBox);
      for (final transactionData in backupData['transactions']) {
        await transactionsBox.add(transactionData);
      }

      emit(SettingsRestoreSuccessState());
    } catch (e) {
      emit(SettingsErrorState(message: e.toString()));
    }
  }
}
