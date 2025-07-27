import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udyogmitra/src/config/themes/app_theme.dart';
import 'package:udyogmitra/src/config/themes/app_theme_provider.dart';
import 'package:udyogmitra/src/config/route_generator.dart';
import 'package:udyogmitra/src/pages/auth/wrapper.dart';
// import 'package:udyogmitra/src/pages/auth/signup.dart';

class UdyogMitraApp extends ConsumerWidget {
  const UdyogMitraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return ProviderScope(
      child: MaterialApp(
        title: 'UdyogMitra',
        debugShowCheckedModeBanner: false,
        themeMode: themeMode,
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        home: Wrapper(),
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
