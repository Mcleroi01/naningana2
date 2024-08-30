import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:naningana/intro/IntroPage.dart';
import 'package:naningana/pages/FicheDeSuivi.dart';
import 'package:naningana/pages/auth/AuthPage.dart';
import 'package:naningana/pages/auth/loginOrRegister.dart';
import 'package:naningana/pages/profilePage.dart';
import 'package:naningana/pages/usersPage.dart';
import 'package:naningana/theme/darkMode.dart';
import 'package:naningana/theme/lightMode.dart';

import 'firebase_options.dart';
import 'intro/homePage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "naningana-mobile-project",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
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
      home: const AuthPage(),
      routes: {
        '/intro_page' : (context)=>const IntroPage(),
        '/fiche_page' : (context)=> FicheDeSuivi(),
        '/login_register': (context)=>const LoginOrRegister(),
        '/home_page': (context)=>const HomePage(),
        '/profile_page': (context)=>const ProfilPage(),
        '/users_page': (context)=>const UsersPage(),
      },

    );
  }
}

