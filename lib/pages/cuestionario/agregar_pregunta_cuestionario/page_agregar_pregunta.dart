import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controller_pregunta_cuestionario.dart';
import 'package:get/get.dart';

class PreguntaCuestionarioAdd extends StatefulWidget {
  final int idCuestionario;
  final int idUsuario;

  const PreguntaCuestionarioAdd({
    Key? key,
    required this.idCuestionario,
    required this.idUsuario,
  }) : super(key: key);

  @override
  _PreguntaCuestionarioAddState createState() =>
      _PreguntaCuestionarioAddState();
}
class _PreguntaCuestionarioAddState extends State<PreguntaCuestionarioAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _preguntaController = TextEditingController();

  final List<TextEditingController> _opcionesControllers =
      List.generate(4, (_) => TextEditingController());

  final TextEditingController _respuestaCorrectaController = TextEditingController();

  final List<bool> _seleccionMultipleSeleccionada = [false, false, false, false];
  String? _falsoVerdaderoSeleccionado;
  String? _opcionAbcSeleccionada;

  final List<String> _tipos = [
    'preguntas abc',
    'seleccion multiple',
    'falso o verdadero',
    'abierta'
  ];
  String? _tipoSeleccionado;

  final controlador = Get.find<PreguntaCuestionarioController>();

  bool _isLoading = false;

  @override
  void dispose() {
    _preguntaController.dispose();
    _respuestaCorrectaController.dispose();
    for (var c in _opcionesControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTipoChanged(String? val) {
    setState(() {
      _tipoSeleccionado = val;
      _respuestaCorrectaController.clear();
      _falsoVerdaderoSeleccionado = null;
      _opcionAbcSeleccionada = null;
      for (int i = 0; i < 4; i++) {
        _opcionesControllers[i].clear();
        _seleccionMultipleSeleccionada[i] = false;
      }
    });
  }

  Future<void> _guardarPregunta() async {
    if (!_formKey.currentState!.validate()) return;

    String? opciones;
    String? correcta;

    if (_tipoSeleccionado == 'Preguntas abc') {
      opciones = _opcionesControllers.map((c) => c.text.trim()).join('\$');
      if (_opcionAbcSeleccionada == null) {
        Get.snackbar('Error', 'Debe seleccionar una opción correcta', backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      final index = int.parse(_opcionAbcSeleccionada!.split('_')[1]);
      correcta = _opcionesControllers[index].text.trim();
    } else if (_tipoSeleccionado == 'Seleccion multiple') {
      List<String> opts = _opcionesControllers.map((c) => c.text.trim()).toList();
      opciones = opts.join('\$');
      List<String> seleccionadas = [];
      for (int i = 0; i < 4; i++) {
        if (_seleccionMultipleSeleccionada[i]) {
          seleccionadas.add(opts[i]);
        }
      }
      if (seleccionadas.isEmpty) {
        Get.snackbar('Error', 'Debe seleccionar al menos una respuesta correcta', backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      correcta = seleccionadas.join('\$');
    } else if (_tipoSeleccionado == 'Falso o verdadero') {
      opciones = 'verdadero\$falso';
      correcta = _falsoVerdaderoSeleccionado;
      if (correcta == null) {
        Get.snackbar('Error', 'Debe seleccionar Verdadero o Falso', backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
    } else if (_tipoSeleccionado == 'Abierta') {
      correcta = _respuestaCorrectaController.text.trim();
      if (correcta.isEmpty) {
        Get.snackbar('Error', 'Debe ingresar la respuesta correcta', backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
    }

    final preguntaData = {
      'IdCuestionario': widget.idCuestionario,
      'IdUsuario': widget.idUsuario,
      'Pregunta': _preguntaController.text.trim(),
      'Tipo': _tipoSeleccionado,
      'Opciones': opciones,
      'Correcta': correcta,
      'Eliminado': false,
    };

    setState(() => _isLoading = true);
    final registrado = await controlador.registrarPreguntaCuestionario(preguntaData);
    setState(() => _isLoading = false);

    if (registrado) {
      Get.snackbar('Éxito', 'Pregunta registrada con éxito', backgroundColor: Colors.green, colorText: Colors.white);
      Navigator.pop(context, true);
    } else {
      Get.snackbar('Error', controlador.errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Pregunta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _preguntaController,
                          decoration: InputDecoration(
                            labelText: 'Escribe tu pregunta',
                            border: const OutlineInputBorder(),
                            labelStyle: TextStyle(color: gColorTheme1_700, fontWeight: FontWeight.bold),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? 'La pregunta es requerida' : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _tipoSeleccionado,
                          decoration: InputDecoration(
                            labelText: 'Tipo de pregunta',
                            border: const OutlineInputBorder(),
                            labelStyle: TextStyle(color: gColorTheme1_700, fontWeight: FontWeight.bold),
                          ),
                          items: _tipos.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                          onChanged: _onTipoChanged,
                          validator: (value) => value == null ? 'Debe seleccionar un tipo' : null,
                        ),
                        const SizedBox(height: 16),

                        if (_tipoSeleccionado == 'Preguntas abc') ...[
                          for (int i = 0; i < 4; i++)
                            RadioListTile<String>(
                              activeColor: gColorTheme1_700,
                              title: TextFormField(
                                controller: _opcionesControllers[i],
                                decoration: InputDecoration(
                                  labelText: 'Opción ${i + 1}',
                                  border: const OutlineInputBorder(),
                                  labelStyle: TextStyle(color: gColorTheme1_700),
                                ),
                                validator: (value) =>
                                    value == null || value.trim().isEmpty ? 'Debe ingresar la opción ${i + 1}' : null,
                              ),
                              value: 'opcion_$i',
                              groupValue: _opcionAbcSeleccionada,
                              onChanged: (_) {
                                setState(() {
                                  _opcionAbcSeleccionada = 'opcion_$i';
                                });
                              },
                            ),
                        ] else if (_tipoSeleccionado == 'Seleccion multiple') ...[
                          for (int i = 0; i < 4; i++)
                            CheckboxListTile(
                              activeColor: gColorTheme1_700,
                              title: TextFormField(
                                controller: _opcionesControllers[i],
                                decoration: InputDecoration(
                                  labelText: 'Opción ${i + 1}',
                                  border: const OutlineInputBorder(),
                                  labelStyle: TextStyle(color: gColorTheme1_700),
                                ),
                                validator: (value) =>
                                    value == null || value.trim().isEmpty ? 'Debe ingresar la opción ${i + 1}' : null,
                              ),
                              value: _seleccionMultipleSeleccionada[i],
                              onChanged: (v) {
                                setState(() {
                                  _seleccionMultipleSeleccionada[i] = v ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                        ] else if (_tipoSeleccionado == 'Falso o verdadero') ...[
                          const Text('Seleccione la respuesta correcta:', style: TextStyle(fontWeight: FontWeight.bold)),
                          RadioListTile<String>(
                            activeColor: gColorTheme1_700,
                            title: const Text('Verdadero'),
                            value: 'verdadero',
                            groupValue: _falsoVerdaderoSeleccionado,
                            onChanged: (val) => setState(() => _falsoVerdaderoSeleccionado = val),
                          ),
                          RadioListTile<String>(
                            activeColor: gColorTheme1_700,
                            title: const Text('Falso'),
                            value: 'falso',
                            groupValue: _falsoVerdaderoSeleccionado,
                            onChanged: (val) => setState(() => _falsoVerdaderoSeleccionado = val),
                          ),
                        ] else if (_tipoSeleccionado == 'Abierta') ...[
                          TextFormField(
                            controller: _respuestaCorrectaController,
                            decoration: InputDecoration(
                              labelText: 'Respuesta correcta',
                              border: const OutlineInputBorder(),
                              labelStyle: TextStyle(color: gColorTheme1_700),
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty ? 'Debe ingresar la respuesta correcta' : null,
                          ),
                        ],

                        const SizedBox(height: 20),

                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: gColorTheme1_700,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: _guardarPregunta,
                                  child: const Text('Guardar pregunta'),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
