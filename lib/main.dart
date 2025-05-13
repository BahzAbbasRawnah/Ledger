import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_constants.dart';
import 'core/localization/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'data/models/client_model.dart';
import 'data/models/transaction_model.dart';
import 'data/models/user_model.dart';
import 'data/repositories/client_repository.dart';
import 'data/repositories/transaction_repository.dart';
import 'data/repositories/user_repository.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_event.dart';
import 'presentation/bloc/client/client_bloc.dart';
import 'presentation/bloc/settings/settings_bloc.dart';
import 'presentation/bloc/settings/settings_event.dart';
import 'presentation/bloc/settings/settings_state.dart';
import 'presentation/bloc/transaction/transaction_bloc.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ClientModelAdapter());
  Hive.registerAdapter(TransactionModelAdapter());

  // Open boxes
  await Hive.openBox<UserModel>(AppConstants.userBox);
  await Hive.openBox<ClientModel>(AppConstants.clientsBox);
  await Hive.openBox<TransactionModel>(AppConstants.transactionsBox);

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({
    super.key,
    required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize repositories
    final userRepository =
        UserRepository(Hive.box<UserModel>(AppConstants.userBox));
    final clientRepository =
        ClientRepository(Hive.box<ClientModel>(AppConstants.clientsBox));
    final transactionRepository = TransactionRepository(
        Hive.box<TransactionModel>(AppConstants.transactionsBox));

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            userRepository: userRepository,
            sharedPreferences: sharedPreferences,
          )..add(AuthCheckStatusEvent()),
        ),
        BlocProvider<ClientBloc>(
          create: (context) => ClientBloc(
            clientRepository: clientRepository,
          ),
        ),
        BlocProvider<TransactionBloc>(
          create: (context) => TransactionBloc(
            transactionRepository: transactionRepository,
            clientRepository: clientRepository,
          ),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(
            sharedPreferences: sharedPreferences,
            userRepository: userRepository,
          )..add(SettingsLoadEvent()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) =>
            current is SettingsLoadedState ||
            current is SettingsLanguageChangedState ||
            current is SettingsThemeChangedState,
        builder: (context, state) {
          // Default values
          String languageCode = 'en';
          ThemeMode themeMode = ThemeMode.system;

          if (state is SettingsLoadedState) {
            languageCode = state.languageCode;
            themeMode = state.themeMode;
          } else if (state is SettingsLanguageChangedState) {
            languageCode = state.languageCode;
          } else if (state is SettingsThemeChangedState) {
            themeMode = state.themeMode;
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Ledger',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            locale: Locale(languageCode),
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('ar', ''), // Arabic
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
