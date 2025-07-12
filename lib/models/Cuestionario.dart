class CuestionarioModel {
  int? idCuestionario;
  int? idUsuario;
  String nombre;
  String descripcion;
  String tipo;
  double tiempo;
  bool? eliminado;

  CuestionarioModel({
    this.idCuestionario,
    this.idUsuario,
    required this.nombre,
    required this.descripcion,
    required this.tipo,
    required this.tiempo,
    this.eliminado,
  });

  factory CuestionarioModel.fromJson(Map<String, dynamic> json) {
    return CuestionarioModel(
      idCuestionario: json['idCuestionario'],
      idUsuario: json['idUsuario'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      tipo: json['tipo'],
      tiempo: json['tiempo'],
      eliminado: json['eliminado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idCuestionario": idCuestionario,
      "idUsuario": idUsuario,
      "nombre": nombre,
      "descripcion": descripcion,
      "tipo": tipo,
      "tiempo": tiempo,
      "eliminado": eliminado,
    };
  }
}
