class AsignaturaModel {
  final int idAsignatura;
  final int idUsuario;
  final String nombre;
  final String? descripcion;
  final String? color;
  final String? imagen;
  final bool? eliminado;

  AsignaturaModel({
    required this.idAsignatura,
    required this.idUsuario,
    required this.nombre,
    this.descripcion,
    this.color,
    this.imagen,
    this.eliminado,
  });

  factory AsignaturaModel.fromJson(Map<String, dynamic> json) {
    return AsignaturaModel(
      idAsignatura: json['idAsignatura'] as int,
      idUsuario: json['idUsuario'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      color: json['color'] as String?,
      imagen: json['imagen'] as String?,
      eliminado: json['eliminado'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idAsignatura': idAsignatura,
      'idUsuario': idUsuario,
      'nombre': nombre,
      'descripcion': descripcion,
      'color': color,
      'imagen': imagen,
      'eliminado': eliminado,
    };
  }
}