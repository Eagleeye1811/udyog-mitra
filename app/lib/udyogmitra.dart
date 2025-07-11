import 'package:flutter/material.dart';
import 'package:udyogmitra/src/config/route_generator.dart';
import 'package:udyogmitra/src/pages/auth/wrapper.dart';
// import 'package:udyogmitra/src/pages/auth/signup.dart';

class UdyogMitraApp extends StatelessWidget {
  const UdyogMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UdyogMitra',
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
      onGenerateRoute: generateRoute,
    );
  }
}
