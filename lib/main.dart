import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/controllers/controllerPersona.dart';
import 'package:flutter_application/controllers/controllerUsuario.dart';
import 'package:flutter_application/pages/home_teacher/home.dart';
import 'package:flutter_application/pages/home_student/home.dart';
import 'package:flutter_application/pages/login/login.dart';
import 'package:flutter_application/pages/login/registrarse.dart';
import 'package:flutter_application/pages/pageListarPersona.dart';
import 'package:flutter_application/pages/pageRegistroPersona.dart';
import 'package:flutter_application/theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'pages/onboarding/onboarding.dart';
import 'pages/inicio/start.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  GetPlatform.isWeb
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyAjpGT0EeVeR-2Yi7d5zADIl4AhVWDLFV0",
              authDomain: "learnscience-1ef2d.firebaseapp.com",
              projectId: "learnscience-1ef2d",
              storageBucket: "learnscience-1ef2d.appspot.com",
              messagingSenderId: "286644546160",
              appId: "1:286644546160:android:d52703d1656bc67f6c62b5"))
      : await Firebase.initializeApp();

  await GetStorage.init();
  Get.put(PersonaController());
  Get.put(UsuarioController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material Didáctico',
      theme: appTheme,
      initialRoute: '/start',
      routes: {
        "/usuario": (context) => RegistroPersonaScreen(),
        "/login": (context) => LoginScreen(),
        "/registrarse": (context) => RegistrarUsuarioScreen(),
        "/usuarios": (context) => ListaPersonasScreen(),
        "/onboarding": (context) => Onboarding(),
        "/start": (context) => StartApp(),
        "/menu_estudiante": (context) => const HomeStudent(),
        "/menu_profesor": (context) => const HomeTeacher(),
      },
    );
  }
}

