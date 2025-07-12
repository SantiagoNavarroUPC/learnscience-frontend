import 'dart:convert';
import 'package:flutter_application/models/PreguntaCuestionario.dart';
import 'package:http/http.dart' as http;


class PreguntaCuestionarioService {
  final String baseUrl = "http://apirestdatos00.somee.com/api/PreguntaCuestionario";

  // POST: RegistrarPreguntaCuestionario
  Future<bool> registrarPreguntaCuestionario(Map<String, dynamic> preguntaData) async {
    final body = jsonEncode(preguntaData);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/RegistrarPreguntaCuestionario'),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['mensaje'] == "Pregunta registrada con éxito";
      } else {
        throw Exception('Error al registrar la pregunta: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en el registro de la pregunta: $e');
    }
  }

  // GET: ListaPreguntasCuestionario
  Future<List<PreguntaCuestionarioModel>> listaPreguntasCuestionario() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/ListaPreguntasCuestionario'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> listaJson = data['response'];
        return listaJson.map((json) => PreguntaCuestionarioModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener preguntas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la obtención de preguntas: $e');
    }
  }

  // GET: ListarPreguntasCuestionariosActivas/{idCuestionario}
  Future<List<PreguntaCuestionarioModel>> listarPreguntasCuestionariosActivas(int idCuestionario) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/ListarPreguntasCuestionariosActivas/$idCuestionario'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> listaJson = data['response'];
        return listaJson.map((json) => PreguntaCuestionarioModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener preguntas activas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la obtención de preguntas activas: $e');
    }
  }

  // PUT: EditarPreguntaCuestionario
  Future<bool> editarPreguntaCuestionario(Map<String, dynamic> preguntaData) async {
    final body = jsonEncode(preguntaData);

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/EditarPreguntaCuestionario'),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['mensaje'] == "Pregunta actualizada correctamente";
      } else {
        throw Exception('Error al actualizar pregunta: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la actualización de la pregunta: $e');
    }
  }

  // PUT: EliminarPreguntaCuestionarioPorEstado/{id}
  Future<bool> eliminarPreguntaCuestionarioPorEstado(int idPregunta) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/EliminarPreguntaCuestionarioPorEstado/$idPregunta'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['mensaje'] == "Pregunta eliminada (lógicamente) con éxito";
      } else {
        throw Exception('Error al eliminar pregunta: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la eliminación de la pregunta: $e');
    }
  }
}
