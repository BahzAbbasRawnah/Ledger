import 'languages.dart';

class LanguageEn extends Languages {
  // General
  @override
  String get appName => 'Ledger';
  @override
  String get ok => 'OK';
  @override
  String get cancel => 'Cancel';
  @override
  String get save => 'Save';
  @override
  String get delete => 'Delete';
  @override
  String get edit => 'Edit';
  @override
  String get search => 'Search';
  @override
  String get loading => 'Loading...';
  @override
  String get error => 'Error';
  @override
  String get success => 'Success';
  @override
  String get warning => 'Warning';
  @override
  String get info => 'Information';
  @override
  String get retry => 'Retry';
  @override
  String get next => 'Next';
  @override
  String get back => 'Back';
  @override
  String get done => 'Done';
  @override
  String get confirm => 'Confirm';
  @override
  String get yes => 'Yes';
  @override
  String get no => 'No';
  @override
  String get welcome => 'Welcome';
  @override
  String get user => 'User';
  @override
  String get quickActions => 'Quick Actions';
  @override
  String get recentClients => 'Recent Clients';
  @override
  String get recentTransactions => 'Recent Transactions';
  @override
  String get notProvided => 'Not Provided';
  @override
  String get notSet => 'Not Set';
  @override
  String get createdAt => 'Created At';
  @override
  String get updatedAt => 'Updated At';
  @override
  String get calculating => 'Calculating...';
  @override
  String get optional => 'Optional';
  @override
  String get dashboard => 'Dashboard';
  @override
  String get dateRange => 'Date Range';
  @override
  String get clearFilters => 'Clear Filters';
  @override
  String get filterTransactions => 'Filter Transactions';
  @override
  String get apply => 'Apply';
  @override
  String get viewFullSize => 'View Full Size';
  @override
  String get clientNotFound => 'Client not found';
  @override
  String get transactionNotFound => 'Transaction not found';
  @override
  String get generateReportToSeeResults => 'Generate a report to see results';
  @override
  String get ceiling => 'Ceiling';
  @override
  String get selectClientFirst => 'Please select a client first';
  @override
  String get amountRequired => 'Amount is required';
  @override
  String get invalidAmount => 'Invalid amount';
  @override
  String get businessNameRequired => 'Business name is required';
  @override
  String get businessPhoneRequired => 'Business phone is required';
  @override
  String get businessInfoUpdated => 'Business information updated successfully';
  @override
  String get changePhoto => 'Change Photo';
  @override
  String get deleteClient => 'Delete Client';
  @override
  String get deleteTransaction => 'Delete Transaction';
  @override
  String get notNow => 'Not Now';
  @override
  String get subscribe => 'Subscribe';
  @override
  String get subscriptionPrice => 'Monthly subscription: \$9.99';
  @override
  String get syncAcrossDevices => 'Sync across multiple devices';
  @override
  String get clientAccess => 'Client access to their statements';
  @override
  String get automaticBackup => 'Automatic cloud backup';
  @override
  String get prioritySupport => 'Priority customer support';
  @override
  String get premiumVersion => 'Premium Version';
  @override
  String get thanksForYourSupport => 'Thanks for your support!';
  @override
  String get restoreConfirmation =>
      'Are you sure you want to restore data? This will overwrite your current data.';
  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  // Auth
  @override
  String get login => 'Login';
  @override
  String get register => 'Register';
  @override
  String get phoneNumber => 'Phone Number';
  @override
  String get password => 'Password';
  @override
  String get confirmPassword => 'Confirm Password';
  @override
  String get forgotPassword => 'Forgot Password?';
  @override
  String get dontHaveAccount => 'Don\'t have an account? Register';
  @override
  String get alreadyHaveAccount => 'Already have an account? Login';
  @override
  String get verifyPhone => 'Verify Phone';
  @override
  String get verificationCode => 'Verification Code';
  @override
  String get resendCode => 'Resend Code';
  @override
  String get invalidPhoneNumber => 'Invalid phone number';
  @override
  String get invalidPassword => 'Password must be at least 6 characters';
  @override
  String get passwordsDontMatch => 'Passwords don\'t match';
  @override
  String get invalidVerificationCode => 'Invalid verification code';
  @override
  String get verificationCodeSent => 'Verification code sent to your phone';
  @override
  String get loginSuccess => 'Login successful';
  @override
  String get registerSuccess => 'Registration successful';
  @override
  String get logoutSuccess => 'Logout successful';
  @override
  String get logout => 'Logout';

