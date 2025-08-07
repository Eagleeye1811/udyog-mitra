import 'package:flutter/material.dart';
import 'package:udyogmitra/src/config/themes/app_theme.dart';

extension TextStyleExtension on TextStyle {
  TextStyle green() => copyWith(color: Colors.green);
  TextStyle black() => copyWith(color: Colors.black);
  TextStyle white() => copyWith(color: Colors.white);
  TextStyle grey(BuildContext context) =>
      copyWith(color: context.textStyles.greyColor);
  TextStyle darkGrey(BuildContext context) =>
      copyWith(color: context.textStyles.darkGreyColor);

  TextStyle bold() => copyWith(fontWeight: FontWeight.bold);
}

extension BoxDecorationExtension on BoxDecoration {
  BoxDecoration shadow(BuildContext context) =>
      copyWith(boxShadow: [context.cardStyles.cardShadow]);
}
