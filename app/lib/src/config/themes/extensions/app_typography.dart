import 'package:flutter/material.dart';

@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  final TextStyle appBarTitle;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;
  final TextStyle cardTitleLarge;
  final TextStyle cardTitleMedium;
  final TextStyle cardTitleSmall;

  final Color greenColor;
  final Color greyColor;
  final Color darkGreyColor;

  const AppTypography({
    required this.appBarTitle,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    required this.cardTitleLarge,
    required this.cardTitleMedium,
    required this.cardTitleSmall,

    required this.greenColor,
    required this.greyColor,
    required this.darkGreyColor,
  });

  @override
  AppTypography copyWith({
    TextStyle? appBarTitle,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
    TextStyle? cardTitleLarge,
    TextStyle? cardTitleMedium,
    TextStyle? cardTitleSmall,

    Color? greenColor,
    Color? greyColor,
    Color? darkGreyColor,
  }) {
    return AppTypography(
      appBarTitle: appBarTitle ?? this.appBarTitle,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
      cardTitleLarge: cardTitleLarge ?? this.cardTitleLarge,
      cardTitleMedium: cardTitleMedium ?? this.cardTitleMedium,
      cardTitleSmall: cardTitleSmall ?? this.cardTitleSmall,

      greenColor: greenColor ?? this.greenColor,
      greyColor: greyColor ?? this.greyColor,
      darkGreyColor: darkGreyColor ?? this.darkGreyColor,
    );
  }

  @override
  ThemeExtension<AppTypography> lerp(
    covariant ThemeExtension<AppTypography>? other,
    double t,
  ) {
    if (other is! AppTypography) return this;

    return AppTypography(
      appBarTitle: TextStyle.lerp(appBarTitle, other.appBarTitle, t)!,

      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      titleSmall: TextStyle.lerp(titleSmall, other.titleSmall, t)!,

      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,

      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t)!,
      labelMedium: TextStyle.lerp(labelMedium, other.labelMedium, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,

      cardTitleLarge: TextStyle.lerp(cardTitleLarge, other.cardTitleLarge, t)!,
      cardTitleMedium: TextStyle.lerp(
        cardTitleMedium,
        other.cardTitleMedium,
        t,
      )!,
      cardTitleSmall: TextStyle.lerp(cardTitleSmall, other.cardTitleSmall, t)!,

      greenColor: Color.lerp(greenColor, other.greenColor, t)!,
      greyColor: Color.lerp(greyColor, other.greyColor, t)!,
      darkGreyColor: Color.lerp(darkGreyColor, other.darkGreyColor, t)!,
    );
  }
}

// Light Theme AppTypography
final appTypographyLight = AppTypography(
  appBarTitle: TextStyle(
    color: Colors.green,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),

  titleLarge: TextStyle(
    color: Colors.black,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
  titleMedium: TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  ),
  titleSmall: TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),

  bodyLarge: TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  ),
  bodyMedium: TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  ),
  bodySmall: TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),

  labelLarge: TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
  labelMedium: TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
  labelSmall: TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),

  cardTitleLarge: TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  ),
  cardTitleMedium: TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
  cardTitleSmall: TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),

  greenColor: Colors.green,
  greyColor: Colors.grey.shade800,
  darkGreyColor: Colors.grey.shade900,
);

// Dark Theme AppTypography
final appTypographyDark = AppTypography(
  appBarTitle: TextStyle(
    color: Colors.green,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),

  titleLarge: TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
  titleMedium: TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  ),
  titleSmall: TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),

  bodyLarge: TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  ),
  bodyMedium: TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  ),
  bodySmall: TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),

  labelLarge: TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
  labelMedium: TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
  labelSmall: TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),

  cardTitleLarge: TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  ),
  cardTitleMedium: TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
  cardTitleSmall: TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),

  greenColor: const Color.fromARGB(255, 38, 117, 41),
  greyColor: Colors.grey.shade300,
  darkGreyColor: Colors.grey.shade400,
);
