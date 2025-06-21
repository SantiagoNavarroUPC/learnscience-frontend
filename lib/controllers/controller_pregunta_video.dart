import 'package:flutter_application/models/PreguntaVideo.dart';
import 'package:flutter_application/requests/request_preguntas_video.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PreguntaVideoController extends GetxController {
  var preguntas = <PreguntaVideoModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var hasError = false.obs;
  final PreguntaVideoService _preguntaService = PreguntaVideoService();

  Future<bool> registrarPreguntaVideo(Map<String, dynamic> preguntaData) async {
    isLoading.value = true;
    try {
      final registrado = await _preguntaService.registrarPreguntaVideo(preguntaData);
      if (registrado) {
        errorMessage.value = 'Pregunta de video registrada con éxito';
        return true;
      } else {
        errorMessage.value = 'Error al registrar pregunta de video';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
    
  }

  Future<void> obtenerPreguntasVideo(int videoId) async {
  try {
    isLoading.value = true;
    var listaPreguntas = await _preguntaService.obtenerPreguntasVideo(videoId);
    preguntas.value = listaPreguntas;
  } catch (e) {
    Get.snackbar(
      'Error',
      'No se pudieron obtener las preguntas de video',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
}

  Future<void> obtenerPreguntasVideoActivas() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      var listaPreguntas = await _preguntaService.obtenerPreguntasVideoActivas();
      preguntas.value = listaPreguntas;
      if (preguntas.isEmpty) {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      Get.snackbar(
        'Error',
        'No se pudieron obtener las preguntas de video activas',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> actualizarPreguntaVideo(PreguntaVideoModel pregunta) async {
    try {
      isLoading.value = true;
      bool success = await _preguntaService.actualizarPreguntaVideo(pregunta);
      if (success) {
        Get.snackbar(
          'Éxito',
          'Pregunta de video actualizada correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'No se pudo actualizar la pregunta de video',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      return success;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un error al intentar actualizar la pregunta de video: $e',
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
