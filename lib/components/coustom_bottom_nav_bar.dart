import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../controllers/controller_usuario.dart';
import '../enums.dart';


UsuarioController controlup = Get.find();

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.selectedMenu,
  });

  final selectedMenu;
  

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
                Navigator.pushReplacementNamed(context, "/usuario");
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
                final UsuarioController usuarioController = Get.put(UsuarioController());
                final usuario = usuarioController.usuario.value!;
                if (usuario.tipo == 'profesor') {
                  Navigator.pushReplacementNamed(context, "/menu_profesor");
                } else if (usuario.tipo == 'estudiante') {
                  Navigator.pushReplacementNamed(context, "/menu_estudiante");
                } else {
                  Get.snackbar(
                    'Error',
                    'Tipo de usuario desconocido',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: gColorThemeError,
                    colorText: Colors.white,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
