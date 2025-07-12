import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/components/coustom_bottom_nav_bar.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controller_usuario.dart';
import 'package:flutter_application/enums.dart';
import 'package:flutter_application/models/juego.dart';
import 'package:flutter_application/pages/juegos/ahorcado/components/figura_ahorcado.dart';
import 'package:flutter_application/pages/juegos/ahorcado/components/letter_grid.dart';
import 'package:flutter_application/pages/juegos/ahorcado/components/teclado.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

class AhorcadoApp extends StatefulWidget {
  final String area;

  const AhorcadoApp({super.key, required this.area});

  @override
  State<AhorcadoApp> createState() => _AhorcadoAppState();
}

class _AhorcadoAppState extends State<AhorcadoApp> {
  final UsuarioController usuarioController = Get.find<UsuarioController>();

  String? areaSeleccionada;
  String word = '';
  List<String> alphabets = List.generate(26, (index) => String.fromCharCode(index + 65));
  Map<String, dynamic> subjects = {};
  bool gameStarted = false;
  bool gameWon = false;
  bool gameLost = false;
  Timer? _timer;
  int _remainingTime = 30;
  String hint = '';
  late AudioPlayer _player;

  final List<String> areasDisponibles = ['biologia', 'quimica', 'fisica'];

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    areaSeleccionada = areasDisponibles.contains(widget.area)
        ? widget.area
        : areasDisponibles.first;

    loadJsonData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _reproducirSonido(String nombre) async {
    await _player.play(AssetSource('sounds/$nombre.mp3'));
  }

  void startGame() {
    if (subjects.isNotEmpty) {
      final wordList = subjects[areaSeleccionada] as List<dynamic>;
      if (wordList.isEmpty) {
        showGameResultDialog('Error', 'No hay palabras disponibles para el tema seleccionado.');
        return;
      }

      setState(() {
        final selectedWordObject = (wordList..shuffle()).first;
        word = selectedWordObject['palabra'].toString().toUpperCase();
        hint = selectedWordObject['pista'];
        Game.selectedChar.clear();
        Game.tries = 0;
        gameStarted = true;
        gameWon = false;
        gameLost = false;
        _remainingTime = 30;
        _startTimer();
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_remainingTime == 0) {
        timer.cancel();
        setState(() {
          gameLost = true;
          gameStarted = false;
        });
        _reproducirSonido('reiniciar');
        showGameResultDialog('Perdiste', 'La palabra era: $word');
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  Future<void> loadJsonData() async {
    final String response = await rootBundle.loadString('assets/palabras.json');
    final data = json.decode(response);
    setState(() {
      subjects = data;
    });
  }

  void showHintDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pista'),
          content: Text(hint),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void updateGameState() async {
    if (!gameStarted) return;

    if (Game.tries >= 6 && !gameLost) {
      setState(() {
        gameLost = true;
        gameStarted = false;
      });
      _timer?.cancel();
      await _reproducirSonido('reiniciar');
      showGameResultDialog('Perdiste', 'La palabra era: $word');
    } else if (word.split('').every((char) => Game.selectedChar.contains(char)) && !gameWon) {
      setState(() {
        gameWon = true;
        gameStarted = false;
      });
      _timer?.cancel();
      await _reproducirSonido('nivel_completado');
      showGameResultDialog('¡Ganaste!', '¡Felicidades! Has adivinado la palabra.');
    }
  }

  void showGameResultDialog(String title, String content) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
      context: context,
      barrierDismissible: false, // <-- Esto impide cerrar el diálogo tocando fuera
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // Aquí puedes reiniciar el juego si quieres
                // startGame();
              },
            ),
          ],
        );
      },
    );
  });
}


  @override
  Widget build(BuildContext context) {
    updateGameState();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Juego del Ahorcado",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: subjects.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          areaSeleccionada!.toUpperCase(),
                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: startGame,
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            const Icon(Icons.access_time),
                            const SizedBox(width: 4),
                            Text(
                              '$_remainingTime s',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.lightbulb_outline),
                          onPressed: showHintDialog,
                          tooltip: 'Mostrar pista',
                        ),
                      ],
                    ),
                  ),
                  if (gameStarted) ...[
                    LetterGrid(word: word),
                    HangmanFigure(tries: Game.tries),
                    Keyboard(
                      alphabets: alphabets,
                      onLetterPressed: (letter) async {
                        if (!Game.selectedChar.contains(letter)) {
                          setState(() {
                            Game.selectedChar.add(letter);
                            if (!word.contains(letter)) Game.tries++;
                          });

                          if (word.contains(letter)) {
                            await _reproducirSonido("correcto");
                          } else {
                            await _reproducirSonido("error");
                          }

                          updateGameState();
                        }
                      },
                      selectedLetters: List.from(Game.selectedChar),
                    ),
                  ],
                ],
              ),
            ),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.game),
    );
  }
}




Widget letterWidget(String character, bool hidden) {
  return Container(
    padding: const EdgeInsets.all(5.0),
    decoration: BoxDecoration(
      color: gBackgroundColor,
      borderRadius: BorderRadius.circular(4.0),
      border: Border.all(color: Colors.white),
    ),
    child: Center(
      child: Visibility(
        visible: !hidden,
        child: Text(
          character,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25.0, // Tamaño de letra ajustable
          ),
        ),
      ),
    ),
  );
}

Widget figureImage(bool visible, String path) {
  return Visibility(
    visible: visible,
    child: SizedBox(
      width: 250,
      height: 250,
      child: Image.asset(path),
    ),
  );
}
