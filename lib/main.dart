import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notse/Catagores/catagoresadd.dart';
import 'package:notse/authentication/forgetpaswwordpage.dart';
import 'package:notse/authentication/login.dart';
import 'package:notse/authentication/regester.dart';
import 'package:notse/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('******************************User is currently signed out!');
      } else {
        print('******************************User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "RegesterPage": (context) => const RegisterPage(),
        "LoginPage": (context) => const LoginPage(),
        "HomePage": (context) => const Homepage(),
        "ForGetPasswordPage": (context) => const ForGetPasswordPage(),
        "AddPage": (context) => const CatagoresAddSection(),
      },
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      )),
      home: FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified
          ? Homepage()
          : LoginPage(),
    );
  }
}
