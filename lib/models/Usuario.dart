import 'package:flutter_application/models/Persona.dart';

class UsuarioModel {
  int? idUsuario;
  String correo;
  String contrasena;
  String? tipo;
  bool? eliminado;
  List<PersonaModel>? personas;

  UsuarioModel({
    this.idUsuario,
    required this.correo,
    required this.contrasena,
    this.tipo,
    this.eliminado,
    this.personas = const [],
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    var listaPersonas = <PersonaModel>[];

    if (json['personas'] != null) {
      listaPersonas = List<PersonaModel>.from(
        json['personas'].map((p) => PersonaModel.fromJson(p)),
      );
    }

    return UsuarioModel(
      idUsuario: json['idUsuario'],
      correo: json['correo'] ?? '',
      contrasena: json['contraseña'] ?? '',
      tipo: json['tipo'] ?? '',
      eliminado: json['eliminado'],
      personas: listaPersonas,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'correo': correo,
      'contraseña': contrasena,
      'tipo': tipo,
    };
  }
}
