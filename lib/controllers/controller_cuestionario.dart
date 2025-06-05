import 'package:flutter_application/constants.dart';
import 'package:flutter_application/models/Cuestionario.dart';
import 'package:flutter_application/requests/request_cuestionario.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';


class CuestionarioController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  final CuestionarioService _cuestionarioService = CuestionarioService();

  var cuestionarios = <CuestionarioModel>[].obs;

  Future<bool> guardarCuestionario(CuestionarioModel cuestionario) async {
    isLoading.value = true;
    try {
      final registrado = await _cuestionarioService.guardarCuestionario(cuestionario);
      if (registrado) {
        Get.snackbar('Éxito', 'Cuestionario guardado correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: gColorTheme1_600,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Error', 'No se pudo guardar el cuestionario',
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

  
  Future<void> obtenerCuestionariosPorArea({String? area}) async {
    try {
      isLoading.value = true;
      hasError.value = false;

      var listaCuestionarios = await CuestionarioService().listarTodosCuestionario();
      if (area != null) {
        listaCuestionarios = listaCuestionarios.where((cuest) => cuest.tipo == area).toList();
      }

      cuestionarios.value = listaCuestionarios;

      if (cuestionarios.isEmpty) {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      Get.snackbar(
        'Error',
        'No se pudieron obtener los cuestionarios',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: gColorTheme1_900,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> obtenerCuestionariosPorAreaActivos({String? area}) async {
    try {
      isLoading.value = true;
      hasError.value = false;

      var listaCuestionarios = await CuestionarioService().listarActivosCuestionario();
      if (area != null) {
        listaCuestionarios = listaCuestionarios.where((cuestionario) => cuestionario.tipo == area).toList();
      }
      cuestionarios.value = listaCuestionarios;
    if (cuestionarios.isEmpty) {
      hasError.value = true;
    }
  } catch (e) {
    hasError.value = true;
    Get.snackbar(
      'Error',
      'No se pudieron obtener los cuestionarios',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: gColorTheme1_900,
      colorText: Colors.white,
    );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> actualizarCuestionario(CuestionarioModel cuestionario) async {
    isLoading.value = true;
    try {
      final actualizado = await _cuestionarioService.editarCuestionario(cuestionario);
      if (actualizado) {
        Get.snackbar('Éxito', 'Cuestionario actualizado correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: gColorTheme1_600,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Error', 'No se pudo actualizar el cuestionario',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: gColorThemeError,
          colorText: Colors.white,
        );
      }
      return actualizado;
    } catch (e) {
      Get.snackbar('Error', 'Error al actualizar: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: gColorThemeError,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> eliminarCuestionario(int id) async {
    isLoading.value = true;
    try {
      final eliminado = await _cuestionarioService.eliminarCuestionario(id);
      if (eliminado) {
        Get.snackbar('Éxito', 'Cuestionario eliminado correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: gColorTheme1_600,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar('Error', 'No se pudo eliminar el cuestionario',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: gColorThemeError,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Error al eliminar: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: gColorThemeError,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
