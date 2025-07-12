import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application/controllers/controller_asignatura.dart';
import 'dart:io';
import 'package:flutter_application/controllers/controller_unidad.dart';
import 'package:flutter_application/models/Asignatura.dart';
import 'package:flutter_application/size_config.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../controllers/controller_usuario.dart';

class UnidadAdd extends StatefulWidget {

  const UnidadAdd({super.key});

  @override
  _UnidadAddState createState() => _UnidadAddState();
}

class _UnidadAddState extends State<UnidadAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _pdfFile;
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

  UnidadController controllerUnidad = Get.find<UnidadController>();
  UsuarioController usuarioController = Get.find<UsuarioController>();

  void _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'], // Solo permite archivos PDF
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        if (!file.path.endsWith('.pdf')) {
          throw Exception('El archivo seleccionado no es un PDF');
        }

        setState(() {
          _pdfFile = file;
        });
      } else {
        throw Exception('No se seleccionó ningún archivo');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  Future<String> _uploadFile(File file) async {
  try {
    if (file.path.endsWith('.pdf')) {
      final storageRef = FirebaseStorage.instance.ref().child('unidad_files');
      final uploadTask = storageRef.child('${DateTime.now()}.pdf').putFile(file);
      final snapshot = await uploadTask;
      final fileUrl = await snapshot.ref.getDownloadURL();
      return fileUrl;
    } else {
      throw Exception('El archivo seleccionado no es un PDF');
    }
  } catch (e) {
    throw Exception('Error al cargar el archivo: ${e.toString()}');
  }
}


  void _resetForm() {
    setState(() {
      _nameController.clear();
      _descriptionController.clear();
      _tipo = null;
      _pdfFile = null;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        'Agregar Unidad de estudio',
        style: TextStyle(
          fontSize: 20, 
          fontWeight: FontWeight.bold,
        ),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      cursorColor: Colors.teal,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de la Unidad',
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
                          return 'Por favor, ingresa el nombre de la unidad';
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
                    GestureDetector(
                      onTap: _pickFile,
                      child: Container(
                        height: 200.0,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: _pdfFile != null
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.picture_as_pdf, size: 50.0),
                                  Text(
                                    'Archivo PDF Seleccionado',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              )
                            : const Icon(Icons.archive, size: 50.0),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_pdfFile != null) {
                            final name = _nameController.text;
                            final description = _descriptionController.text;
                            final pdfUrl = await _uploadFile(_pdfFile!);
                            final tipo = _tipo.toString();
                            final idUsuario = usuarioController.usuario.value?.idUsuario;
                            
                            final unidadData = {
                              'idUnidad' : 0,
                              'idUsuario': idUsuario,
                              'nombre': name,
                              'descripcion': description,
                              'tipo': tipo,
                              'ruta': pdfUrl,
                              'eliminado' : false
                            };
                            controllerUnidad.registrarUnidad(unidadData);
                            Get.snackbar(
                              'Proceso exitoso',
                              'La unidad se registro correctamente',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: gColorTheme1_900,
                              colorText: Colors.white,
                            );
                            _resetForm();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Por favor, selecciona un archivo PDF'),
                                backgroundColor: Color.fromARGB(255, 152, 29, 29),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: gColorTheme1_1,                      
                        backgroundColor: gColorTheme1_700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Agregar Unidad'),
                      ),
                    ],
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