import 'package:flutter/material.dart';
import 'package:flutter_application/controllers/controller_asignatura.dart';
import 'package:flutter_application/models/Asignatura.dart';
import 'package:flutter_application/pages/home_student/components/banner.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class Body extends StatelessWidget {
  const Body({super.key});

  Future<List<AsignaturaModel>> _cargarAsignaturas() async {
    final controller = Get.put(AsignaturaController());
    return await controller.cargarAsignaturas();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<AsignaturaModel>>(
        future: _cargarAsignaturas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final asignaturas = snapshot.data ?? [];

          return ListView.builder(
            itemCount: asignaturas.length,
            itemBuilder: (context, index) {
              final asignatura = asignaturas[index];
              return _buildSection(
                title: 'Curso de ${asignatura.nombre}',
                icon: Icons.category,
                banner: BannerAsignatura(asignatura: asignatura),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget banner,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
              Icon(icon, color: Colors.black, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          banner,
        ],
      ),
    );
  }
}



