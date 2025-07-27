import 'package:flutter/material.dart';

@immutable
class AppCardTheme extends ThemeExtension<AppCardTheme> {
  final BoxDecoration primaryCard;
  final BoxDecoration secondaryCard;
  final BoxDecoration greenCard;
  final BoxDecoration greenTransparentCard;

  final BoxShadow cardShadow;

  final LinearGradient greenGradient;

  const AppCardTheme({
    required this.primaryCard,
    required this.secondaryCard,
    required this.greenCard,
    required this.greenTransparentCard,

    required this.cardShadow,

    required this.greenGradient,
  });

  @override
  AppCardTheme copyWith({
    BoxDecoration? primaryCard,
    BoxDecoration? secondaryCard,
    BoxDecoration? greenCard,
    BoxDecoration? greenTransparentCard,

    BoxShadow? cardShadow,

    LinearGradient? greenGradient,
  }) {
    return AppCardTheme(
      primaryCard: primaryCard ?? this.primaryCard,
      secondaryCard: secondaryCard ?? this.secondaryCard,
      greenCard: greenCard ?? this.greenCard,
      greenTransparentCard: greenTransparentCard ?? this.greenTransparentCard,

      cardShadow: cardShadow ?? this.cardShadow,

      greenGradient: greenGradient ?? this.greenGradient,
    );
  }

  @override
  ThemeExtension<AppCardTheme> lerp(
    covariant ThemeExtension<AppCardTheme>? other,
    double t,
  ) {
    if (other is! AppCardTheme) return this;
    return AppCardTheme(
      primaryCard: BoxDecoration.lerp(primaryCard, other.primaryCard, t)!,
      secondaryCard: BoxDecoration.lerp(secondaryCard, other.secondaryCard, t)!,
      greenCard: BoxDecoration.lerp(greenCard, other.greenCard, t)!,
      greenTransparentCard: BoxDecoration.lerp(
        greenTransparentCard,
        other.greenTransparentCard,
        t,
      )!,

      cardShadow: BoxShadow.lerp(cardShadow, other.cardShadow, t)!,

      greenGradient: LinearGradient.lerp(
        greenGradient,
        other.greenGradient,
        t,
      )!,
    );
  }
}

// Light Card Theme
final appCardThemeLight = AppCardTheme(
  primaryCard: BoxDecoration(
    color: Colors.grey.shade100,
    borderRadius: BorderRadius.circular(15),
  ),
  secondaryCard: BoxDecoration(
    color: Colors.grey.shade200,
    borderRadius: BorderRadius.circular(15),
  ),

  greenCard: BoxDecoration(
    color: Colors.green,
    borderRadius: BorderRadius.circular(20),
  ),

  greenTransparentCard: BoxDecoration(
    color: const Color.fromARGB(255, 216, 247, 217),
    borderRadius: BorderRadius.circular(15),
  ),

  cardShadow: BoxShadow(
    color: Colors.black38,
    offset: Offset(0, 2),
    blurRadius: 2,
    spreadRadius: 1,
  ),

  greenGradient: LinearGradient(
    colors: [Colors.green.shade100, Colors.green.shade50],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
);

// Dark Card Theme
final appCardThemeDark = AppCardTheme(
  primaryCard: BoxDecoration(
    color: Colors.grey.shade900,
    borderRadius: BorderRadius.circular(15),
  ),
  secondaryCard: BoxDecoration(
    color: const Color.fromARGB(255, 50, 50, 50),
    borderRadius: BorderRadius.circular(15),
  ),

  greenCard: BoxDecoration(
    color: const Color.fromARGB(255, 39, 138, 42),
    borderRadius: BorderRadius.circular(20),
  ),

  greenTransparentCard: BoxDecoration(
    color: const Color.fromARGB(111, 71, 146, 72),
    borderRadius: BorderRadius.circular(15),
  ),

  cardShadow: BoxShadow(
    color: const Color.fromARGB(29, 189, 189, 189),
    offset: Offset(0, 2),
    blurRadius: 4,
    spreadRadius: 1,
  ),

  greenGradient: LinearGradient(
    colors: [
      Colors.green.shade600.withAlpha(60),
      Colors.green.shade400.withAlpha(60),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
);
