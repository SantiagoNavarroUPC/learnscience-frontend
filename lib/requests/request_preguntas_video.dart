import 'dart:convert';
import 'package:flutter_application/models/PreguntaVideo.dart';
import 'package:http/http.dart' as http;

class PreguntaVideoRequest {
  final String baseUrl = "http://apirestdatos00.somee.com/api/PreguntaVideos";

  Future<bool> registrarPreguntaVideo(Map<String, dynamic> preguntaData) async {
    final preguntaJson = jsonEncode(preguntaData);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/RegistrarPreguntaVideo'),
        headers: {"Content-Type": "application/json"},
        body: preguntaJson,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['mensaje'] == 'Pregunta de video registrada con éxito') {
          return true;
        } else {
          throw Exception(data['mensaje']);
        }
      } else {
        throw Exception('Error al registrar la pregunta: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en el registro de la pregunta: $e');
    }
  }

  Future<List<PreguntaVideoModel>> obtenerPreguntasVideo() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/ListarPreguntasVideos'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> preguntasJson = data['response'];
        return preguntasJson.map((json) => PreguntaVideoModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener preguntas de video: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la obtención de preguntas de video: $e');
    }
  }

  Future<List<PreguntaVideoModel>> obtenerPreguntasVideoActivas() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/ListarPreguntasVideosActivas'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> preguntasJson = data['response'];
        return preguntasJson.map((json) => PreguntaVideoModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener preguntas de video activas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la obtención de preguntas de video activas: $e');
    }
  }

  Future<bool> actualizarPreguntaVideo(PreguntaVideoModel pregunta) async {
    final response = await http.put(
      Uri.parse('$baseUrl/ActualizarPreguntaVideo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pregunta.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['mensaje'] == 'Pregunta de video actualizada con éxito';
    } else {
      throw Exception('Error al actualizar la pregunta de video: ${response.statusCode}');
    }
  }
}
