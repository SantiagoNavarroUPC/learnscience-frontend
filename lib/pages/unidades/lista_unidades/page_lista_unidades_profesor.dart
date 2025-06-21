import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controller_asignatura.dart';
import 'package:flutter_application/controllers/controller_unidad.dart';
import 'package:flutter_application/controllers/controller_usuario.dart';
import 'package:flutter_application/models/Asignatura.dart';
import 'package:flutter_application/pages/unidades/lista_unidades/components/vista_documento.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application/size_config.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class ListaUnidadesProfesor extends StatefulWidget {
  const ListaUnidadesProfesor({Key? key}) : super(key: key);

  @override
  State<ListaUnidadesProfesor> createState() => _ListaUnidadesProfesorState();
}

class _ListaUnidadesProfesorState extends State<ListaUnidadesProfesor> {
  final UnidadController unidadController = Get.put(UnidadController());
  final UsuarioController usuarioController = Get.find<UsuarioController>();
  String? areaSeleccionada = 'biologia';
  List<AsignaturaModel> _asignaturas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarAsignaturas();
    unidadController.obtenerUnidadesPorTipo(area: areaSeleccionada);
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
    final rol = usuarioController.usuario.value?.tipo;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Índice de Unidades',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          if (rol == 'profesor')
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, "/añadir_unidad");
              },
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Circles in the background
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
              Obx(() {
                if (unidadController.isLoading.value || _loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (unidadController.hasError.value) {
                  return const Center(child: Text('No se pudieron obtener las unidades'));
                }

                if (unidadController.unidades.isEmpty) {
                  return const Center(child: Text('No hay unidades disponibles para esta área'));
                }

                return Column(
                  children: [
                    if (rol == 'profesor')
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: SizedBox(
                            child: DropdownButton<String>(
                              value: areaSeleccionada,
                              items: _asignaturas.map((asignatura) {
                                return DropdownMenuItem<String>(
                                  value: removerTildes(asignatura.nombre).toLowerCase(),
                                  child: Text(
                                    asignatura.nombre ?? '',
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
                                  areaSeleccionada = value ?? 'biologia';
                                  unidadController.obtenerUnidadesPorTipo(area: areaSeleccionada);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await unidadController.obtenerUnidadesPorTipo(area: areaSeleccionada);
                        },
                        child: ListView.builder(
                          itemCount: unidadController.unidades.length,
                          itemBuilder: (context, index) {
                            final unidad = unidadController.unidades[index];
                            final bool isEliminado = unidad.eliminado ?? false;

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isEliminado
                                    ? gColorThemeInactive
                                    : getColorForArea(areaSeleccionada!),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text('${unidad.nombre}'),
                              subtitle: Text('${unidad.descripcion}'),
                              trailing: (rol == 'profesor')
                                  ? Switch(
                                      value: isEliminado,
                                      onChanged: (newValue) {
                                        setState(() {
                                          unidad.eliminado = newValue;
                                        });
                                        unidadController.actualizarUnidad(unidad).then((success) {
                                          if (!success) {
                                            Get.snackbar(
                                              'Error',
                                              'No se pudo actualizar el estado de la unidad',
                                              snackPosition: SnackPosition.BOTTOM,
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white,
                                            );
                                          } else {
                                            unidadController.obtenerUnidadesPorTipo(area: areaSeleccionada);
                                          }
                                        });
                                      },
                                      activeTrackColor: Colors.red,
                                      inactiveThumbColor: Colors.green,
                                    )
                                  : null,
                              onTap: () {
                                if (isEliminado) {
                                  Get.snackbar(
                                    'Unidad Inactiva',
                                    'Esta unidad no está activa.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: gColorThemeInactive,
                                    colorText: Colors.white,
                                  );
                                } else {
                                  _downloadPdf(unidad.ruta!, context);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          );
        },
      ),
    );
  }

  void _downloadPdf(String pdfUrl, BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final savePath = '${directory.path}/my_pdf.pdf';

      Dio dio = Dio();
      await dio.download(pdfUrl, savePath);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewPage(filePath: savePath),
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al descargar el PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
