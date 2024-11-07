import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notse/components/materailbutton.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:notse/components/sps.dart';
import 'package:notse/components/textfont.dart';
import 'package:notse/components/textformfild.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isloding = false;
  bool islodinggoogle = false;
  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      islodinggoogle = false;
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
    islodinggoogle = false;
    if (mounted) {
      Navigator.of(context).pushReplacementNamed("HomePage");
    }
  }

  GlobalKey<FormState> validatekey = GlobalKey();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: validatekey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    text: "Welcome Back",
                    color: Colors.black,
                    size: 28,
                    bold: true,
                  ),
                  const Sps(height: 10),
                  const Textfont(
                    text: "Please sign in to continue",
                    color: Colors.black54,
                    size: 16,
                    bold: false,
                  ),
                  const Sps(height: 40),
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("ForGetPasswordPage");
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Sps(height: 20),
                  CustomMaterailButoon(
                    onPressed: () async {
                      if (validatekey.currentState!.validate()) {
                        isloding = true;
                        setState(() {});
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email.text, password: password.text);
                          if (FirebaseAuth
                              .instance.currentUser!.emailVerified) {
                            isloding = false;
                            Navigator.of(context)
                                .pushReplacementNamed("HomePage");
                          } else {
                            isloding = false;
                            setState(() {});

                            Alert(
                              context: context,
                              type: AlertType.error,
                              title: "Email Not Verified",
                              desc: "Please verify your email to log in.",
                              buttons: [
                                DialogButton(
                                  onPressed: () {
                                    FirebaseAuth.instance.currentUser!
                                        .sendEmailVerification();
                                    Navigator.of(context).pop();
                                  },
                                  color: Colors.green,
                                  width: 120,
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
                          }
                        } on FirebaseAuthException {
                          Alert(
                            context: context,
                            title: "Login Error",
                            desc: "Invalid email or password",
                            type: AlertType.error,
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
                    child: isloding
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Textfont(
                            text: "Login",
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
                      islodinggoogle = true;
                      setState(() {});
                      signInWithGoogle();
                    },
                    color: const Color(0xFFDB4437),
                    child: islodinggoogle
                        ? CircularProgressIndicator(
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
                        Navigator.of(context)
                            .pushReplacementNamed("RegesterPage");
                      },
                      child: const Text(
                        "Don't have an account? Register",
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
