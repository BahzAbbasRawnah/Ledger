import 'package:flutter/material.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/data_utils.dart';
import '../../../data/models/client_model.dart';

class ClientItem extends StatelessWidget {
  final dynamic client;
  final AppLocalizations localizations;
  final VoidCallback onTap;
  final VoidCallback onAddTransaction;

  const ClientItem({
    super.key,
    required this.client,
    required this.localizations,
    required this.onTap,
    required this.onAddTransaction,
  });

  @override
  Widget build(BuildContext context) {
    // Get financial data from client model
    double totalCredit = client.sumCredit ?? 0.0;
    double totalDebit = client.sumDebit ?? 0.0;
    double balance = client.balance;
    bool isCredit = balance >= 0;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -------------------- Card Header: Client Info --------------------
                  Row(
                    children: [
                      // اسم العميل
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.person,
                                size: 20, color: AppTheme.primaryColor),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                client.name ?? localizations.client,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // رقم الهاتف
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.phone,
                                size: 20, color: AppTheme.primaryColor),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                client.phoneNumber,
                                style: TextStyle(color: Colors.grey[600]),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                  // -------------------- Card Body: Financial Info --------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _InfoColumn(
                        icon: Icons.arrow_downward,
                        iconColor: AppTheme.successColor,
                        label: localizations.Credit,
                        value: DataUtils.formatCurrency(totalCredit,
                            currencyCode: 'YER'),
                      ),
                      _InfoColumn(
                        icon: Icons.arrow_upward,
                        iconColor: AppTheme.errorColor,
                        label: localizations.Debit,
                        value: DataUtils.formatCurrency(totalDebit,
                            currencyCode: 'YER'),
                      ),
                      _InfoColumn(
                        icon:
                            isCredit ? Icons.trending_down : Icons.trending_up,
                        iconColor: isCredit
                            ? AppTheme.successColor
                            : AppTheme.errorColor,
                        label: localizations.balance,
                        value: DataUtils.formatCurrency(balance.abs(),
                            currencyCode: 'YER'),
                      ),
                      if (client.financialCeiling > 0)
                        _InfoColumn(
                          icon: Icons.warning_amber_rounded,
                          iconColor: AppTheme.warningColor,
                          label: localizations.ceiling,
                          value: DataUtils.formatCurrency(
                              client.financialCeiling,
                              currencyCode: 'YER'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // -------------------- Floating Add Button (Top Left) --------------------
          Positioned(
            top: 4,
            left: 4,
            child: IconButton(
              icon: const Icon(Icons.add_circle,
                  size: 30, color: AppTheme.primaryColor),
              onPressed: onAddTransaction,
              tooltip: localizations.addTransaction,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoColumn({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize:
              MainAxisSize.min, // Prevents the Row from expanding fully
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            Icon(icon, color: iconColor, size: 16),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: iconColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
