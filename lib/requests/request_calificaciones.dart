import 'dart:convert';

import 'package:flutter_application/models/Calificaciones.dart';
import 'package:http/http.dart' as http;

class CalificacionesService {
  final String baseUrl = 'http://apirestdatos00.somee.com/api/Calificaciones';

  Future<bool> guardarCalificacion(CalificacionModel calificacion) async {
    final response = await http.post(
      Uri.parse('$baseUrl/AgregarCalificacion'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(calificacion.toJson()),
    );

    return response.statusCode == 200;
  }

  Future<List<CalificacionModel>> listarTodasCalificaciones() async {
    final response = await http.get(Uri.parse('$baseUrl/ListarCalificaciones'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List lista = data['response'];
      return lista.map((e) => CalificacionModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener las calificaciones');
    }
  }

 Future<List<CalificacionModel>> ListarCalificacionesporIdCuestionario(int idCuestionario) async {
  final response = await http.get(Uri.parse('$baseUrl/ListarPorCuestionario/$idCuestionario'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => CalificacionModel.fromJson(json)).toList();
  } else {
    throw Exception('Error al cargar calificaciones');
  }
}


}