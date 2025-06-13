import 'package:flutter/material.dart';
import 'package:flutter_application/models/video.dart';
import 'package:flutter_application/requests/request_video.dart';
import 'package:get/get.dart';
import '../constants.dart';

class VideoController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var hasError = false.obs; 
  var video = Rx<VideoModel?>(null);

  final VideoRequest _videoService = VideoRequest();

  Future<bool> registrarVideo(Map<String, dynamic> videoData) async {
    isLoading.value = true;
    try {
      final registrado = await _videoService.registrarVideo(videoData);
      if (registrado) {
        errorMessage.value = 'Video registrado con éxito';
        return true;
      } else {
        errorMessage.value = 'Error al registrar video';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  var videos = <VideoModel>[].obs;
  Future<void> obtenerVideos() async {
    try {
      isLoading.value = true;
      var listaVideos = await VideoRequest().obtenerVideos();
      videos.value = listaVideos;
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudieron obtener los videos',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: gColorTheme1_900,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> obtenerVideosPorTipo({String? area}) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      var listaVideos = await VideoRequest().obtenerVideos();
      if (area != null) {
        listaVideos = listaVideos.where((video) => video.tipo == area).toList();
      }
      videos.value = listaVideos;
      if (videos.isEmpty) {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      Get.snackbar(
        'Error',
        'No se pudieron obtener los videos',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: gColorTheme1_900,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> obtenerVideosPorTipoActivos({String? area}) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      var listaVideos = await VideoRequest().obtenerVideosActivos();
      if (area != null) {
        listaVideos = listaVideos.where((video) => video.tipo == area).toList();
      }
      videos.value = listaVideos;
      if (videos.isEmpty) {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      Get.snackbar(
        'Error',
        'No se pudieron obtener los videos',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: gColorTheme1_900,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> actualizarVideo(VideoModel video) async {
  try {
    isLoading.value = true;
    
    // Se invierte el estado actual (lógica para alternar)
    final nuevoEstado = !(video.eliminado ?? false);

    final success = await VideoRequest().actualizarEstadoVideo(video.idVideo ?? 0, nuevoEstado);

    if (success) {
      // Actualizamos el modelo local si es necesario
      video.eliminado = nuevoEstado;

      Get.snackbar(
        'Éxito',
        'Estado del video actualizado correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: gColorTheme1_600,
        colorText: Colors.white,
      );
    }

    return success;
  } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un error al intentar actualizar el video: $e',
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
