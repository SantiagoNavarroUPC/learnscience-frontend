import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controller_cuestionario.dart';
import 'package:flutter_application/controllers/controller_usuario.dart';
import 'package:flutter_application/pages/cuestionario/resolver_cuestionario/page_resolver_cuestionario.dart';
import 'package:get/get.dart';

class ListaCuestionariosEstudiante extends StatelessWidget {
  final CuestionarioController cuestionarioController = Get.put(CuestionarioController());
  final String area;

  ListaCuestionariosEstudiante({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    UsuarioController usuarioController = Get.find<UsuarioController>();
    cuestionarioController.obtenerCuestionariosPorAreaActivos(area: area);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Índice de Cuestionarios',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Background Circles
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
                if (cuestionarioController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (cuestionarioController.hasError.value) {
                  return const Center(child: Text('No se pudieron obtener los cuestionarios'));
                }

                if (cuestionarioController.cuestionarios.isEmpty) {
                  return const Center(child: Text('No hay cuestionarios disponibles para esta área'));
                }

                Color getColorForArea() {
                  switch (area.toLowerCase()) {
                    case 'biologia':
                      return gColorBanner1;
                    case 'quimica':
                      return gColorBanner2;
                    case 'fisica':
                      return gColorBanner3;
                    default:
                      return Colors.grey;
                  }
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await cuestionarioController.obtenerCuestionariosPorAreaActivos(area: area);
                  },
                  child: ListView.builder(
                    itemCount: cuestionarioController.cuestionarios.length,
                    itemBuilder: (context, index) {
                      final cuestionario = cuestionarioController.cuestionarios[index];
                      final bool isEliminado = cuestionario.eliminado ?? false;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isEliminado ? gColorThemeInactive : getColorForArea(),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text('${cuestionario.nombre}'),
                        subtitle: Text('${cuestionario.descripcion}'),
                        trailing: (usuarioController.usuario.value?.tipo == 'profesor')
                            ? DropdownButton<bool>(
                                icon: Icon(Icons.edit, color: isEliminado ? gColorThemeInactive : getColorForArea()),
                                onChanged: (bool? newValue) {
                                  if (newValue != null) {
                                    cuestionario.eliminado = newValue;
                                    cuestionarioController.actualizarCuestionario(cuestionario).then((success) {
                                      if (!success) {
                                        Get.snackbar(
                                          'Error',
                                          'No se pudo actualizar el cuestionario',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                      } else {
                                        cuestionarioController.obtenerCuestionariosPorAreaActivos(area: area);
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
                              'Cuestionario Inactivo',
                              'Este cuestionario no está activo.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: gColorThemeInactive,
                              colorText: Colors.white,
                            );
                          } else {
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
                          }
                        },
                      );
                    },
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
