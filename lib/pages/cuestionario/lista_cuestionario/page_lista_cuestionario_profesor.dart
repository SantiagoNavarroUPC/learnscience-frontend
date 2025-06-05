import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controller_cuestionario.dart';
import 'package:get/get.dart';


class ListaCuestionariosProfesor extends StatelessWidget {
  final CuestionarioController cuestionarioController = Get.put(CuestionarioController());
  final RxString areaSeleccionada = 'biologia'.obs;

  ListaCuestionariosProfesor({super.key});

  @override
  Widget build(BuildContext context) {
    cuestionarioController.obtenerCuestionariosPorArea(area: areaSeleccionada.value);

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
                      child: Obx(() => DropdownButton<String>(
                            value: areaSeleccionada.value,
                            onChanged: (String? nuevaArea) {
                              if (nuevaArea != null) {
                                areaSeleccionada.value = nuevaArea;
                                cuestionarioController.obtenerCuestionariosPorArea(area: areaSeleccionada.value);
                              }
                            },
                            items: <String>['biologia', 'quimica', 'fisica'].map((String area) {
                              return DropdownMenuItem<String>(
                                value: area,
                                child: Text(
                                  area.capitalize!,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              );
                            }).toList(),
                            iconSize: 30,
                          )),
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

                      Color getColorForArea(String area) {
                        switch (area.toLowerCase()) {
                          case 'biologia':
                            return gColorBanner1;
                          case 'quimica':
                            return gColorBanner2;
                          case 'fisica':
                            return gColorBanner3;
                          default:
                            return gColorTheme1_600;
                        }
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
                                value: isEliminado,
                                onChanged: (newValue) {
                                  cuestionario.eliminado = newValue;
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
                                activeTrackColor: Colors.red,
                                inactiveThumbColor: Colors.green,
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
                                  Navigator.pushNamed(
                                    context,
                                    "/resolver_cuestionario",
                                    arguments: cuestionario,
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