  // Clients
  @override
  String get clients => 'Clients';
  @override
  String get client => 'Client';
  @override
  String get addClient => 'Add Client';
  @override
  String get editClient => 'Edit Client';
  @override
  String get clientDetails => 'Client Details';
  @override
  String get clientName => 'Client Name';
  @override
  String get clientPhone => 'Client Phone';
  @override
  String get clientPassword => 'Client Password';
  @override
  String get financialCeiling => 'Financial Ceiling';
  @override
  String get noClients => 'No clients found';
  @override
  String get clientAddedSuccess => 'Client added successfully';
  @override
  String get clientUpdatedSuccess => 'Client updated successfully';
  @override
  String get clientDeletedSuccess => 'Client deleted successfully';
  @override
  String get confirmDeleteClient =>
      'Are you sure you want to delete this client?';

  // Transactions
  @override
  String get transactions => 'Transactions';
  @override
  String get transaction => 'Transaction';
  @override
  String get addTransaction => 'Add Transaction';
  @override
  String get editTransaction => 'Edit Transaction';
  @override
  String get transactionDetails => 'Transaction Details';
  @override
  String get transactionType => 'Transaction Type';
  @override
  String get Credit => 'Credit';
  @override
  String get Debit => 'Debit';
  @override
  String get amount => 'Amount';
  @override
  String get date => 'Date';
  @override
  String get notes => 'Notes';
  @override
  String get receipt => 'Receipt';
  @override
  String get addReceipt => 'Add Receipt';
  @override
  String get viewReceipt => 'View Receipt';
  @override
  String get noTransactions => 'No transactions found';
  @override
  String get transactionAddedSuccess => 'Transaction added successfully';
  @override
  String get transactionUpdatedSuccess => 'Transaction updated successfully';
  @override
  String get transactionDeletedSuccess => 'Transaction deleted successfully';
  @override
  String get confirmDeleteTransaction =>
      'Are you sure you want to delete this transaction?';
  @override
  String get ceilingWarning =>
      'Warning: Client is approaching financial ceiling';

  // Reports
  @override
  String get reports => 'Reports';
  @override
  String get report => 'Report';
  @override
  String get generateReport => 'Generate Report';
  @override
  String get reportType => 'Report Type';
  @override
  String get monthly => 'Monthly';
  @override
  String get custom => 'Custom';
  @override
  String get detailed => 'Detailed';
  @override
  String get startDate => 'Start Date';
  @override
  String get endDate => 'End Date';
  @override
  String get selectClient => 'Select Client';
  @override
  String get allClients => 'All Clients';
  @override
  String get exportAsPdf => 'Export as PDF';
  @override
  String get exportAsExcel => 'Export as Excel';
  @override
  String get totalCredit => 'Total Credit';
  @override
  String get totalDebit => 'Total Debit';
  @override
  String get balance => 'Balance';
  @override
  String get noReportData => 'No data available for the selected period';

  @override
  String get clientReport => 'Client Report';

  @override
  String get transactionReport => 'Transaction Report';

  @override
  String get currencyReport => 'Currency Report';

  // Settings
  @override
  String get settings => 'Settings';
  @override
  String get language => 'Language';
  @override
  String get theme => 'Theme';
  @override
  String get lightTheme => 'Light';
  @override
  String get darkTheme => 'Dark';
  @override
  String get systemTheme => 'System';
  @override
  String get businessInfo => 'Business Information';
  @override
  String get businessName => 'Business Name';
  @override
  String get businessPhone => 'Business Phone';
  @override
  String get businessLogo => 'Business Logo';
  @override
  String get currency => 'Currency';
  @override
  String get subscription => 'Subscription';
  @override
  String get backupRestore => 'Backup & Restore';
  @override
  String get backup => 'Backup';
  @override
  String get restore => 'Restore';
  @override
  String get backupSuccess => 'Backup created successfully';
  @override
  String get restoreSuccess => 'Data restored successfully';
  @override
  String get trialVersion => 'Trial Version';
  @override
  String get trialDaysLeft => 'Days left in trial: ';
  @override
  String get upgradeToPremium => 'Upgrade to Premium';
  @override
  String get premiumFeatures => 'Premium Features';




  //Errors
  @override
  String get noSearchResults => 'No search results found';
  @override
  String get noClientsFound => 'No clients found for query: ';
  @override
  String get noTransactionsFound => 'No transactions found for query: ';
  @override
  String get noReportFound => 'No report found for query: ';
  @override
  String get invalidCredentials => 'Invalid credentials';
  @override
  String get somethingWentWrong => 'Something went wrong';
  @override
  String get pleaseTryAgainLater => 'Please try again later';
  @override
  String get connectionError => 'Connection error';
  @override
  String get permissionDenied => 'Permission denied';

  // Currency
  @override
  String get selectCurrency => 'Select Currency';
  @override
  String get currencySelected => 'Currency selected';
  @override
  String get currencyNotSelected => 'Currency not selected';
}
