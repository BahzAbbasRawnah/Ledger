import 'package:flutter/material.dart';
import 'package:ledger/core/constants/app_constants.dart';
import 'package:ledger/core/localization/app_localizations.dart';
import 'package:ledger/presentation/widgets/app_widgets.dart';


class ReportHeader extends StatelessWidget {
  const ReportHeader({super.key});


  @override
  Widget build(BuildContext context) {
         final localizations = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left Titles
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MediumText(AppConstants.prefBusinessName),
            SmallText(AppConstants.prefBusinessLocation),
            SmallText(AppConstants.prefBusinessPhone),

          ],
        ),
        // Center Logo
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Image.asset(AppConstants.appLogo),

        ),
        // Right Titles
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MediumText(AppConstants.prefBusinessName),
            SmallText(AppConstants.prefBusinessLocation),
            SmallText(AppConstants.prefBusinessPhone),
          ],
        ),
      ],
    );
  }
}