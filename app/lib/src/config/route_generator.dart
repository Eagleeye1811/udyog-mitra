import 'package:flutter/material.dart';
import 'package:udyogmitra/src/config/app_routes.dart';
import 'package:udyogmitra/src/pages/features/chatbot/chatbot_screen.dart';
import 'package:udyogmitra/src/pages/home/home_screen.dart';
import 'package:udyogmitra/src/pages/profile/profile_page.dart';
import 'package:udyogmitra/src/pages/about/about_us_page.dart';
import 'package:udyogmitra/src/pages/features/business_planner/business_planner_screen.dart';
import 'package:udyogmitra/src/pages/features/idea_evaluator_standalone/idea_evaluator_screen.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.home:
      return MaterialPageRoute(builder: (_) => const HomeScreen());

    case AppRoutes.chatbot:
      return MaterialPageRoute(builder: (_) => const ChatbotScreen());

    case AppRoutes.profile:
      return MaterialPageRoute(builder: (_) => const ProfilePage());

    case AppRoutes.aboutUs:
      return MaterialPageRoute(builder: (_) => const AboutUsPage());

    case AppRoutes.businessPlanner:
      return MaterialPageRoute(builder: (_) => const BusinessPlannerScreen());

    case AppRoutes.ideaEvaluator:
      return MaterialPageRoute(builder: (_) => const IdeaEvaluatorScreen());

    default:
      return _errorRoute("404 - Page Not Found");
  }
}

Route<dynamic> _errorRoute(String message) {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(title: const Text("Error")),
      body: Center(child: Text(message)),
    ),
  );
}
