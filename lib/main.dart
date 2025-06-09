import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application/controllers/controller_cuestionario.dart';
import 'package:flutter_application/controllers/controller_persona.dart';
import 'package:flutter_application/controllers/controller_pregunta_cuestionario.dart';
import 'package:flutter_application/controllers/controller_pregunta_video.dart';
import 'package:flutter_application/controllers/controller_unidad.dart';
import 'package:flutter_application/controllers/controller_usuario.dart';
import 'package:flutter_application/controllers/controller_video.dart';
import 'package:flutter_application/pages/cuestionario/agregar_cuestionario/page_agregar_cuestionario.dart';
import 'package:flutter_application/pages/cuestionario/agregar_pregunta_cuestionario/page_agregar_pregunta.dart';
import 'package:flutter_application/pages/cuestionario/lista_cuestionario/page_lista_cuestionario_estudiante.dart';
import 'package:flutter_application/pages/cuestionario/lista_cuestionario/page_lista_cuestionario_profesor.dart';
import 'package:flutter_application/pages/cuestionario/resolver_cuestionario/page_resolver_cuestionario.dart';
import 'package:flutter_application/pages/home_teacher/page_home_profesor.dart';
import 'package:flutter_application/pages/home_student/page_home_estudiante.dart';
import 'package:flutter_application/pages/juegos/ahorcado/ahorcado.dart';
import 'package:flutter_application/pages/juegos/lista_juegos/page_lista_juegos.dart';
import 'package:flutter_application/pages/login/page_login.dart';
import 'package:flutter_application/pages/login/page_registrarse.dart';
import 'package:flutter_application/pages/page_lista_persona.dart';
import 'package:flutter_application/pages/perfil_usuario/page_registro_persona.dart';
import 'package:flutter_application/pages/unidades/agregar_unidades/page_agregar_unidades.dart';
import 'package:flutter_application/pages/unidades/lista_unidades/page_lista_unidades_profesor.dart';
import 'package:flutter_application/pages/unidades/lista_unidades/page_lista_unidades_estudiante.dart';
import 'package:flutter_application/pages/videos_interactivos/agregar_videos/page_agregar_videos.dart';
import 'package:flutter_application/pages/videos_interactivos/lista_videos/components/page_lista_respuestas_video.dart';
import 'package:flutter_application/pages/videos_interactivos/lista_videos/components/page_visualizacion_video.dart';
import 'package:flutter_application/pages/videos_interactivos/lista_videos/page_lista_videos_estudiante.dart';
import 'package:flutter_application/pages/videos_interactivos/lista_videos/page_lista_videos_profesor.dart';
import 'package:flutter_application/theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'pages/onboarding/onboarding.dart';
import 'pages/inicio/page_start.dart';

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
  Get.put(UnidadController());
  Get.put(PersonaController());
  Get.put(UsuarioController());
  Get.put(VideoController());
  Get.put(PreguntaVideoController());
  Get.put(CuestionarioController());
  Get.put(PreguntaCuestionarioController());

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
        "/usuario": (context) => const RegistroPersonaScreen(),
        "/login": (context) => const LoginScreen(),
        "/registrarse": (context) => const RegistrarUsuarioScreen(),
        "/usuarios": (context) => ListaPersonasScreen(),
        "/onboarding": (context) => const Onboarding(),
        "/start": (context) => const StartApp(),
        "/menu_estudiante": (context) => const HomeStudent(),
        "/menu_profesor": (context) => const HomeTeacher(),
        "/unidades_profesor" : (context) => ListaUnidadesProfesor(),
        "/unidades_estudiante" : (context) => ListaUnidadesEstudiante(area: '',),
        "/añadir_unidad": (context) => const UnidadAdd(),
        "/ver_interactivos": (context) => const InteractiveVideoPage(videoUrl: '',idVideo: 0,),
        "/videos_interactivos_profesor": (context) => ListaVideosProfesor(),
        "/videos_interactivos_estudiante": (context) => ListaVideosEstudiante(area: '',),
        "/añadir_video": (context) =>const VideoAdd(),
        "/respuestas_videos":(context) => PreguntasVideoPage(videoId: 0),
        "/cuestionarios_interactivos_profesor": (context) => ListaCuestionariosProfesor(),
        "/cuestionarios_interactivos_estudiante": (context) => ListaCuestionariosEstudiante(area: ''),
        "/añadir_cuestionario": (context) =>const CuestionarioAdd(),
        "/añadir_pregunta_cuestionario": (context) => const PreguntaCuestionarioAdd(idCuestionario: 0, idUsuario: 0),
        "/resolver_cuestionario": (context) => const ResolverCuestionarioPage(idCuestionario: 0, tiempoEnSegundos: 0,),
        "/videojuegos": (context) => const ListaVideojuegosPage(materiaEstudiante: ''),
        "/juego_ahorcado": (context) => const AhorcadoApp(area: '',)
      },
    );
  }
}

