import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/controllers/controller_asignatura.dart';
import 'package:flutter_application/controllers/controller_usuario.dart';
import 'package:flutter_application/models/Asignatura.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker, ImageSource;
import 'package:path/path.dart' as p;

import '../../../constants.dart';

class AgregarAsignaturasPage extends StatefulWidget {
  const AgregarAsignaturasPage({super.key});

  @override
  _AgregarAsignaturasPageState createState() => _AgregarAsignaturasPageState();
}

class _AgregarAsignaturasPageState extends State<AgregarAsignaturasPage> {
  bool _loading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  String? _selectedColor;
  final List<Map<String, dynamic>> _colores = colores;


  File? _imagen;

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    final File imageFile = File(pickedFile.path);
    final String extension = p.extension(pickedFile.path); // .jpg, .png, etc.
    final String nombre = _nombreController.text.trim();
    final String storagePath = 'asignaturas/$nombre$extension';

    try {
      setState(() => _loading = true);
      final storageRef = FirebaseStorage.instance.ref().child(storagePath);
      final uploadTask = await storageRef.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      setState(() {
        _imagen = imageFile;

      });
    } catch (e) {
      Get.snackbar('Error', 'Error al subir imagen: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() => _loading = false);
    }
  }
}

  void _guardarAsignatura() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _loading = true);

  final nombre = _nombreController.text.trim();
  final descripcion = _descripcionController.text.trim();
  final color = _selectedColor;
  final usuarioController = Get.find<UsuarioController>();
  final int idUsuario = usuarioController.usuario.value?.idUsuario ?? 0;

  String? urlImagen;

  try {
    // 1. Subir imagen si se seleccionó
    if (_imagen != null) {
      final extension = p.extension(_imagen!.path); // .jpg, .png, etc.
      final storagePath = 'asignaturas/$nombre$extension';

      final ref = FirebaseStorage.instance.ref().child(storagePath);
      final uploadTask = await ref.putFile(_imagen!);
      urlImagen = await uploadTask.ref.getDownloadURL();
    }

    // 2. Construir el modelo
    final asignatura = AsignaturaModel(
      idAsignatura: 0, // el servidor lo autogenera
      idUsuario: idUsuario,
      nombre: nombre,
      descripcion: descripcion,
      color: color,
      imagen: urlImagen,
      eliminado: false,
    );

    // 3. Guardar asignatura
    final controller = Get.find<AsignaturaController>();
    final ok = await controller.guardarAsignatura(asignatura);

    if (ok) {
      Get.back(); // regresar
      Get.snackbar('Éxito', 'Asignatura guardada correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } else {
      Get.snackbar('Error', 'No se pudo guardar la asignatura',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  } catch (e) {
    Get.snackbar('Error', 'Ocurrió un error: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white);
  } finally {
    setState(() => _loading = false);
  }
}


  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        'Agregar Asignatura',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    extendBodyBehindAppBar: true,
    body: LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Fondo decorativo
            Positioned(
              bottom: -150,
              left: 230,
              child: Container(
                width: 300,
                height: 250,
                decoration: BoxDecoration(
                  color: (gColorTheme1_700).withOpacity(0.8),
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
                  color: (gColorTheme1_600).withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Formulario encima del fondo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                        controller: _nombreController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Ingrese un nombre' : null,
                    ),
                    TextFormField(
                      controller: _descripcionController,
                      decoration: const InputDecoration(labelText: 'Descripción'),
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedColor,
                      decoration: const InputDecoration(labelText: 'Color'),
                      items: _colores
                          .map((c) => DropdownMenuItem<String>(
                                value: c['name'],
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      color: c['color'],
                                      margin: EdgeInsets.only(right: 8),
                                    ),
                                    Text(c['name']),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedColor = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Seleccione un color' : null,
                    ),
                    const SizedBox(height: 16),
                    _imagen == null
                        ? TextButton.icon(
                            icon: Icon(Icons.image),
                            label: Text('Seleccionar Imagen'),
                            onPressed: _pickImage,
                          )
                        : Image.file(_imagen!, height: 150),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _guardarAsignatura,
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              ),
            ),
            if (_loading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        },
      ),
    );
  }
}