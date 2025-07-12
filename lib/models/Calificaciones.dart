import 'dart:ffi';

import 'package:flutter_application/models/Cuestionario.dart';
import 'package:flutter_application/models/Usuario.dart';

class CalificacionModel {
  int? idCalificacion;
  int idUsuario;
  int idCuestionario;
  double calificacion;
  bool? eliminado;
  CuestionarioModel? idCuestionarioObject;
  UsuarioModel? idUsuarioObject;
  
  CalificacionModel({
    this.idCalificacion,
    required this.idUsuario,
    required this.idCuestionario,
    required this.calificacion,
    this.eliminado,
    this.idCuestionarioObject,
    this.idUsuarioObject,
  });

  factory CalificacionModel.fromJson(Map<String, dynamic> json) {
    return CalificacionModel(
      idCalificacion: json['idCalificacion'],
      idUsuario: json['idUsuario'],
      idCuestionario: json['idCuestionario'],
      calificacion: (json['calificacion'] as num?)!.toDouble(),
      eliminado: json['eliminado'],
      idCuestionarioObject: json['idCuestionarioNavigation'] != null
          ? CuestionarioModel.fromJson(json['idCuestionarioNavigation'])
          : null,
      idUsuarioObject: json['idUsuarioNavigation'] != null
          ? UsuarioModel.fromJson(json['idUsuarioNavigation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCalificacion': idCalificacion,
      'idUsuario': idUsuario,
      'idCuestionario': idCuestionario,
      'calificacion': calificacion,
      'eliminado': eliminado,
    };
  }
}