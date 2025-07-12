import 'package:flutter_application/models/PreguntaCuestionario.dart';
import 'package:flutter_application/requests/request_preguntas_cuestionario.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';


class PreguntaCuestionarioController extends GetxController {
  var preguntas = <PreguntaCuestionarioModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var hasError = false.obs;

  final PreguntaCuestionarioService _preguntaService = PreguntaCuestionarioService();

  Future<bool> registrarPreguntaCuestionario(Map<String, dynamic> preguntaData) async {
    isLoading.value = true;
    try {
      final registrado = await _preguntaService.registrarPreguntaCuestionario(preguntaData);
      if (registrado) {
        errorMessage.value = 'Pregunta registrada con éxito';
        return true;
      } else {
        errorMessage.value = 'Error al registrar pregunta';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> listaPreguntasCuestionario() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      var lista = await _preguntaService.listaPreguntasCuestionario();
      preguntas.value = lista;
      if (preguntas.isEmpty) {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      Get.snackbar(
        'Error',
        'No se pudieron obtener las preguntas',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> listarPreguntasCuestionariosActivas(int idCuestionario) async {
    isLoading.value = true;
    hasError.value = false;

    try {
      var lista = await _preguntaService.listarPreguntasCuestionariosActivas(idCuestionario);
      preguntas.value = lista;
      if (preguntas.isEmpty) {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      Get.snackbar(
        'Error',
        'No se pudieron obtener las preguntas activas',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> editarPreguntaCuestionario(Map<String, dynamic> preguntaData) async {
    isLoading.value = true;
    try {
      final actualizado = await _preguntaService.editarPreguntaCuestionario(preguntaData);
      if (actualizado) {
        Get.snackbar(
          'Éxito',
          'Pregunta actualizada correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'No se pudo actualizar la pregunta',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un error al actualizar la pregunta: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> eliminarPreguntaCuestionarioPorEstado(int idPregunta) async {
    isLoading.value = true;
    try {
      final eliminado = await _preguntaService.eliminarPreguntaCuestionarioPorEstado(idPregunta);
      if (eliminado) {
        Get.snackbar(
          'Éxito',
          'Pregunta eliminada correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'No se pudo eliminar la pregunta',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un error al eliminar la pregunta: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
