import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:udyogmitra/src/pages/auth/forgot-pass.dart';
import 'package:udyogmitra/src/services/google_auth_service.dart';
import 'package:udyogmitra/src/widgets/google_signin_button.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onToggle;
  const LoginPage({Key? key, this.onToggle}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  String? _error;

  Future<void> _login() async {
    // Validate input fields
    if (_emailController.text.trim().isEmpty) {
      setState(() => _error = 'Please enter your email');
      return;
    }
    if (_passwordController.text.trim().isEmpty) {
      setState(() => _error = 'Please enter your password');
      return;
    }
    if (!_isValidEmail(_emailController.text.trim())) {
      setState(() => _error = 'Please enter a valid email address');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigation will be handled by the auth state in Wrapper
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'user-not-found':
            _error = 'No user found with this email address';
            break;
          case 'wrong-password':
            _error = 'Incorrect password';
            break;
          case 'user-disabled':
            _error = 'This account has been disabled';
            break;
          case 'too-many-requests':
            _error = 'Too many failed attempts. Please try again later';
            break;
          case 'invalid-email':
            _error = 'Invalid email address';
            break;
          case 'network-request-failed':
            _error = 'Network error. Please check your connection';
            break;
          default:
            _error = e.message ?? 'An error occurred during login';
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

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
      _error = null;
    });

    try {
      final userCredential = await GoogleAuthService.signInWithGoogle();

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
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // Google Sign-In Button
            GoogleSignInButtonIcon(
              onPressed: _signInWithGoogle,
              isLoading: _isGoogleLoading,
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
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordPage(),
                    ),
                  );
                },
                child: const Text('Forgot Password?'),
              ),
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
                      Text('Signing you in...'),
                    ],
                  )
                : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Login with Email'),
                  ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Not a user? "),
                TextButton(
                  onPressed: widget.onToggle,
                  child: const Text('Sign Up'),
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
