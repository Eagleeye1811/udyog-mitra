import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _message;

  Future<void> _resetPassword() async {
    // Validate input fields
    if (_emailController.text.trim().isEmpty) {
      setState(() => _message = 'Please enter your email address');
      return;
    }
    if (!_isValidEmail(_emailController.text.trim())) {
      setState(() => _message = 'Please enter a valid email address');
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      setState(() {
        _message =
            'Password reset email sent! Check your inbox and spam folder.';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'user-not-found':
            _message = 'No account found with this email address';
            break;
          case 'invalid-email':
            _message = 'Invalid email address';
            break;
          case 'network-request-failed':
            _message = 'Network error. Please check your connection';
            break;
          case 'too-many-requests':
            _message = 'Too many requests. Please try again later';
            break;
          default:
            _message = e.message ?? 'An error occurred. Please try again';
        }
      });
    } catch (e) {
      setState(() {
        _message = 'An unexpected error occurred. Please try again';
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
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_reset, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              'Reset Your Password',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Enter your email address and we\'ll send you a link to reset your password.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Sending reset email...'),
                    ],
                  )
                : ElevatedButton(
                    onPressed: _resetPassword,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Send Reset Email'),
                  ),
            const SizedBox(height: 24),
            if (_message != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      _message ==
                          'Password reset email sent! Check your inbox and spam folder.'
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  border: Border.all(
                    color:
                        _message ==
                            'Password reset email sent! Check your inbox and spam folder.'
                        ? Colors.green.shade200
                        : Colors.red.shade200,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _message ==
                              'Password reset email sent! Check your inbox and spam folder.'
                          ? Icons.check_circle
                          : Icons.error,
                      color:
                          _message ==
                              'Password reset email sent! Check your inbox and spam folder.'
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _message!,
                        style: TextStyle(
                          color:
                              _message ==
                                  'Password reset email sent! Check your inbox and spam folder.'
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
