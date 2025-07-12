class RelacionModel {
  final String concepto;
  final String palabra;

  RelacionModel({required this.concepto, required this.palabra});

  factory RelacionModel.fromJson(Map<String, dynamic> json) {
    return RelacionModel(
      concepto: json['concepto'],
      palabra: json['palabra'],
    );
  }
}
