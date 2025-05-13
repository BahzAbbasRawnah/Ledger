class AppConstants {
  // App Information
  static const String appName = 'Ledger';
  static const String appVersion = '1.0.0';
  
  // Shared Preferences Keys
  static const String prefLanguageCode = 'language_code';
  static const String prefThemeMode = 'theme_mode';
  static const String prefIsLoggedIn = 'is_logged_in';
  static const String prefUserId = 'user_id';
  static const String prefUserPhone = 'user_phone';
  static const String prefTrialEndDate = 'trial_end_date';
  static const String prefIsPremium = 'is_premium';
  static const String prefBusinessName = 'business_name';
  static const String prefBusinessPhone = 'business_phone';
  static const String prefBusinessLogo = 'business_logo';
  
  // Hive Box Names
  static const String userBox = 'user_box';
  static const String clientsBox = 'clients_box';
  static const String transactionsBox = 'transactions_box';
  static const String settingsBox = 'settings_box';
  
  // Trial Period in Days
  static const int trialPeriodDays = 30;
  
  // Supported Languages
  static const List<Map<String, dynamic>> supportedLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'ar', 'name': 'العربية'},
  ];
  
  // Supported Currencies
  static const List<Map<String, dynamic>> supportedCurrencies = [
    {'code': 'USD', 'symbol': '\$', 'name': 'US Dollar'},
    {'code': 'EUR', 'symbol': '€', 'name': 'Euro'},
    {'code': 'GBP', 'symbol': '£', 'name': 'British Pound'},
    {'code': 'SAR', 'symbol': '﷼', 'name': 'Saudi Riyal'},
    {'code': 'AED', 'symbol': 'د.إ', 'name': 'UAE Dirham'},
    {'code': 'EGP', 'symbol': 'ج.م', 'name': 'Egyptian Pound'},
  ];
  
  // Transaction Types
  static const String transactionTypeIncoming = 'incoming';
  static const String transactionTypeOutgoing = 'outgoing';
  
  // Routes
  static const String routeSplash = '/';
  static const String routeOnboarding = '/onboarding';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeVerifyPhone = '/verify-phone';
  static const String routeHome = '/home';
  static const String routeClients = '/clients';
  static const String routeAddClient = '/add-client';
  static const String routeClientDetails = '/client-details';
  static const String routeTransactions = '/transactions';
  static const String routeAddTransaction = '/add-transaction';
  static const String routeTransactionDetails = '/transaction-details';
  static const String routeReports = '/reports';
  static const String routeSettings = '/settings';
  static const String routeBusinessInfo = '/business-info';
  static const String routeSubscription = '/subscription';
  static const String routeBackupRestore = '/backup-restore';
}
