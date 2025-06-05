import 'package:flutter_application/models/usuario.dart';
import 'package:flutter_application/models/video.dart';

class PreguntaVideoModel {
  int? idPreguntasVideos;
  int? idVideo;
  int? idUsuario;
  String? respuesta1;
  String? respuesta2;
  String? respuesta3;
  double? calificacion;
  bool? eliminado;
  VideoModel? idVideosObject;
  UsuarioModel? idUsuarioObject;


  // Constructor actualizado
  PreguntaVideoModel({
    this.idPreguntasVideos,
    this.idVideo,
    this.idUsuario,
    this.respuesta1,
    this.respuesta2,
    this.respuesta3,
    this.calificacion,
    this.eliminado,
    this.idVideosObject,
    this.idUsuarioObject,
  });

  // Método fromJson actualizado
  factory PreguntaVideoModel.fromJson(Map<String, dynamic> json) {
    return PreguntaVideoModel(
      idPreguntasVideos: json['idPreguntasVideos'],
      idVideo: json['idVideo'],
      idUsuario: json['idUsuario'],
      respuesta1: json['respuesta1'],
      respuesta2: json['respuesta2'],
      respuesta3: json['respuesta3'],
      calificacion: (json['calificacion'] as num?)?.toDouble(),
      eliminado: json['eliminado'],
      idVideosObject: VideoModel.fromJson(json['idVideosObject']),
      idUsuarioObject: UsuarioModel.fromJson(json['idUsuarioObject']),
    );
  }

  // Método toJson actualizado
  Map<String, dynamic> toJson() {
    return {
      "idPreguntasVideos": idPreguntasVideos,
      "idVideo": idVideo,
      "idUsuario": idUsuario,
      "respuesta1": respuesta1,
      "respuesta2": respuesta2,
      "respuesta3": respuesta3,
      "calificacion": calificacion,
      "eliminado": eliminado,
    };
  }
}
