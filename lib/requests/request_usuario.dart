import 'dart:convert';
import 'package:flutter_application/models/Usuario.dart';
import 'package:http/http.dart' as http;


class UsuarioService {
  final String baseUrl = "http://apirestdatos00.somee.com/api/Usuario";

  
  Future<UsuarioModel?> loginUsuario(UsuarioModel usuario) async {
    final usuarioJson = jsonEncode(usuario.toJson());
    final response = await http.post(
      Uri.parse('$baseUrl/Login'),
      headers: {"Content-Type": "application/json"},
      body: usuarioJson,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['mensaje'] == 'ok') {
        return UsuarioModel.fromJson(data['response']);
      } else {
        throw Exception(data['mensaje']);
      }
    } else {
      throw Exception('Error al hacer login');
    }
  }

  Future<bool> registrarUsuario(UsuarioModel usuario) async {
  final usuarioJson = jsonEncode(usuario.toJson());
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/RegistrarUsuario'),
      headers: {"Content-Type": "application/json"},
      body: usuarioJson,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['mensaje'] == 'Usuario registrado con éxito') {
        return true;
      } else {
        throw Exception(data['mensaje']);
      }
    } else {
      throw Exception('Error al registrar usuario: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error en el registro: $e');
  }
}


  Future<bool> eliminarUsuario(int idUsuario) async {
    final url = Uri.parse('$baseUrl/EliminarPorEstadoUsuario');
    final response = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'idUsuario': idUsuario,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['mensaje'] == 'ok';
    } else {
      throw Exception('Error al eliminar usuario');
    }
  }

  Future<List<UsuarioModel>> getUsuarios() async {
    final url = Uri.parse("$baseUrl/listaUsuarios");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<UsuarioModel> lista = [];

      for (var item in data["response"]) {
        lista.add(UsuarioModel.fromJson(item));
      }

      return lista;
    } else {
      throw Exception("Error al cargar usuarios");
    }
  }
}
