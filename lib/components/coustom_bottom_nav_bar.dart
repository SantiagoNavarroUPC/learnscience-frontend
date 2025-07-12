import 'package:flutter/material.dart';
import 'package:flutter_application/controllers/controller_asignatura.dart';
import 'package:flutter_application/pages/juegos/lista_juegos/page_lista_juegos.dart';
import 'package:flutter_application/size_config.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../controllers/controller_usuario.dart';
import '../enums.dart';


UsuarioController controlup = Get.find();
AsignaturaController asignaturaController = Get.find();

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.selectedMenu,
  });

  final MenuState selectedMenu;

  Future<void> _seleccionarAsignatura(BuildContext context) async {
    try {
      final asignaturas = await asignaturaController.cargarAsignaturas();

      if (asignaturas.isEmpty) {
        Get.snackbar(
          'Sin asignaturas',
          'No hay asignaturas disponibles',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: gColorThemeError,
          colorText: Colors.white,
        );
        return;
      }

      String? seleccionada = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Selecciona una asignatura'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: asignaturas.map((asignatura) {
                return ListTile(
                  title: Text(asignatura.nombre),
                  leading: const Icon(Icons.school),
                  onTap: () {
                    final valorAsignatura =
                        removerTildes(asignatura.nombre).toLowerCase();
                    Navigator.of(context).pop(valorAsignatura);
                  },
                );
              }).toList(),
            ),
          );
        },
      );

      if (seleccionada != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ListaVideojuegosPage(materiaEstudiante: seleccionada),
          ),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudieron cargar las asignaturas',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: gColorThemeError,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color inActiveIconColor = gColorTheme1_800;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        color: gColorTheme1_400,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Colors.transparent,
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.person,
                color: selectedMenu == MenuState.usuario
                    ? gColorTheme1_1
                    : inActiveIconColor,
              ),
              onPressed: () {
                Get.offNamed("/usuario");
              },
            ),
            IconButton(
              icon: Icon(
                Icons.home,
                color: selectedMenu == MenuState.home
                    ? gColorTheme1_1
                    : inActiveIconColor,
              ),
              onPressed: () {
                final usuario = controlup.usuario.value;
                if (usuario != null) {
                  if (usuario.tipo == 'profesor') {
                    Get.offNamed("/menu_profesor");
                  } else if (usuario.tipo == 'estudiante') {
                    Get.offNamed("/menu_estudiante");
                  } else {
                    Get.snackbar(
                      'Error',
                      'Tipo de usuario desconocido',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: gColorThemeError,
                      colorText: Colors.white,
                    );
                  }
                }
              },
            ),
            IconButton(
              icon: Icon(
                Icons.videogame_asset,
                color: selectedMenu == MenuState.game
                    ? gColorTheme1_1
                    : inActiveIconColor,
              ),
              onPressed: () {
                final usuario = controlup.usuario.value;
                if (usuario != null) {
                  if (usuario.tipo == 'profesor') {
                    Get.offNamed("/videojuegos");
                  } else if (usuario.tipo == 'estudiante') {
                    _seleccionarAsignatura(context);
                  } else {
                    Get.snackbar(
                      'Error',
                      'Tipo de usuario desconocido',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: gColorThemeError,
                      colorText: Colors.white,
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
