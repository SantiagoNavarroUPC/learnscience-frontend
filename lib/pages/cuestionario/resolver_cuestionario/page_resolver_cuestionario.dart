import 'package:flutter/material.dart';
import 'package:flutter_application/controllers/controller_calificaciones.dart';
import 'package:flutter_application/controllers/controller_usuario.dart';
import 'package:flutter_application/models/Calificaciones.dart';
import 'package:flutter_application/models/PreguntaCuestionario.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter_application/controllers/controller_pregunta_cuestionario.dart';

class ResolverCuestionarioPage extends StatefulWidget {
  final int idCuestionario;
  final int tiempoEnSegundos;

  const ResolverCuestionarioPage({
    super.key,
    required this.idCuestionario,
    required this.tiempoEnSegundos,
  });

  @override
  State<ResolverCuestionarioPage> createState() => _ResolverCuestionarioPageState();
}

class _ResolverCuestionarioPageState extends State<ResolverCuestionarioPage> {
  final controlador = Get.find<PreguntaCuestionarioController>();
  final UsuarioController usuarioController = Get.put(UsuarioController());
  final PageController _pageController = PageController();

  int _currentPage = 0;
  int _acertadas = 0;
  Map<int, dynamic> _respuestas = {};
  late Timer _timer;
  late int _tiempoRestante;
  bool _cuestionarioFinalizado = false;

  @override
  void initState() {
    super.initState();
    _tiempoRestante = widget.tiempoEnSegundos;
    controlador.listarPreguntasCuestionariosActivas(widget.idCuestionario).then((_) => setState(() {}));
    _iniciarTemporizador();
  }

  void _iniciarTemporizador() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_tiempoRestante > 0) {
        setState(() => _tiempoRestante--);
      } else {
        _finalizarCuestionario();
      }
    });
  }

  void _finalizarCuestionario() async {
  if (_cuestionarioFinalizado) return;
  _cuestionarioFinalizado = true;
  _timer.cancel();

  final total = controlador.preguntas.length;
  _acertadas = 0;

  for (var pregunta in controlador.preguntas) {
    final id = pregunta.idPreguntaCuestionario;
    final correcta = pregunta.correcta;
    final tipo = (pregunta.tipo ?? '').toString().toLowerCase();
    final respuestaUsuario = _respuestas[id];

    if (tipo == 'seleccion multiple') {
      final respList = List<String>.from(respuestaUsuario ?? []);
      final correctaList = (correcta ?? '').toString().split('\$').where((e) => e.trim().isNotEmpty).toList();

      if (Set.from(respList).containsAll(correctaList) &&
          Set.from(correctaList).containsAll(respList)) {
        _acertadas++;
      }
    } else if (respuestaUsuario == correcta) {
      _acertadas++;
    }
  }

  final nota = (_acertadas / total * 100).toStringAsFixed(2);
  final double notaFinal = double.parse(nota);

  final usuario = usuarioController.usuario.value!;
  final bool esProfesor = usuario.tipo == 'profesor';

  if (!esProfesor) {
    final calificacionModel = CalificacionModel(
      idCalificacion: 0,
      idUsuario: usuario.idUsuario ?? 0,
      idCuestionario: widget.idCuestionario,
      calificacion: notaFinal,
      eliminado: false
    );
     // Guardar calificación
     Get.put(CalificacionesController());

    final calificacionController = Get.find<CalificacionesController>();
     calificacionController.guardarCalificacion(calificacionModel);
  }

  // Mostrar resultado
  Get.dialog(
    AlertDialog(
      title: const Text('Resultado'),
      content: Text('Obtuviste $_acertadas de $total preguntas correctas.\nNota final: $nota'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            if (esProfesor) {
              Navigator.pushNamed(context, '/menu_profesor');
            } else {
              Navigator.pushNamed(context, '/menu_estudiante');
            }
          },
          child: const Text('Aceptar'),
        ),
      ],
    ),
  );
}


  Widget _buildPregunta(PreguntaCuestionarioModel pregunta) {
    final tipo = (pregunta.tipo ?? '').toString().toLowerCase();
    final opciones = (pregunta.opciones ?? '').toString().split('\$').where((e) => e.trim().isNotEmpty).toList();
    int? id = pregunta.idPreguntaCuestionario;

    return IgnorePointer(
      ignoring: _cuestionarioFinalizado || _tiempoRestante == 0,
      child: Builder(
        builder: (_) {
          if (tipo == 'preguntas abc') {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: opciones.map((op) => RadioListTile<String>(
                    title: Text(op),
                    activeColor: Colors.teal,
                    value: op,
                    groupValue: _respuestas[id],
                    onChanged: (val) => setState(() => _respuestas[id ?? 0] = val),
                  )).toList(),
            );
          } else if (tipo == 'seleccion multiple') {
            return Column(
              children: opciones.map((op) => CheckboxListTile(
                    title: Text(op),
                    value: (_respuestas[id] ?? []).contains(op),
                    activeColor: Colors.teal,
                    onChanged: (val) {
                      setState(() {
                        final list = List<String>.from(_respuestas[id ?? 0] ?? []);
                        val! ? list.add(op) : list.remove(op);
                        _respuestas[id ?? 0] = list;
                      });
                    },
                  )).toList(),
            );
          } else if (tipo == 'falso o verdadero') {
            return Column(
              children: ['verdadero', 'falso'].map((op) => RadioListTile<String>(
                    title: Text(op),
                    value: op,
                    activeColor: Colors.teal,
                    groupValue: _respuestas[id],
                    onChanged: (val) => setState(() => _respuestas[id ?? 0] = val),
                  )).toList(),
            );
          } else if (tipo == 'abierta') {
            return TextFormField(
              decoration: const InputDecoration(
                hintText: 'Escribe tu respuesta',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => _respuestas[id ?? 0] = val.trim(),
            );
          } else {
            return const Text('Tipo de pregunta no soportado');
          }
        },
      ),
    );
  }

  List<Widget> _buildDots() => List.generate(
        controlador.preguntas.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 12 : 8,
          height: _currentPage == index ? 12 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.teal : Colors.teal.shade100,
            shape: BoxShape.circle,
          ),
        ),
      );

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final preguntas = controlador.preguntas;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resolver Cuestionario',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: controlador.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : preguntas.isEmpty
              ? const Center(child: Text('No hay preguntas disponibles'))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Pregunta ${_currentPage + 1}/${preguntas.length}',
                              style: const TextStyle(fontSize: 16)),
                          Text(
                            'Tiempo: ${_tiempoRestante ~/ 60}:${(_tiempoRestante % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: preguntas.length,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (i) => setState(() => _currentPage = i),
                        itemBuilder: (_, i) {
                          final pregunta = preguntas[i];
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (pregunta.pregunta ?? '').toString(),
                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 16),
                                      _buildPregunta(pregunta),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildDots(),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: _cuestionarioFinalizado ? null : _finalizarCuestionario,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Finalizar Cuestionario'),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
    );
  }
}
