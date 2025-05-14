import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'language/language_ar.dart';
import 'language/language_en.dart';
import 'language/languages.dart';

class AppLocalizations {
  final Locale locale;
  late Languages _languages;

  AppLocalizations(this.locale) {
    switch (locale.languageCode) {
      case 'ar':
        _languages = LanguageAr();
        break;
      case 'en':
      default:
        _languages = LanguageEn();
        break;
    }
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // General
  String get appName => _languages.appName;
  String get ok => _languages.ok;
  String get cancel => _languages.cancel;
  String get save => _languages.save;
  String get delete => _languages.delete;
  String get edit => _languages.edit;
  String get search => _languages.search;
  String get loading => _languages.loading;
  String get error => _languages.error;
  String get success => _languages.success;
  String get warning => _languages.warning;
  String get info => _languages.info;
  String get retry => _languages.retry;
  String get next => _languages.next;
  String get back => _languages.back;
  String get done => _languages.done;
  String get confirm => _languages.confirm;
  String get yes => _languages.yes;
  String get no => _languages.no;
  String get welcome => _languages.welcome;
  String get user => _languages.user;
  String get quickActions => _languages.quickActions;
  String get recentClients => _languages.recentClients;
  String get recentTransactions => _languages.recentTransactions;
  String get notProvided => _languages.notProvided;
  String get notSet => _languages.notSet;
  String get noSearchResults => _languages.noSearchResults;
  String get createdAt => _languages.createdAt;
  String get updatedAt => _languages.updatedAt;
  String get calculating => _languages.calculating;
  String get optional => _languages.optional;
  String get dashboard => _languages.dashboard;
  String get dateRange => _languages.dateRange;
  String get clearFilters => _languages.clearFilters;
  String get filterTransactions => _languages.filterTransactions;
  String get apply => _languages.apply;
  String get viewFullSize => _languages.viewFullSize;
  String get clientNotFound => _languages.clientNotFound;
  String get transactionNotFound => _languages.transactionNotFound;
  String get generateReportToSeeResults =>
      _languages.generateReportToSeeResults;
  String get ceiling => _languages.ceiling;
  String get selectClientFirst => _languages.selectClientFirst;
  String get amountRequired => _languages.amountRequired;
  String get invalidAmount => _languages.invalidAmount;
  String get businessNameRequired => _languages.businessNameRequired;
  String get businessPhoneRequired => _languages.businessPhoneRequired;
  String get businessInfoUpdated => _languages.businessInfoUpdated;
  String get changePhoto => _languages.changePhoto;
  String get deleteClient => _languages.deleteClient;
  String get deleteTransaction => _languages.deleteTransaction;
  String get notNow => _languages.notNow;
  String get subscribe => _languages.subscribe;
  String get subscriptionPrice => _languages.subscriptionPrice;
  String get syncAcrossDevices => _languages.syncAcrossDevices;
  String get clientAccess => _languages.clientAccess;
  String get automaticBackup => _languages.automaticBackup;
  String get prioritySupport => _languages.prioritySupport;
  String get premiumVersion => _languages.premiumVersion;
  String get thanksForYourSupport => _languages.thanksForYourSupport;
  String get restoreConfirmation => _languages.restoreConfirmation;
  String get logoutConfirmation => _languages.logoutConfirmation;

  // Auth
  String get login => _languages.login;
  String get register => _languages.register;
  String get phoneNumber => _languages.phoneNumber;
  String get password => _languages.password;
  String get confirmPassword => _languages.confirmPassword;
  String get forgotPassword => _languages.forgotPassword;
  String get dontHaveAccount => _languages.dontHaveAccount;
  String get alreadyHaveAccount => _languages.alreadyHaveAccount;
  String get verifyPhone => _languages.verifyPhone;
  String get verificationCode => _languages.verificationCode;
  String get resendCode => _languages.resendCode;
  String get invalidPhoneNumber => _languages.invalidPhoneNumber;
  String get invalidPassword => _languages.invalidPassword;
  String get passwordsDontMatch => _languages.passwordsDontMatch;
  String get invalidVerificationCode => _languages.invalidVerificationCode;
  String get verificationCodeSent => _languages.verificationCodeSent;
  String get loginSuccess => _languages.loginSuccess;
  String get registerSuccess => _languages.registerSuccess;
  String get logoutSuccess => _languages.logoutSuccess;
  String get logout => _languages.logout;

  // Clients
  String get clients => _languages.clients;
  String get client => _languages.client;
  String get addClient => _languages.addClient;
  String get editClient => _languages.editClient;
  String get clientDetails => _languages.clientDetails;
  String get clientName => _languages.clientName;
  String get clientPhone => _languages.clientPhone;
  String get clientPassword => _languages.clientPassword;
  String get financialCeiling => _languages.financialCeiling;
  String get noClients => _languages.noClients;
  String get clientAddedSuccess => _languages.clientAddedSuccess;
  String get clientUpdatedSuccess => _languages.clientUpdatedSuccess;
  String get clientDeletedSuccess => _languages.clientDeletedSuccess;
  String get confirmDeleteClient => _languages.confirmDeleteClient;

  // Transactions
  String get transactions => _languages.transactions;
  String get transaction => _languages.transaction;
  String get addTransaction => _languages.addTransaction;
  String get editTransaction => _languages.editTransaction;
  String get transactionDetails => _languages.transactionDetails;
  String get transactionType => _languages.transactionType;
  String get Credit => _languages.Credit;
  String get Debit => _languages.Debit;
  String get amount => _languages.amount;
  String get date => _languages.date;
  String get notes => _languages.notes;
  String get receipt => _languages.receipt;
  String get addReceipt => _languages.addReceipt;
  String get viewReceipt => _languages.viewReceipt;
  String get noTransactions => _languages.noTransactions;
  String get transactionAddedSuccess => _languages.transactionAddedSuccess;
  String get transactionUpdatedSuccess => _languages.transactionUpdatedSuccess;
  String get transactionDeletedSuccess => _languages.transactionDeletedSuccess;
  String get confirmDeleteTransaction => _languages.confirmDeleteTransaction;
  String get ceilingWarning => _languages.ceilingWarning;

  // Reports
  String get reports => _languages.reports;
  String get report => _languages.report;
  String get generateReport => _languages.generateReport;
  String get reportType => _languages.reportType;
  String get monthly => _languages.monthly;
  String get custom => _languages.custom;
  String get detailed => _languages.detailed;
  String get startDate => _languages.startDate;
  String get endDate => _languages.endDate;
  String get selectClient => _languages.selectClient;
  String get allClients => _languages.allClients;
  String get exportAsPdf => _languages.exportAsPdf;
  String get exportAsExcel => _languages.exportAsExcel;
  String get totalCredit => _languages.totalCredit;
  String get totalDebit => _languages.totalDebit;
  String get balance => _languages.balance;
  String get noReportData => _languages.noReportData;
  String get clientReport => _languages.clientReport;
  String get transactionReport => _languages.transactionReport;
  String get currencyReport => _languages.currencyReport;

  // Settings
  String get settings => _languages.settings;
  String get language => _languages.language;
  String get theme => _languages.theme;
  String get lightTheme => _languages.lightTheme;
  String get darkTheme => _languages.darkTheme;
  String get systemTheme => _languages.systemTheme;
  String get businessInfo => _languages.businessInfo;
  String get businessName => _languages.businessName;
  String get businessPhone => _languages.businessPhone;
  String get businessLogo => _languages.businessLogo;
  String get currency => _languages.currency;
  String get subscription => _languages.subscription;
  String get backupRestore => _languages.backupRestore;
  String get backup => _languages.backup;
  String get restore => _languages.restore;
  String get backupSuccess => _languages.backupSuccess;
  String get restoreSuccess => _languages.restoreSuccess;
  String get trialVersion => _languages.trialVersion;
  String get trialDaysLeft => _languages.trialDaysLeft;
  String get upgradeToPremium => _languages.upgradeToPremium;
  String get premiumFeatures => _languages.premiumFeatures;
  String get selectCurrency => _languages.selectCurrency;
  String get currencySelected => _languages.currencySelected;
  String get notSelected => _languages.currencyNotSelected;
  
  // Format date based on locale
  String formatDate(DateTime date) {
    return DateFormat.yMMMd(locale.languageCode).format(date);
  }

  // Format currency based on locale and currency code
  String formatCurrency(double amount, String currencyCode) {
    return NumberFormat.currency(
      locale: locale.languageCode,
      symbol: _getCurrencySymbol(currencyCode),
    ).format(amount);
  }

  String _getCurrencySymbol(String code) {
    switch (code) {
      case 'USD':
        return '\$';
      case 'YER':
        return '﷼';
      case 'SAR':
        return '﷼';
    
      default:
        return '\$';
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
