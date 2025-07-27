import 'package:flutter/material.dart';
import 'package:udyogmitra/src/config/themes/app_theme.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('Welcome User', style: context.textStyles.titleLarge),
      ),
    );
  }
}
