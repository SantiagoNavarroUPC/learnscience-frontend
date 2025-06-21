import 'dart:convert';

import 'package:flutter_application/models/Asignatura.dart';
import 'package:http/http.dart' as http;

class AsignaturaService {
  final String baseUrl = 'http://apirestdatos00.somee.com/api/Asignatura';

  Future<bool> guardarAsignatura(AsignaturaModel asignatura) async {
    final response = await http.post(
      Uri.parse('$baseUrl/GuardarAsignatura'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(asignatura.toJson()),
    );

    return response.statusCode == 200;
  }

  Future<List<AsignaturaModel>> listarTodasAsignaturas() async {
    final response = await http.get(Uri.parse('$baseUrl/ListaAsignaturas'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List lista = data['response'];
      return lista.map((e) => AsignaturaModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener las asignaturas');
    }
  }
}
