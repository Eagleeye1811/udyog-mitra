import 'package:flutter/material.dart';
import 'package:udyogmitra/src/config/app_routes.dart';
import 'package:udyogmitra/src/config/route_generator.dart';

class UdyogMitraApp extends StatelessWidget {
  const UdyogMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UdyogMitra',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      onGenerateRoute: generateRoute,
    );
  }
}