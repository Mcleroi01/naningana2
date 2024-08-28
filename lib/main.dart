import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:naningana/intro/IntroPage.dart';
import 'package:naningana/pages/auth/auth.dart';
import 'package:naningana/pages/auth/loginOrRegister.dart';
import 'package:naningana/pages/loginPage.dart';
import 'package:naningana/pages/profilePage.dart';
import 'package:naningana/pages/registerPage.dart';
import 'package:naningana/pages/usersPage.dart';
import 'package:naningana/theme/darkMode.dart';
import 'package:naningana/theme/lightMode.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "naningana-mobile-project",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      home: AuthPage(),
      routes: {
        '/login_register': (context)=>LoginOrRegister(),
        '/intro_page': (context)=>IntroPage(),
        '/profile_page': (context)=>ProfilPage(),
        '/users_page': (context)=>UsersPage(),
      },
    );
  }
}

