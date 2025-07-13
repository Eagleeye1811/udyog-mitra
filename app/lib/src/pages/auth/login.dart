import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:udyogmitra/src/pages/auth/forgot-pass.dart'; // Import the ForgotPasswordPage

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
              Text(_error!, style: const TextStyle(color: Colors.red)),
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
                    child: const Text('Login'),
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
          ],
        ),
      ),
    );
  }
}
