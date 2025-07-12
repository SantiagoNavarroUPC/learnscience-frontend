import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/models/Calificaciones.dart';
import 'package:flutter_application/requests/request_calificaciones.dart';
import 'package:get/get.dart';

class CalificacionesController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var calificaciones = <CalificacionModel>[].obs;

  guardarCalificacion(CalificacionModel calificacion) async {
    isLoading.value = true;
    try {
      final registrado = await CalificacionesService().guardarCalificacion(calificacion);
      if (registrado) {
        Get.snackbar('Éxito', 'Calificación guardada correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: gColorTheme1_600,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Error', 'No se pudo guardar la calificación',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: gColorThemeError,
          colorText: Colors.white,
        );
      }
      return registrado;
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: gColorThemeError,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> ListarCalificacionesTotales() async {
  isLoading.value = true;
  try {
    final resultado = await CalificacionesService().listarTodasCalificaciones();

    calificaciones.value = resultado;
  } catch (e) {
    Get.snackbar('Error', 'Ocurrió un error al obtener las calificaciones: $e',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: gColorThemeError,
      colorText: Colors.white,
    );
    calificaciones.value = [];
  } finally {
    isLoading.value = false;
  }
}
  Future<void> ListarCalificacionesporIdCuestionario(int idCuestionario) async {
  isLoading.value = true;
  try {
    final resultado = await CalificacionesService().ListarCalificacionesporIdCuestionario(idCuestionario);

    calificaciones.value = resultado;
  } catch (e) {
    Get.snackbar('Error', 'Ocurrió un error al obtener las calificaciones: $e',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: gColorThemeError,
      colorText: Colors.white,
    );
    calificaciones.value = [];
  } finally {
    isLoading.value = false;
  }
}

}