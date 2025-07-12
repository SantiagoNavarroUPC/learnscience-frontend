
import 'package:flutter_application/models/video.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoService {
  final String baseUrl = "http://apirestdatos00.somee.com/api/Videos";
  final box = GetStorage();

  Future<bool> registrarVideo(Map<String, dynamic> videoData) async {
  final videoJson = jsonEncode(videoData);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/RegistrarVideo'),
        headers: {"Content-Type": "application/json"},
        body: videoJson,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['mensaje'] == 'Video registrado con éxito') {
          return true;
        } else {
          throw Exception(data['mensaje']);
        }
      } else {
        throw Exception('Error al registrar video: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en el registro: $e');
    }
  }
  Future<List<VideoModel>> obtenerVideos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/ListarVideos'), // Ajusta el endpoint según tu API
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> videosJson = data['response']; // Ajusta según la estructura de tu respuesta
        return videosJson.map((json) => VideoModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener videos interactivos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la obtención de videos interactivos: $e');
    }
  }
  Future<List<VideoModel>> obtenerVideosActivos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/ListarVideosActivos'), // Ajusta el endpoint según tu API
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> videosJson = data['response']; // Ajusta según la estructura de tu respuesta
        return videosJson.map((json) => VideoModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener videos interactivos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la obtención de videos interactivos: $e');
    }
  }
  Future<bool> actualizarEstadoVideo(int id, bool estadoActual) async {
    final response = await http.put(
      Uri.parse('$baseUrl/ActualizarEstado/$id?estadoActual=$estadoActual'),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 200;
  }

 
}
