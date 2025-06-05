import 'dart:convert';
import 'package:flutter_application/models/Cuestionario.dart';
import 'package:http/http.dart' as http;


class CuestionarioService {
  final String baseUrl = 'http://apirestdatos00.somee.com/api/Cuestionario';

  Future<bool> guardarCuestionario(CuestionarioModel cuestionario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/GuardarCuestionario'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cuestionario.toJson()),
    );

    return response.statusCode == 200;
  }

  Future<List<CuestionarioModel>> listarTodosCuestionario() async {
    final response = await http.get(Uri.parse('$baseUrl/ListaCuestionarios'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List lista = data['response'];
      return lista.map((e) => CuestionarioModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener los cuestionarios');
    }
  }

  Future<List<CuestionarioModel>> listarActivosCuestionario() async {
    final response = await http.get(Uri.parse('$baseUrl/ListaCuestionariosActivos'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List lista = data['response'];
      return lista.map((e) => CuestionarioModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener cuestionarios activos');
    }
  }

  Future<bool> editarCuestionario(CuestionarioModel cuestionario) async {
    final response = await http.put(
      Uri.parse('$baseUrl/EditarCuestionario'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cuestionario.toJson()),
    );

    return response.statusCode == 200;
  }

  Future<bool> eliminarCuestionario(int id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/EliminarCuestionarioPorEstado/$id'),
    );

    return response.statusCode == 200;
  }
}
