import 'package:flutter_application/models/Asignatura.dart';
import 'package:flutter_application/requests/request_asignatura.dart';
import 'package:get/get.dart';


class AsignaturaController extends GetxController {
  final AsignaturaService _service = AsignaturaService();

  var asignaturas = <AsignaturaModel>[].obs;
  var isLoading = false.obs;

  Future<List<AsignaturaModel>> cargarAsignaturas() async {
  try {
    final asignaturas = await AsignaturaService().listarTodasAsignaturas();
    this.asignaturas.value = asignaturas; // si usas .obs
    return asignaturas;
  } catch (e) {
    Get.snackbar('Error', 'No se pudo cargar asignaturas');
    return []; // importante: retornar una lista vacía si falla
  }
}


  Future<bool> guardarAsignatura(AsignaturaModel asignatura) async {
    isLoading.value = true;
    try {
      final result = await _service.guardarAsignatura(asignatura);
      if (result) {
        await cargarAsignaturas();
      }
      return result;
    } finally {
      isLoading.value = false;
    }
  }
}