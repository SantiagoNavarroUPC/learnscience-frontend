class PreguntaCuestionarioModel {
  int? idPreguntaCuestionario;
  int idUsuario;
  int idCuestionario;
  String pregunta;
  String tipo;
  String? opciones;
  String? correcta;
  bool eliminado;

  PreguntaCuestionarioModel({
    this.idPreguntaCuestionario,
    required this.idUsuario,
    required this.idCuestionario,
    required this.pregunta,
    required this.tipo,
    this.opciones,
    this.correcta,
    required this.eliminado,
  });

  factory PreguntaCuestionarioModel.fromJson(Map<String, dynamic> json) {
    return PreguntaCuestionarioModel(
      idPreguntaCuestionario: json['idPreguntaCuestionario'],
      idUsuario: json['idUsuario'],
      idCuestionario: json['idCuestionario'],
      pregunta: json['pregunta'] ?? '',
      tipo: json['tipo'] ?? '',
      opciones: json['opciones'],
      correcta: json['correcta'],
      eliminado: json['eliminado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idPreguntaCuestionario": idPreguntaCuestionario,
      "idUsuario": idUsuario,
      "idCuestionario": idCuestionario,
      "pregunta": pregunta,
      "tipo": tipo,
      "opciones": opciones,
      "correcta": correcta,
      "eliminado": eliminado,
    };
  }
}
