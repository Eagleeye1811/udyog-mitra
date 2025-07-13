import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:udyogmitra/src/services/google_auth_service.dart';
import 'package:udyogmitra/src/widgets/google_signin_button.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback? onToggle;
  const SignUpPage({Key? key, this.onToggle}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  String? _error;

  Future<void> _signUp() async {
    // Validate input fields
    if (_emailController.text.trim().isEmpty) {
      setState(() => _error = 'Please enter your email');
      return;
    }
    if (_passwordController.text.trim().isEmpty) {
      setState(() => _error = 'Please enter your password');
      return;
    }
    if (_confirmPasswordController.text.trim().isEmpty) {
      setState(() => _error = 'Please confirm your password');
      return;
    }
    if (!_isValidEmail(_emailController.text.trim())) {
      setState(() => _error = 'Please enter a valid email address');
      return;
    }
    if (_passwordController.text.trim().length < 6) {
      setState(() => _error = 'Password must be at least 6 characters');
      return;
    }
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      setState(() => _error = "Passwords do not match");
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      // Send email verification
      await result.user!.sendEmailVerification();

      // Navigation will be handled by the auth state in Wrapper
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'weak-password':
            _error = 'Password is too weak. Use at least 6 characters';
            break;
          case 'email-already-in-use':
            _error = 'An account already exists with this email';
            break;
          case 'invalid-email':
            _error = 'Invalid email address';
            break;
          case 'operation-not-allowed':
            _error = 'Email/password accounts are not enabled';
            break;
          case 'network-request-failed':
            _error = 'Network error. Please check your connection';
            break;
          default:
            _error = e.message ?? 'An error occurred during sign up';
        }
      });
    } catch (e) {
      setState(() {
        _error = 'An unexpected error occurred. Please try again';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _signUpWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
      _error = null;
    });

    try {
      final userCredential = await GoogleAuthService.signUpWithGoogle();

      if (userCredential == null) {
        // User canceled the sign-in
        setState(() {
          _isGoogleLoading = false;
        });
        return;
      }

      // Navigation will be handled by the auth state in Wrapper
    } catch (e) {
      setState(() {
        _error = GoogleAuthService.getErrorMessage(e);
      });
    } finally {
      setState(() {
        _isGoogleLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        automaticallyImplyLeading: false, // Remove back arrow
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // Google Sign-In Button
            GoogleSignInButtonIcon(
              onPressed: _signUpWithGoogle,
              isLoading: _isGoogleLoading,
              text: 'Sign up with Google',
            ),

            const SizedBox(height: 24),
            const OrDivider(),
            const SizedBox(height: 24),

            // Email/Password Section
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            _isLoading
                ? const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Creating your account...'),
                    ],
                  )
                : ElevatedButton(
                    onPressed: _signUp,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Sign Up with Email'),
                  ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already a user? "),
                TextButton(
                  onPressed: widget.onToggle,
                  child: const Text('Login'),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
