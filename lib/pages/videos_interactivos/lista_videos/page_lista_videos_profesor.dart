import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controller_asignatura.dart';
import 'package:flutter_application/controllers/controller_video.dart';
import 'package:flutter_application/models/Asignatura.dart';
import 'package:flutter_application/pages/videos_interactivos/lista_videos/components/page_visualizacion_video.dart';
import 'package:flutter_application/size_config.dart';
import 'package:get/get.dart';

class ListaVideosProfesor extends StatefulWidget {
  const ListaVideosProfesor({super.key});

  @override
  State<ListaVideosProfesor> createState() => _ListaVideosProfesorState();
}

class _ListaVideosProfesorState extends State<ListaVideosProfesor> {
  final VideoController videoController = Get.put(VideoController());
  final RxString areaSeleccionada = 'biologia'.obs;
  String? _tipo = 'biologia';
  List<AsignaturaModel> _asignaturas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarAsignaturas();
    videoController.obtenerVideosPorTipo(area: areaSeleccionada.value);
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
          'Lista de Videos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, "/añadir_video");
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned(
                bottom: -150,
                left: 230,
                child: Container(
                  width: 300,
                  height: 250,
                  decoration: BoxDecoration(
                    color: gColorTheme1_700.withAlpha((0.8 * 255).toInt()),
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
                    color: gColorTheme1_600.withAlpha((0.8 * 255).toInt()),
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
                      child: _loading
                          ? const CircularProgressIndicator()
                          : DropdownButton<String>(
                              value: _tipo,
                              
                              items: _asignaturas.map((asignatura) {
                                return DropdownMenuItem<String>(
                                  value: removerTildes(asignatura.nombre).toLowerCase(),
                                  child: Text(
                                    asignatura.nombre,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _tipo = value;
                                  areaSeleccionada.value = value ?? 'biologia';
                                  videoController.obtenerVideosPorTipo(area: areaSeleccionada.value);
                                });
                              },
                            ),
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (videoController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (videoController.hasError.value) {
                        return const Center(child: Text('No se pudieron obtener los videos'));
                      }

                      if (videoController.videos.isEmpty) {
                        return const Center(child: Text('No hay videos disponibles para esta área'));
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          await videoController.obtenerVideosPorTipo(area: areaSeleccionada.value);
                        },
                        child: ListView.builder(
                          itemCount: videoController.videos.length,
                          itemBuilder: (context, index) {
                            final video = videoController.videos[index];
                            final videoUrl = video.ruta!.split('?v=').last;
                            final idvideos = video.idVideo;
                            final bool isEliminado = video.eliminado ?? false;

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: getColorForArea(areaSeleccionada.value),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(video.nombre ?? ''),
                              subtitle: Text(video.descripcion ?? ''),
                              trailing: Switch(
                                value: isEliminado,
                                onChanged: (newValue) {
                                  setState(() {
                                    video.eliminado = newValue;
                                  });
                                  videoController.actualizarVideo(video).then((success) {
                                    if (success) {
                                      videoController.obtenerVideosPorTipo(area: areaSeleccionada.value);
                                    }
                                  });
                                },
                                activeTrackColor: Colors.red,
                                inactiveThumbColor: Colors.green,
                              ),
                              onTap: () {
                                if (isEliminado) {
                                  Get.snackbar(
                                    'Video Inactivo',
                                    'Este video no está activo.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.grey,
                                    colorText: Colors.white,
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InteractiveVideoPage(
                                        videoUrl: videoUrl,
                                        idVideo: idvideos,
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
