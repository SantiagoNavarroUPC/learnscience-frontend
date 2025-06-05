import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controller_unidad.dart';
import 'package:flutter_application/controllers/controller_usuario.dart';
import 'package:flutter_application/pages/unidades/lista_unidades/components/vista_documento.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class ListaUnidadesProfesor extends StatelessWidget {
  final UnidadController unidadController = Get.put(UnidadController());

  ListaUnidadesProfesor({super.key}); 

  @override
  Widget build(BuildContext context) {
  UsuarioController usuarioController = Get.find<UsuarioController>();
  final rol = usuarioController.usuario.value?.tipo;
  String? areaSeleccionada = 'biologia'; // Área predeterminada para el filtro
  UnidadController unidadController = Get.find<UnidadController>();
  unidadController.obtenerUnidadesPorTipo(area: areaSeleccionada);

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
              if (unidadController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (unidadController.hasError.value) {
                return const Center(child: Text('No se pudieron obtener las unidades'));
              }

              if (unidadController.unidades.isEmpty) {
                return const Center(child: Text('No hay unidades disponibles para esta área'));
              }

              Color getColorForArea(String area) {
                switch (area.toLowerCase()) {
                  case 'biologia':
                    return gColorBanner1;
                  case 'quimica':
                    return gColorBanner2;
                  case 'fisica':
                    return gColorBanner3;
                  default:
                    return gColorTheme1_600; // Color por defecto si no coincide con ninguna área
                }
              }

              return Column(
                children: [
                  if (rol == 'profesor')
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: SizedBox( // Ajusta este valor para cambiar el ancho del Dropdown
                          child: DropdownButton<String>(
                            value: areaSeleccionada,
                            onChanged: (String? nuevaArea) {
                              if (nuevaArea != null) {
                                areaSeleccionada = nuevaArea;
                                unidadController.obtenerUnidadesPorTipo(area: areaSeleccionada);
                              }
                            },
                            items: <String>['biologia', 'quimica', 'fisica'].map((String area) {
                              return DropdownMenuItem<String>(
                                value: area,
                                child: Text(
                                  area.capitalize!,
                                  style: const TextStyle(fontSize: 18), // Aumenta el tamaño del texto
                                ),
                              );
                            }).toList(),
                            iconSize: 30, // Aumenta el tamaño del ícono del Dropdown
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
                              backgroundColor: isEliminado ? gColorThemeInactive : getColorForArea(areaSeleccionada!),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text('${unidad.nombre}'),
                            subtitle: Text('${unidad.descripcion}'),
                            trailing: (rol == 'profesor')
                                ? DropdownButton<bool>(
                                    icon: Icon(Icons.edit, color: isEliminado ? gColorThemeInactive : getColorForArea(areaSeleccionada!)),
                                    onChanged: (bool? newValue) {
                                      if (newValue != null) {
                                        unidad.eliminado = newValue;
                                        unidadController.actualizarUnidad(unidad).then((success) {
                                          if (!success) {
                                            Get.snackbar(
                                              'Error',
                                              'No se pudo actualizar la unidad',
                                              snackPosition: SnackPosition.BOTTOM,
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white,
                                            );
                                          } else {
                                            unidadController.obtenerUnidadesPorTipo(area: areaSeleccionada);
                                          }
                                        });
                                      }
                                    },
                                    items: const [
                                      DropdownMenuItem<bool>(
                                        value: false,
                                        child: Text('Activo', style: TextStyle(color: Colors.black)),
                                      ),
                                      DropdownMenuItem<bool>(
                                        value: true,
                                        child: Text('Inactivo', style: TextStyle(color: Colors.black)),
                                      ),
                                    ],
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
      throw Exception('Error al descargar el PDF: $e');
    }
  }
}
