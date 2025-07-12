import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application/components/coustom_bottom_nav_bar.dart';
import 'package:flutter_application/constants.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_application/enums.dart';

class JuegoMemoramaPage extends StatefulWidget {
  final String asignatura;
  const JuegoMemoramaPage({super.key, required this.asignatura});

  @override
  State<JuegoMemoramaPage> createState() => _JuegoMemoramaPageState();
}

class _JuegoMemoramaPageState extends State<JuegoMemoramaPage> {
  List<String> _imagenes = [];
  List<bool> _descubiertas = [];
  List<int> _seleccionadas = [];
  int _nivel = 1;
  int _paresEncontrados = 0;
  bool _bloquear = false;
  late AudioPlayer _player;

  double _progresoTiempo = 0.0;
  Timer? _temporizador;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _inicializarJuego();
  }

  void _inicializarJuego() {
    _paresEncontrados = 0;
    int cantidad = _nivel;
    List<String> pares = List.generate(cantidad, (index) => 'imagen${index + 1}.png');
    _imagenes = [...pares, ...pares];
    _imagenes.shuffle();
    _descubiertas = List.filled(_imagenes.length, false);
    _seleccionadas = [];
    _progresoTiempo = 0.0;
    _temporizador?.cancel();
    _temporizador = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progresoTiempo += 0.01;
        if (_progresoTiempo >= 1.0) {
        timer.cancel();
        _reproducirSonido("reiniciar");
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text('¡Juego terminado!'),
            content: const Text('El tiempo se ha agotado. ¿Quieres volver a empezar desde el nivel 1?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _reiniciarJuego(); // 👈 vuelve al nivel 1
                },
                child: const Text('Reiniciar'),
              ),
            ],
          ),
        );
      }
      });
    });
    setState(() {});
  }

  Future<void> _reproducirSonido(String nombre) async {
    await _player.play(AssetSource('sounds/$nombre.mp3'));
  }

  void _reiniciarJuego() {
  _nivel = 1;
  _temporizador?.cancel();
  _inicializarJuego();
}


  void _tocarCarta(int index) async {
    if (_bloquear || _descubiertas[index] || _seleccionadas.length == 2) return;

    setState(() {
      _seleccionadas.add(index);
    });

    if (_seleccionadas.length == 2) {
      _bloquear = true;
      await Future.delayed(const Duration(seconds: 1));
      int i1 = _seleccionadas[0];
      int i2 = _seleccionadas[1];

      if (_imagenes[i1] == _imagenes[i2]) {
        _reproducirSonido("correcto");
        _descubiertas[i1] = true;
        _descubiertas[i2] = true;
        _paresEncontrados++;

        if (_paresEncontrados == _nivel) {
          _temporizador?.cancel();
          _reproducirSonido("nivel_completado");
          await Future.delayed(const Duration(seconds: 2));
          setState(() {
            _nivel++;
            if (_nivel > 10) _nivel = 1;
            _inicializarJuego();
          });
        }
      } else {
        _reproducirSonido("error");
      }

      _seleccionadas.clear();
      _bloquear = false;
      setState(() {});
    }
  }

  Widget _buildCarta(int index) {
    bool descubierta = _descubiertas[index] || _seleccionadas.contains(index);
    return GestureDetector(
      onTap: () => _tocarCarta(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: descubierta ? gColorTheme1_1 : gColorTheme1_800,
        ),
        child: descubierta
            ? Image.network(
                'https://firebasestorage.googleapis.com/v0/b/learnscience-1ef2d.appspot.com/o/memorama%2F${widget.asignatura}%2F${_imagenes[index]}?alt=media',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int columnas = max(2, min(6, (_nivel * 2 / 2).ceil()));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Juego del Memograma - Nivel $_nivel',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _imagenes.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnas,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) => _buildCarta(index),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: LinearProgressIndicator(
              value: _progresoTiempo,
              backgroundColor: Colors.grey[300],
              color: gColorTheme1_600,
              minHeight: 10,
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.game),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    _temporizador?.cancel();
    super.dispose();
  }
}
