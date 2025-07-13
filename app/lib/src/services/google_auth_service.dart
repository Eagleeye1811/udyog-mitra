import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Sign in with Google
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        if (kDebugMode) {
          print('Google Sign-In: User canceled the sign-in');
        }
        return null;
      }

      if (kDebugMode) {
        print('Google Sign-In: User signed in: ${googleUser.email}');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      if (kDebugMode) {
        print('Firebase Auth: User signed in successfully');
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Firebase Auth Error: ${e.code} - ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Google Sign-In Error: $e');
      }
      rethrow;
    }
  }

  // Sign up with Google (same as sign in for OAuth)
  static Future<UserCredential?> signUpWithGoogle() async {
    return await signInWithGoogle();
  }

  // Sign out from Google and Firebase
  static Future<void> signOut() async {
    try {
      // Sign out from Google
      await _googleSignIn.signOut();
      if (kDebugMode) {
        print('Google Sign-Out: User signed out from Google');
      }

      // Sign out from Firebase
      await _auth.signOut();
      if (kDebugMode) {
        print('Firebase Auth: User signed out from Firebase');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Sign Out Error: $e');
      }
      rethrow;
    }
  }

  // Check if current user is signed in with Google
  static bool isSignedInWithGoogle() {
    final user = _auth.currentUser;
    if (user == null) return false;

    return user.providerData.any(
      (provider) => provider.providerId == 'google.com',
    );
  }

  // Get user display name
  static String? getUserDisplayName() {
    final user = _auth.currentUser;
    return user?.displayName;
  }

  // Get user email
  static String? getUserEmail() {
    final user = _auth.currentUser;
    return user?.email;
  }

  // Get user photo URL
  static String? getUserPhotoUrl() {
    final user = _auth.currentUser;
    return user?.photoURL;
  }

  // Handle auth errors with user-friendly messages
  static String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'account-exists-with-different-credential':
          return 'An account already exists with this email but different sign-in credentials';
        case 'invalid-credential':
          return 'The credential is malformed or has expired';
        case 'operation-not-allowed':
          return 'Google sign-in is not enabled for this app';
        case 'user-disabled':
          return 'Your account has been disabled';
        case 'user-not-found':
          return 'No account found with this email';
        case 'wrong-password':
          return 'Invalid password';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection';
        case 'too-many-requests':
          return 'Too many failed attempts. Please try again later';
        default:
          return error.message ?? 'An error occurred during authentication';
      }
    } else if (error.toString().contains('sign_in_canceled')) {
      return 'Sign-in was cancelled';
    } else if (error.toString().contains('network_error')) {
      return 'Network error. Please check your internet connection';
    } else {
      return 'An unexpected error occurred. Please try again';
    }
  }
}
