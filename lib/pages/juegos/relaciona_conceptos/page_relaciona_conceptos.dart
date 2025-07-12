import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_application/components/coustom_bottom_nav_bar.dart';
import 'package:flutter_application/enums.dart';

class JuegoRelacionarPage extends StatefulWidget {
  final String asignatura;

  const JuegoRelacionarPage({super.key, required this.asignatura});

  @override
  State<JuegoRelacionarPage> createState() => _JuegoRelacionarPageState();
}

class _JuegoRelacionarPageState extends State<JuegoRelacionarPage> {
  List<MapEntry<String, String>> pares = [];
  List<String> palabrasDesordenadas = [];

  Map<String, String> seleccionados = {}; // concepto -> palabra
  Map<String, Color> coloresEmparejados = {};
  String? itemSeleccionado; // puede ser concepto o palabra

  int nivel = 1;
  int aciertos = 0;
  late Timer timer;
  double progreso = 0.0;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    cargarNivel();
    iniciarTemporizador();
  }

  Future<void> cargarNivel() async {
    final jsonString = await rootBundle.loadString('assets/relaciona_concepto.json');
    final jsonData = json.decode(jsonString);
    final List datos = jsonData[widget.asignatura];
    datos.shuffle();

    final paresNivel = datos
        .take(nivel + 1)
        .map((e) => MapEntry<String, String>(e['concepto'], e['palabra']))
        .toList();

    setState(() {
      pares = List.from(paresNivel)..shuffle();
      palabrasDesordenadas = pares.map((e) => e.value).toList()..shuffle();
      seleccionados.clear();
      coloresEmparejados.clear();
      itemSeleccionado = null;
      aciertos = 0;
    });
  }

  void iniciarTemporizador() {
    progreso = 0;
    timer = Timer.periodic(const Duration(milliseconds: 140), (t) {
      setState(() => progreso += 0.01);
      if (progreso >= 1.0) {
        perderJuego();
      }
    });
  }

  void reiniciarTemporizador() {
    timer.cancel();
    iniciarTemporizador();
  }

  void verificarEmparejamiento(String nuevoItem) {
    if (itemSeleccionado == null) {
      setState(() => itemSeleccionado = nuevoItem);
      return;
    }

    final item1 = itemSeleccionado!;
    final esConcepto1 = pares.any((e) => e.key == item1);
    final esConcepto2 = pares.any((e) => e.key == nuevoItem);

    if (esConcepto1 == esConcepto2) {
      setState(() => itemSeleccionado = nuevoItem);
      return;
    }

    final concepto = esConcepto1 ? item1 : nuevoItem;
    final palabra = esConcepto1 ? nuevoItem : item1;

    final esCorrecto = pares.any((e) => e.key == concepto && e.value == palabra);
    if (esCorrecto && !seleccionados.containsKey(concepto)) {
      final color = getRandomColor();
      seleccionados[concepto] = palabra;
      coloresEmparejados[concepto] = color;
      aciertos++;
      player.play(AssetSource('sounds/correcto.mp3'));

      if (aciertos == pares.length) {
        siguienteNivel();
      }
    } else {
      player.play(AssetSource('sounds/incorrecto.mp3'));
    }

    setState(() => itemSeleccionado = null);
  }

  void siguienteNivel() {
    if (nivel == 5) {
      timer.cancel();
      player.play(AssetSource('sonidos/ganar.mp3'));
      showDialog(
        context: context,
        barrierDismissible: false, // <- evita cerrar con toque fuera
        builder: (_) => AlertDialog(
          title: const Text('¡Felicidades!'),
          content: const Text('Has completado todos los niveles'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Salir'),
            ),
          ],
        ),
      );
    } else {
      nivel++;
      cargarNivel();
      reiniciarTemporizador();
    }
  }

  void perderJuego() {
    timer.cancel();
    player.play(AssetSource('sonidos/perder.mp3'));
    showDialog(
      context: context,
      barrierDismissible: false, // <- evita cerrar con toque fuera
      builder: (_) => AlertDialog(
        title: const Text('¡Tiempo agotado!'),
        content: const Text('Has perdido el juego.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }

  Color getRandomColor() {
    final random = Random();
    return Color.fromARGB(255, random.nextInt(200), random.nextInt(200), random.nextInt(200));
  }

  @override
  void dispose() {
    timer.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (pares.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final conceptos = pares.map((e) => e.key).toList();
    final palabras = palabrasDesordenadas;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Relaciona Conceptos: Nivel $nivel',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: conceptos.length,
                    itemBuilder: (context, index) {
                      final concepto = conceptos[index];
                      final seleccionado = seleccionados.containsKey(concepto);
                      final color = coloresEmparejados[concepto] ?? Colors.white;
                      final estaSeleccionado = itemSeleccionado == concepto;

                      return GestureDetector(
                        onTap: seleccionado ? null : () => verificarEmparejamiento(concepto),
                        child: Card(
                          color: estaSeleccionado ? Colors.amber : color,
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              concepto,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: palabras.length,
                    itemBuilder: (context, index) {
                      final palabra = palabras[index];
                      final concepto = seleccionados.entries
                          .firstWhere((e) => e.value == palabra, orElse: () => const MapEntry('', ''))
                          .key;
                      final usada = concepto.isNotEmpty;
                      final color = coloresEmparejados[concepto] ?? Colors.white;
                      final estaSeleccionado = itemSeleccionado == palabra;

                      return GestureDetector(
                        onTap: usada ? null : () => verificarEmparejamiento(palabra),
                        child: Card(
                          color: estaSeleccionado ? Colors.amber : color,
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              palabra,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          LinearProgressIndicator(value: progreso, minHeight: 10),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.game),
    );
  }
}
