import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controller_calificaciones.dart';
import 'package:get/get.dart';

class ListaCalificacionesPage extends StatefulWidget {
  final int idCuestionario;
  const ListaCalificacionesPage({super.key, required this.idCuestionario});

  @override
  State<ListaCalificacionesPage> createState() => _ListaCalificacionesPageState();
}

class _ListaCalificacionesPageState extends State<ListaCalificacionesPage> {
  final CalificacionesController calificacionesController = Get.put(CalificacionesController());

  @override
  void initState() {
    super.initState();
    calificacionesController.ListarCalificacionesporIdCuestionario(widget.idCuestionario);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Respuesta de Cuestionarios', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Círculos decorativos
              Positioned(
                bottom: -150,
                left: 230,
                child: Container(
                  width: 300,
                  height: 250,
                  decoration: BoxDecoration(
                    color: gColorTheme1_700.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -150,
                right: 230,
                child: Container(
                  width: 300,
                  height: 250,
                  decoration: BoxDecoration(
                    color: gColorTheme1_600.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Lista
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(() {
                  if (calificacionesController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (calificacionesController.calificaciones.isEmpty) {
                    return const Center(child: Text("No hay calificaciones"));
                  }

                  return ListView.builder(
                    itemCount: calificacionesController.calificaciones.length,
                    itemBuilder: (context, index) {
                      final cal = calificacionesController.calificaciones[index];
                      final correo = cal.idUsuarioObject?.correo ?? 'Correo no disponible';
                      final nombreCuestionario = cal.idCuestionarioObject?.nombre ?? 'Sin nombre';

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.grade, color: gColorTheme1_600),
                          title: Text('Calificacion: ${cal.calificacion.toInt().toString()}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Correo: ${correo}'),
                              Text('Cuestionario: $nombreCuestionario'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
