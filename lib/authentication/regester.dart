import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notse/components/materailbutton.dart';
import 'package:notse/components/sps.dart';
import 'package:notse/components/textfont.dart';
import 'package:notse/components/textformfild.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool islogingoogle = false, islogin = false;
  Future signInWithGoogle() async {
    islogingoogle = true;
    setState(() {});
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        islogingoogle = false;
        setState(() {});
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      islogingoogle = false;

      if (mounted) {
        Navigator.of(context).pushReplacementNamed("HomePage");
      }
    } catch (e) {
      const SnackBar(
          content: Textfont(
              text: "erore", color: Colors.white, size: 15, bold: false));
    }
  }

  GlobalKey<FormState> validateKey = GlobalKey();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: validateKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Image.asset("images/file.png"),
                    ),
                  ),
                  const Sps(height: 30),
                  const Textfont(
                    text: "Create Account",
                    color: Colors.black,
                    size: 28,
                    bold: true,
                  ),
                  const Sps(height: 10),
                  const Textfont(
                    text: "Join us to start your journey",
                    color: Colors.black54,
                    size: 16,
                    bold: false,
                  ),
                  const Sps(height: 40),
                  const Textfont(
                    text: "Name",
                    color: Colors.black87,
                    size: 18,
                    bold: true,
                  ),
                  const Sps(height: 5),
                  CustomTextFormFild(
                    prefixIcon: const Icon(Icons.person_outline,
                        color: Colors.deepPurple),
                    hint: "Enter your full name",
                    controller: name,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter your name";
                      } else if (val.length < 5) {
                        return "Enter a valid name";
                      }
                      return null;
                    },
                  ),
                  const Sps(height: 20),
                  const Textfont(
                    text: "Email",
                    color: Colors.black87,
                    size: 18,
                    bold: true,
                  ),
                  const Sps(height: 5),
                  CustomTextFormFild(
                    prefixIcon: const Icon(Icons.email_outlined,
                        color: Colors.deepPurple),
                    hint: "Enter your email",
                    controller: email,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter your email";
                      } else if (val.length < 10) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const Sps(height: 20),
                  const Textfont(
                    text: "Password",
                    color: Colors.black87,
                    size: 18,
                    bold: true,
                  ),
                  const Sps(height: 5),
                  CustomTextFormFild(
                    prefixIcon: const Icon(Icons.lock_outline,
                        color: Colors.deepPurple),
                    hint: "Enter your password",
                    controller: password,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter your password";
                      } else if (val.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const Sps(height: 30),
                  CustomMaterailButoon(
                    onPressed: () async {
                      if (validateKey.currentState!.validate()) {
                        islogin = true;
                        setState(() {});
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          );
                          islogin = false;
                          setState(() {});

                          Alert(
                            context: context,
                            type: AlertType.success,
                            title: "Registration Successful",
                            desc: "Check your email for confirmation.",
                            buttons: [
                              DialogButton(
                                onPressed: () {
                                  FirebaseAuth.instance.currentUser!
                                      .sendEmailVerification();
                                  Navigator.of(context)
                                      .pushReplacementNamed("LoginPage");
                                },
                                color: Colors.green,
                                width: 160,
                                child: const Text(
                                  "Verify Email",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              )
                            ],
                          ).show();
                        } on FirebaseAuthException catch (e) {
                          String error;
                          if (e.code == 'weak-password') {
                            error =
                                "Weak password, please choose a stronger password.";
                          } else if (e.code == 'email-already-in-use') {
                            error =
                                "An account with this email already exists.";
                          } else {
                            error = "An error occurred. Please try again.";
                          }

                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Registration Error",
                            desc: error,
                            buttons: [
                              DialogButton(
                                color: Colors.red,
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                                child: const Text(
                                  "OK",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              )
                            ],
                          ).show();
                        }
                      }
                    },
                    color: Colors.deepPurple,
                    child: islogin
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Textfont(
                            text: "Register",
                            color: Colors.white,
                            size: 20,
                            bold: true,
                          ),
                  ),
                  const Sps(height: 20),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    height: 55,
                    onPressed: () {
                      signInWithGoogle();
                    },
                    color: const Color(0xFFDB4437),
                    child: islogingoogle
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Textfont(
                                text: "Sign in with Google",
                                color: Colors.white,
                                size: 18,
                                bold: true,
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                height: 25,
                                width: 25,
                                child: Image.asset("images/googlelogo.png"),
                              )
                            ],
                          ),
                  ),
                  const Sps(height: 30),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed("LoginPage");
                      },
                      child: const Text(
                        "Already have an account? Log in",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
