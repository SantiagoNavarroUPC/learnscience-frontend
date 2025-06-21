import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controller_asignatura.dart';
import 'package:flutter_application/controllers/controller_usuario.dart';
import 'package:flutter_application/controllers/controller_video.dart';
import 'package:flutter_application/models/Asignatura.dart';
import 'package:flutter_application/size_config.dart';
import 'package:get/get.dart';

class VideoAdd extends StatefulWidget {
  const VideoAdd({super.key});

  @override
  _VideoAddState createState() => _VideoAddState();
}

class _VideoAddState extends State<VideoAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  String? _tipo; 
  List<AsignaturaModel> _asignaturas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarAsignaturas();
  }

  Future<void> _cargarAsignaturas() async {
    final controller = Get.put(AsignaturaController());
    final resultado = await controller.cargarAsignaturas();
    setState(() {
      _asignaturas = resultado;
      _loading = false;
    });
  }

  VideoController controllerVideo = Get.find<VideoController>();
  UsuarioController usuarioController = Get.find<UsuarioController>();

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _descriptionController.clear();
      _urlController.clear();
      _tipo = null;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        'Agregar Video de estudio',
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
            // Fullscreen Form
            Container(
              height: constraints.maxHeight,  // Set height to take full screen
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            cursorColor: Colors.teal,
                            decoration: const InputDecoration(
                              labelText: 'Nombre del Video',
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: gColorTheme1_900),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, ingresa el nombre del video';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _descriptionController,
                            cursorColor: Colors.teal,
                            decoration: const InputDecoration(
                              labelText: 'Descripción',
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: gColorTheme1_900),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, ingresa la descripción';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          _loading
                          ? const CircularProgressIndicator()
                          : DropdownButtonFormField<String>(
                              value: _tipo,
                              decoration: const InputDecoration(
                                labelText: 'Asignatura',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: gColorTheme1_900),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              items: _asignaturas.map((asignatura) {
                                return DropdownMenuItem<String>(
                                  value: removerTildes(asignatura.nombre).toLowerCase(),
                                  child: Text(
                                    asignatura.nombre ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, selecciona una asignatura';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _tipo = value;
                                });
                              },
                            ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _urlController,
                            cursorColor: Colors.teal,
                            decoration: const InputDecoration(
                              labelText: 'URL del Video (YouTube)',
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: gColorTheme1_900),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, pega la URL del video';
                              } else if (!value.contains('youtube.com') && !value.contains('youtu.be')) {
                                return 'La URL debe ser de YouTube';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final name = _nameController.text;
                                final description = _descriptionController.text;
                                final videoUrl = _urlController.text;
                                final tipo = _tipo.toString();
                                final idUsuario = usuarioController.usuario.value?.idUsuario;

                                final videoData = {
                                  'idVideo': 0,
                                  'idUsuario': idUsuario,
                                  'nombre': name,
                                  'descripcion': description,
                                  'tipo': tipo,
                                  'ruta': videoUrl,
                                  'eliminado': false
                                };
                                controllerVideo.registrarVideo(videoData);
                                Get.snackbar(
                                  'Proceso exitoso',
                                  'El video se registró correctamente',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: gColorTheme1_900,
                                  colorText: Colors.white,
                                );
                                _resetForm();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: gColorTheme1_1,
                              backgroundColor: gColorTheme1_700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: const Text('Agregar Video'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}