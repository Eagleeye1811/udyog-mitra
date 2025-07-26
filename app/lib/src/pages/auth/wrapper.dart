import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udyogmitra/src/pages/auth/login.dart';
import 'package:udyogmitra/src/pages/auth/signup.dart';
import 'package:udyogmitra/src/pages/auth/verify-email.dart';
import 'package:udyogmitra/src/pages/auth/user_profile_form.dart';
import 'package:udyogmitra/src/providers/user_profile_provider.dart';
import 'package:udyogmitra/src/pages/home/home_screen.dart';

class Wrapper extends ConsumerStatefulWidget {
  const Wrapper({super.key});

  @override
  ConsumerState<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends ConsumerState<Wrapper> {
  String? _lastUserId;
  bool showLogin = true;

  void toggle() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  Future<void> _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      showLogin = true; // Always show login page after logout
    });
  }

  @override
  void initState() {
    super.initState();
    // Listen to auth state changes and reset profile data when needed
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (_lastUserId != user?.uid) {
        // User changed - reset the profile state
        ref.read(userProfileProvider.notifier).resetStateForNewUser();
        _lastUserId = user?.uid;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use the authStateProvider we created
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Scaffold(
        body: Center(child: Text("Authentication error occurred")),
      ),
      data: (user) {
        // User is not logged in - show login/signup toggle
        if (user == null) {
          return showLogin
              ? LoginPage(onToggle: toggle)
              : SignUpPage(onToggle: toggle);
        }

        // If this is a new user, ensure we initialize a blank profile
        if (_lastUserId != user.uid) {
          final userProfile = ref.read(userProfileProvider);
          if (userProfile == null) {
            // Create a blank profile for the new user
            ref.read(userProfileProvider.notifier).initializeNewUserProfile();
          }
          _lastUserId = user.uid;
        }

        // Wait for profile to load
        final userProfile = ref.watch(userProfileProvider);
        if (userProfile == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Check if user has verified their email
        if (!user.emailVerified && !user.isAnonymous) {
          return const VerifyEmailPage();
        }

        // If profile is incomplete, directly show the profile form
        final bool isProfileComplete =
            userProfile.fullName.isNotEmpty &&
            userProfile.phoneNumber.isNotEmpty &&
            userProfile.gender.isNotEmpty &&
            userProfile.location.isNotEmpty;

        if (!isProfileComplete) {
          return const UserProfileFormPage();
        }

        // Everything complete - show home
        return const HomeScreen();
      },
    );
  }
}
