import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udyogmitra/src/config/route_generator.dart';
import 'package:udyogmitra/src/pages/auth/wrapper.dart';
// import 'package:udyogmitra/src/pages/auth/signup.dart';

class UdyogMitraApp extends StatelessWidget {
  const UdyogMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'UdyogMitra',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
          ),
        ),
        home: Wrapper(),
        onGenerateRoute: generateRoute,
      ),
    );
  }
}

