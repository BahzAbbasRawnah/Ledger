import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../bloc/settings/settings_event.dart';
import '../../bloc/settings/settings_state.dart';
import 'business_info_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
      ),
      body: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          } else if (state is SettingsBackupSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.backupSuccess),
                backgroundColor: AppTheme.successColor,
              ),
            );
          } else if (state is SettingsRestoreSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.restoreSuccess),
                backgroundColor: AppTheme.successColor,
              ),
            );
          }
        },
        child: ListView(
          children: [
            // App info
            _buildAppInfoSection(context),

            const Divider(),

            // Language settings
            _buildLanguageSection(context),

            const Divider(),

            // Theme settings
            _buildThemeSection(context),

            const Divider(),

            // Business info
            _buildBusinessInfoSection(context),

            const Divider(),

            // Currency settings
            _buildCurrencySection(context),

            const Divider(),

            // Backup & Restore
            _buildBackupRestoreSection(context),

            const Divider(),

            // Subscription info
            _buildSubscriptionSection(context),

            const Divider(),

            // Logout
            _buildLogoutSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoSection(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info),
      title: Text(AppConstants.appName),
      subtitle: Text('v${AppConstants.appVersion}'),
    );
  }

  Widget _buildLanguageSection(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) =>
          current is SettingsLoadedState ||
          current is SettingsLanguageChangedState,
      builder: (context, state) {
        String currentLanguage = 'en';

        if (state is SettingsLoadedState) {
          currentLanguage = state.languageCode;
        } else if (state is SettingsLanguageChangedState) {
          currentLanguage = state.languageCode;
        }

        return ListTile(
          leading: const Icon(Icons.language),
          title: Text(localizations.language),
          subtitle: Text(_getLanguageName(currentLanguage)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showLanguageDialog(context, currentLanguage);
          },
        );
      },
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) =>
          current is SettingsLoadedState ||
          current is SettingsThemeChangedState,
      builder: (context, state) {
        ThemeMode currentTheme = ThemeMode.system;

        if (state is SettingsLoadedState) {
          currentTheme = state.themeMode;
        } else if (state is SettingsThemeChangedState) {
          currentTheme = state.themeMode;
        }

        return ListTile(
          leading: const Icon(Icons.palette),
          title: Text(localizations.theme),
          subtitle: Text(_getThemeName(currentTheme, localizations)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showThemeDialog(context, currentTheme);
          },
        );
      },
    );
  }

  Widget _buildBusinessInfoSection(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
          current is AuthAuthenticatedState ||
          current is AuthBusinessInfoUpdatedState,
      builder: (context, state) {
        String? businessName;

        if (state is AuthAuthenticatedState) {
          businessName = state.user.businessName;
        } else if (state is AuthBusinessInfoUpdatedState) {
          businessName = state.user.businessName;
        }

        return ListTile(
          leading: const Icon(Icons.business),
          title: Text(localizations.businessInfo),
          subtitle: Text(businessName ?? localizations.notSet),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const BusinessInfoScreen(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCurrencySection(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) =>
          current is SettingsLoadedState ||
          current is SettingsCurrencyChangedState,
      builder: (context, state) {
        String currentCurrency = 'USD';

        if (state is SettingsLoadedState) {
          currentCurrency = state.currencyCode;
        } else if (state is SettingsCurrencyChangedState) {
          currentCurrency = state.currencyCode;
        }

        return ListTile(
          leading: const Icon(Icons.attach_money),
          title: Text(localizations.currency),
          subtitle: Text(_getCurrencyName(currentCurrency)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showCurrencyDialog(context, currentCurrency);
          },
        );
      },
    );
  }

  Widget _buildBackupRestoreSection(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.backup),
          title: Text(localizations.backup),
          onTap: () {
            context.read<SettingsBloc>().add(SettingsBackupDataEvent());
          },
        ),
        ListTile(
          leading: const Icon(Icons.restore),
          title: Text(localizations.restore),
          onTap: () {
            _showRestoreConfirmationDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildSubscriptionSection(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
          current is AuthAuthenticatedState ||
          current is AuthPremiumUpgradedState,
      builder: (context, state) {
        bool isPremium = false;
        DateTime? trialEndDate;

        if (state is AuthAuthenticatedState) {
          isPremium = state.user.isPremium;
          trialEndDate = state.user.trialEndDate;
        } else if (state is AuthPremiumUpgradedState) {
          isPremium = state.user.isPremium;
          trialEndDate = state.user.trialEndDate;
        }

        if (isPremium) {
          return ListTile(
            leading: const Icon(Icons.star, color: Colors.amber),
            title: Text(localizations.premiumVersion),
            subtitle: Text(localizations.thanksForYourSupport),
          );
        } else {
          final daysLeft = trialEndDate != null
              ? trialEndDate.difference(DateTime.now()).inDays
              : 0;

          return ListTile(
            leading: const Icon(Icons.star_border),
            title: Text(localizations.trialVersion),
            subtitle: Text('${localizations.trialDaysLeft} $daysLeft'),
            trailing: TextButton(
              onPressed: () {
                _showUpgradeDialog(context);
              },
              child: Text(localizations.upgradeToPremium),
            ),
          );
        }
      },
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return ListTile(
      leading: const Icon(Icons.logout, color: AppTheme.errorColor),
      title: Text(
        localizations.logout,
        style: const TextStyle(color: AppTheme.errorColor),
      ),
      onTap: () {
        _showLogoutConfirmationDialog(context);
      },
    );
  }

  void _showLanguageDialog(BuildContext context, String currentLanguage) {
    final localizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppConstants.supportedLanguages.map((language) {
              return RadioListTile<String>(
                title: Text(language['name'] as String),
                value: language['code'] as String,
                groupValue: currentLanguage,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsBloc>().add(
                          SettingsChangeLanguageEvent(languageCode: value),
                        );
                    Navigator.of(context).pop();
                  }
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localizations.cancel),
            ),
          ],
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context, ThemeMode currentTheme) {
    final localizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.theme),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: Text(localizations.lightTheme),
                value: ThemeMode.light,
                groupValue: currentTheme,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsBloc>().add(
                          SettingsChangeThemeEvent(themeMode: value),
                        );
                    Navigator.of(context).pop();
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: Text(localizations.darkTheme),
                value: ThemeMode.dark,
                groupValue: currentTheme,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsBloc>().add(
                          SettingsChangeThemeEvent(themeMode: value),
                        );
                    Navigator.of(context).pop();
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: Text(localizations.systemTheme),
                value: ThemeMode.system,
                groupValue: currentTheme,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsBloc>().add(
                          SettingsChangeThemeEvent(themeMode: value),
                        );
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localizations.cancel),
            ),
          ],
        );
      },
    );
  }

  void _showCurrencyDialog(BuildContext context, String currentCurrency) {
    final localizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.currency),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppConstants.supportedCurrencies.map((currency) {
              return RadioListTile<String>(
                title: Text(
                    '${currency['code']} (${currency['symbol']}) - ${currency['name']}'),
                value: currency['code'] as String,
                groupValue: currentCurrency,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsBloc>().add(
                          SettingsChangeCurrencyEvent(currencyCode: value),
                        );
                    Navigator.of(context).pop();
                  }
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localizations.cancel),
            ),
          ],
        );
      },
    );
  }

  void _showRestoreConfirmationDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.restore),
          content: Text(localizations.restoreConfirmation),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localizations.cancel),
            ),
            TextButton(
              onPressed: () {
                context.read<SettingsBloc>().add(SettingsRestoreDataEvent());
                Navigator.of(context).pop();
              },
              child: Text(localizations.confirm),
            ),
          ],
        );
      },
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.upgradeToPremium),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(localizations.premiumFeatures),
              const SizedBox(height: 16),
              _buildPremiumFeature(
                context,
                Icons.sync,
                localizations.syncAcrossDevices,
              ),
              _buildPremiumFeature(
                context,
                Icons.people,
                localizations.clientAccess,
              ),
              _buildPremiumFeature(
                context,
                Icons.cloud,
                localizations.automaticBackup,
              ),
              _buildPremiumFeature(
                context,
                Icons.support_agent,
                localizations.prioritySupport,
              ),
              const SizedBox(height: 16),
              Text(
                localizations.subscriptionPrice,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localizations.notNow),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthUpgradeToPremiumEvent());
                Navigator.of(context).pop();
              },
              child: Text(localizations.subscribe),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPremiumFeature(
      BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.logout),
          content: Text(localizations.logoutConfirmation),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localizations.cancel),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutEvent());
                Navigator.of(context).pop();
              },
              child: Text(localizations.confirm),
            ),
          ],
        );
      },
    );
  }

  String _getLanguageName(String code) {
    final language = AppConstants.supportedLanguages.firstWhere(
      (lang) => lang['code'] == code,
      orElse: () => {'code': 'en', 'name': 'English'},
    );

    return language['name'] as String;
  }

  String _getThemeName(ThemeMode themeMode, AppLocalizations localizations) {
    switch (themeMode) {
      case ThemeMode.light:
        return localizations.lightTheme;
      case ThemeMode.dark:
        return localizations.darkTheme;
      case ThemeMode.system:
        return localizations.systemTheme;
    }
  }

  String _getCurrencyName(String code) {
    final currency = AppConstants.supportedCurrencies.firstWhere(
      (curr) => curr['code'] == code,
      orElse: () => {'code': 'USD', 'symbol': '\$', 'name': 'US Dollar'},
    );

    return '${currency['code']} (${currency['symbol']})';
  }
}
