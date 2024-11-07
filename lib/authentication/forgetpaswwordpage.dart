import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notse/components/materailbutton.dart';
import 'package:notse/components/textfont.dart';
import 'package:notse/components/textformfild.dart';

class ForGetPasswordPage extends StatefulWidget {
  const ForGetPasswordPage({super.key});

  @override
  State<ForGetPasswordPage> createState() => _ForGetPasswordPageState();
}

class _ForGetPasswordPageState extends State<ForGetPasswordPage> {
  TextEditingController email = TextEditingController();

  void _sendResetLink() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset link sent to ${email.text}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Textfont(
            text: "Reset paswoord", color: Colors.white, size: 20, bold: true),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_reset,
                color: Colors.deepPurple,
                size: 80,
              ),
              const SizedBox(height: 20),
              const Textfont(
                text: "Forgot your password?",
                color: Colors.black,
                size: 24,
                bold: true,
              ),
              const SizedBox(height: 10),
              Text(
                "Enter your email below and we'll send you a link to reset your password.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
              const SizedBox(height: 30),
              CustomTextFormFild(
                prefixIcon: const Icon(Icons.abc),
                hint: "Enter your email",
                controller: email,
              ),
              const SizedBox(height: 20),
              CustomMaterailButoon(
                color: Colors.deepPurple,
                onPressed: _sendResetLink,
                child: const Textfont(
                  text: "Send Reset Link",
                  color: Colors.white,
                  size: 18,
                  bold: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
