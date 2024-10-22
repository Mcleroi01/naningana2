import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:naningana/configure_nonweb.dart';
import 'package:naningana/gameNaningana/IntroPage.dart';
import 'package:naningana/pages/FicheDeSuivi.dart';
import 'package:naningana/pages/auth/AuthPage.dart';
import 'package:naningana/pages/auth/loginOrRegister.dart';
import 'package:naningana/pages/profilePage.dart';
import 'package:naningana/pages/usersPage.dart';
import 'package:naningana/theme/darkMode.dart';
import 'package:naningana/theme/lightMode.dart';

import 'firebase_options.dart';
import 'intro/homePage.dart';

void main() async {
  // Assurez-vous que les widgets sont initialisés avant d'utiliser Firebase
  WidgetsFlutterBinding.ensureInitialized();
  // Configurer l'application (si nécessaire)
  //configureApp();
  // Initialiser Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialiser GetStorage
  await GetStorage.init();
  // Préserver le splash screen pendant le démarrage
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  // Exécuter l'application
  runApp(MyApp());
  // Supprimer le splash screen après le démarrage de l'application
  FlutterNativeSplash.remove();
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      //darkTheme: darkMode,
      home: const AuthPage(),
      routes: {
        '/intro_page' : (context)=>const Naninganapage(),
        '/fiche_page' : (context)=> FicheDeSuivi(),
        '/login_register': (context)=>const LoginOrRegister(),
        '/home_page': (context)=>const HomePage(),
        '/profile_page': (context)=>const ProfilPage(),
        '/users_page': (context)=>const UsersPage(),
      },

    );
  }
}

