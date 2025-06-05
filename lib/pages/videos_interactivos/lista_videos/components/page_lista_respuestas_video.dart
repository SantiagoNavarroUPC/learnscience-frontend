import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controller_pregunta_video.dart';
import 'package:get/get.dart';


class PreguntasVideoPage extends StatelessWidget {
  final PreguntaVideoController preguntaVideoController = Get.put(PreguntaVideoController());

  PreguntasVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    preguntaVideoController.obtenerPreguntasVideo();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Respuestas de las preguntas de los videos',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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

              // Main Content
              Obx(() {
                if (preguntaVideoController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (preguntaVideoController.preguntas.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay preguntas disponibles.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: preguntaVideoController.preguntas.length,
                  itemBuilder: (context, index) {
                    final pregunta = preguntaVideoController.preguntas[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: gColorTheme1_1.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Video Title
                            Text(
                              'Video: ${pregunta.idVideosObject?.nombre ?? "Sin nombre"}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: gColorTheme1_700,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // User Email
                            Text(
                              'Correo del Usuario: ${pregunta.idUsuarioObject?.correo ?? "Sin correo"}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: gTextColor,
                              ),
                            ),
                            const Divider(thickness: 1, color: gColorTheme1_600),

                            // Justified Answers
                            const SizedBox(height: 8),
                            _buildJustifiedText('Respuesta 1', pregunta.respuesta1),
                            const SizedBox(height: 8),
                            _buildJustifiedText('Respuesta 2', pregunta.respuesta2),
                            const SizedBox(height: 8),
                            _buildJustifiedText('Respuesta 3', pregunta.respuesta3),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }

  // Helper method to build justified text sections with titles
  Widget _buildJustifiedText(String title, String? content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: gColorTheme1_700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content ?? 'Sin respuesta',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}



