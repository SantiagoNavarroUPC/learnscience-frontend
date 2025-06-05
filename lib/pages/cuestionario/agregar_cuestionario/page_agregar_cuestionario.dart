import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controller_cuestionario.dart';
import 'package:flutter_application/controllers/controller_usuario.dart';
import 'package:flutter_application/models/Cuestionario.dart';
import 'package:get/get.dart';

class CuestionarioAdd extends StatefulWidget {
  const CuestionarioAdd({super.key});

  @override
  State<CuestionarioAdd> createState() => _CuestionarioAddState();
}

class _CuestionarioAddState extends State<CuestionarioAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _tiempoController = TextEditingController();
  String? _tipo;

  final CuestionarioController cuestionarioController = Get.find<CuestionarioController>();
  final UsuarioController usuarioController = Get.find<UsuarioController>();

  void _resetForm() {
    _nombreController.clear();
    _descripcionController.clear();
    _tiempoController.clear();
    _tipo = null;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _tiempoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Cuestionario', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
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
              Container(
                height: constraints.maxHeight,
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
                              controller: _nombreController,
                              decoration: const InputDecoration(labelText: 'Nombre del Cuestionario'),
                              validator: (value) => value!.isEmpty ? 'Ingrese un nombre' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _descripcionController,
                              decoration: const InputDecoration(labelText: 'Descripción'),
                              validator: (value) => value!.isEmpty ? 'Ingrese una descripción' : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _tipo,
                              decoration: const InputDecoration(labelText: 'Tipo de Cuestionario'),
                              items: const [
                                DropdownMenuItem(value: 'biologia', child: Text('Biología')),
                                DropdownMenuItem(value: 'quimica', child: Text('Química')),
                                DropdownMenuItem(value: 'fisica', child: Text('Física')),
                              ],
                              onChanged: (value) => setState(() => _tipo = value),
                              validator: (value) => value == null ? 'Seleccione un tipo' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _tiempoController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Tiempo en minutos'),
                              validator: (value) => value!.isEmpty ? 'Ingrese un tiempo' : null,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final idUsuario = usuarioController.usuario.value?.idUsuario;
                                  final cuestionario = CuestionarioModel(
                                    idCuestionario: 0,
                                    nombre: _nombreController.text,
                                    descripcion: _descripcionController.text,
                                    tipo: _tipo!,
                                    tiempo: (int.tryParse(_tiempoController.text) ?? 0).toDouble(),
                                    eliminado: false,
                                    idUsuario: idUsuario ?? 0,
                                  );

                                  bool registrado = await cuestionarioController.guardarCuestionario(cuestionario);
                                  if (registrado) {
                                    Get.snackbar('Éxito', 'Cuestionario registrado correctamente',
                                        backgroundColor: gColorTheme1_800, colorText: Colors.white);
                                    _resetForm();
                                  } else {
                                    Get.snackbar('Error', cuestionarioController.errorMessage.value,
                                        backgroundColor: gColorThemeError, colorText: Colors.white);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: gColorTheme1_700,
                                foregroundColor: Colors.white, // ← Esto hace que las letras sean blancas
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),

                              child: const Text('Agregar Cuestionario'),
                            )
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
