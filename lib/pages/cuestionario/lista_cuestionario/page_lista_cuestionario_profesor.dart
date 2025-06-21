import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controller_asignatura.dart';
import 'package:flutter_application/controllers/controller_cuestionario.dart';
import 'package:flutter_application/models/Asignatura.dart';
import 'package:flutter_application/pages/calificaciones/page_calificacionesCuestionario.dart';
import 'package:flutter_application/pages/cuestionario/agregar_pregunta_cuestionario/page_agregar_pregunta.dart';
import 'package:flutter_application/pages/cuestionario/resolver_cuestionario/page_resolver_cuestionario.dart';
import 'package:flutter_application/size_config.dart';
import 'package:get/get.dart';

class ListaCuestionariosProfesor extends StatefulWidget {
  const ListaCuestionariosProfesor({Key? key}) : super(key: key);

  @override
  State<ListaCuestionariosProfesor> createState() => _ListaCuestionariosProfesorState();
}

class _ListaCuestionariosProfesorState extends State<ListaCuestionariosProfesor> {
  final CuestionarioController cuestionarioController = Get.put(CuestionarioController());
  final RxString areaSeleccionada = 'biologia'.obs;
  String? _tipo;
  List<AsignaturaModel> _asignaturas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarAsignaturas();
    cuestionarioController.obtenerCuestionariosPorArea(area: areaSeleccionada.value);
  }

  Future<void> _cargarAsignaturas() async {
    final controller = Get.put(AsignaturaController());
    final resultado = await controller.cargarAsignaturas();
    setState(() {
      _asignaturas = resultado;
      _loading = false;
    });
  }

    Color getColorForArea(String area) {
  if (area.isEmpty) return gColorTheme1_600;

  final asignatura = _asignaturas.firstWhere(
    (a) => removerTildes(a.nombre).toLowerCase() == area.toLowerCase(),
    orElse: () => AsignaturaModel(idAsignatura: 0, idUsuario: 0, nombre: '', color: 'Grey'),
  );
  final match = colores.firstWhere(
    (c) => (c['name'] as String).toLowerCase() == (asignatura.color ?? '').toLowerCase(),
    orElse: () => {'color': gColorTheme1_600},
  );
    return match['color'] as Color;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Cuestionarios',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, "/añadir_cuestionario");
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Background circles
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
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                        child: DropdownButton<String>(
                        value: _tipo ?? removerTildes('biología').toLowerCase(),
                        items: _asignaturas.map((asignatura) {
                          return DropdownMenuItem<String>(
                          value: removerTildes(asignatura.nombre).toLowerCase(),
                          child: Text(
                            asignatura.nombre,
                            style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                            ),
                          ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                          _tipo = value;
                          areaSeleccionada.value = value ?? removerTildes('biología').toLowerCase();
                          cuestionarioController.obtenerCuestionariosPorArea(area: areaSeleccionada.value);
                          });
                        },
                        ),
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (cuestionarioController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (cuestionarioController.hasError.value) {
                        return const Center(child: Text('No se pudieron obtener los cuestionarios'));
                      }

                      if (cuestionarioController.cuestionarios.isEmpty) {
                        return const Center(child: Text('No hay cuestionarios disponibles para esta área'));
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          await cuestionarioController.obtenerCuestionariosPorArea(area: areaSeleccionada.value);
                        },
                        child: ListView.builder(
                          itemCount: cuestionarioController.cuestionarios.length,
                          itemBuilder: (context, index) {
                            final cuestionario = cuestionarioController.cuestionarios[index];
                            final bool isEliminado = cuestionario.eliminado ?? false;

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: getColorForArea(areaSeleccionada.value),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(cuestionario.nombre ?? ''),
                              subtitle: Text(cuestionario.descripcion ?? ''),
                              trailing: Switch(
                                value: !isEliminado,
                                onChanged: (newValue) {
                                  setState(() {
                                    cuestionario.eliminado = !newValue;
                                  });
                                  cuestionarioController.actualizarCuestionario(cuestionario).then((success) {
                                    if (!success) {
                                      Get.snackbar(
                                        'Error',
                                        'No se pudo actualizar el estado del cuestionario',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                    } else {
                                      cuestionarioController.obtenerCuestionariosPorArea(area: areaSeleccionada.value);
                                    }
                                  });
                                },
                                activeTrackColor: Colors.green,
                                inactiveThumbColor: Colors.red,
                              ),
                              onTap: () {
                                if (isEliminado) {
                                  Get.snackbar(
                                    'Cuestionario Inactivo',
                                    'Este cuestionario no está activo.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.grey,
                                    colorText: Colors.white,
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Seleccione una opción'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: Icon(Icons.add_circle_outline, color: gBackgroundColor),
                                            title: const Text('Agregar nueva pregunta'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => PreguntaCuestionarioAdd(
                                                    idCuestionario: cuestionario.idCuestionario ?? 0,
                                                    idUsuario: cuestionario.idUsuario ?? 0,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            leading: Icon(Icons.visibility, color: gBackgroundColor),
                                            title: const Text('Vista previa'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ResolverCuestionarioPage(
                                                    idCuestionario: cuestionario.idCuestionario ?? 0,
                                                    tiempoEnSegundos: (cuestionario.tiempo).toInt(),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            leading: Icon(Icons.list_alt, color: gBackgroundColor),
                                            title: const Text('Lista de calificaciones'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ListaCalificacionesPage(
                                                    idCuestionario: cuestionario.idCuestionario ?? 0,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
