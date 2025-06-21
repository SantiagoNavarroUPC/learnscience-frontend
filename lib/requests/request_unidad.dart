import 'package:flutter_application/models/unidad.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UnidadService {
  final String baseUrl = "http://apirestdatos00.somee.com/api/Unidad";
  final box = GetStorage();

  Future<bool> registrarUnidad(Map<String, dynamic> unidadData) async {
  final unidadJson = jsonEncode(unidadData);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/GuardarUnidad'), // Cambia la URL a la que corresponda
        headers: {"Content-Type": "application/json"},
        body: unidadJson,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['mensaje'] == 'Unidad registrada con éxito') {
          return true;
        } else {
          throw Exception(data['mensaje']);
        }
      } else {
        throw Exception('Error al registrar unidad: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en el registro: $e');
    }
  }
  
  Future<List<UnidadModel>> obtenerUnidades() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/ListaUnidades'), // Ajusta el endpoint según tu API
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> unidadesJson = data['response']; // Ajusta según la estructura de tu respuesta
        return unidadesJson.map((json) => UnidadModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener unidades: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la obtención de unidades: $e');
    }
  }
  Future<bool> actualizarEstadoUnidad(int id, bool estadoActual) async {
    final response = await http.put(
      Uri.parse('$baseUrl/ActualizarEstado/$id?estadoActual=$estadoActual'),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 200;
  }
}
