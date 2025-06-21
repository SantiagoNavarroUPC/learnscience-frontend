import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/models/Asignatura.dart';
import 'package:flutter_application/pages/cuestionario/lista_cuestionario/page_lista_cuestionario_estudiante.dart';
import 'package:flutter_application/pages/juegos/lista_juegos/page_lista_juegos.dart';
import 'package:flutter_application/pages/unidades/lista_unidades/page_lista_unidades_estudiante.dart';
import 'package:flutter_application/pages/videos_interactivos/lista_videos/page_lista_videos_estudiante.dart';
import 'package:flutter_application/size_config.dart';

class BannerAsignatura extends StatelessWidget {
  final AsignaturaModel asignatura;
  


  const BannerAsignatura({super.key, required this.asignatura});
  

  @override
  
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.library_books),
                    title: const Text('Índice de unidades'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListaUnidadesEstudiante(area: removerTildes(asignatura.nombre).toLowerCase()),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.play_circle_filled),
                    title: const Text('Videos interactivos'),
                    onTap: () => Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => ListaVideosEstudiante(area: removerTildes(asignatura.nombre).toLowerCase()),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Exámenes'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListaCuestionariosEstudiante(area: removerTildes(asignatura.nombre).toLowerCase()),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.gamepad),
                    title: const Text('Juegos interactivos'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListaVideojuegosPage(materiaEstudiante: removerTildes(asignatura.nombre).toLowerCase()),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: _parseColor(asignatura.color),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                asignatura.imagen ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenido al Área de ${asignatura.nombre}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    asignatura.descripcion ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _parseColor(String? nombreColor) {
  final colorEncontrado = colores.firstWhere(
    (elemento) => elemento['name'].toString().toLowerCase() == nombreColor?.toLowerCase(),
    orElse: () => {'color': Colors.grey},
  );
  return colorEncontrado['color'] as Color;
}

  
}
