import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/components/coustom_bottom_nav_bar.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/enums.dart';
import 'package:flutter_application/models/juego.dart';
import 'package:flutter_application/pages/juegos/ahorcado/components/figura_ahorcado.dart';
import 'package:flutter_application/pages/juegos/ahorcado/components/letter_grid.dart';
import 'package:flutter_application/pages/juegos/ahorcado/components/teclado.dart';

class AhorcadoApp extends StatefulWidget {
  final String area; // Añadido

  const AhorcadoApp({super.key, required this.area}); // Constructor actualizado

  @override
  _AhorcadoAppState createState() => _AhorcadoAppState();
}


class _AhorcadoAppState extends State<AhorcadoApp> {
  String selectedSubject = 'biologia';
  String word = '';
  List<String> alphabets = List.generate(26, (index) => String.fromCharCode(index + 65));
  Map<String, dynamic> subjects = {};
  bool gameStarted = false;
  bool gameWon = false;
  bool gameLost = false;
  Timer? _timer;
  int _remainingTime = 30;
  String hint = '';

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startGame() {
    if (subjects.isNotEmpty) {
      final wordList = subjects[widget.area] as List<dynamic>;
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
      _timer?.cancel(); // Cancelar cualquier temporizador anterior
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        if (_remainingTime == 0) {
          timer.cancel();
          setState(() {
            gameLost = true;
            gameStarted = false;
          });
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
    final data = await json.decode(response);
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
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void onSubjectChanged(String? newSubject) {
    setState(() {
      selectedSubject = newSubject!;
    });
  }

  void updateGameState() {
    if (!gameStarted) return;

    if (Game.tries >= 6 && !gameLost) {
      setState(() {
        gameLost = true;
        gameStarted = false;
      });
      _timer?.cancel(); // Cancelar el temporizador si se pierde
      showGameResultDialog('Perdiste', 'La palabra era: $word');
    } else if (word.split('').every((char) => Game.selectedChar.contains(char)) && !gameWon) {
      setState(() {
        gameWon = true;
        gameStarted = false;
      });
      _timer?.cancel(); // Cancelar el temporizador si se gana
      showGameResultDialog('¡Ganaste!', '¡Felicidades! Has adivinado la palabra.');
    }
  }

  void showGameResultDialog(String title, String content) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
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
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: subjects.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: Text(
                          widget.area.toUpperCase(), // Mostrar el área seleccionada
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: gTextColor, // Color de texto
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: IconButton(
                          icon: const Icon(Icons.play_arrow, size: 30.0, color: gTextColor), // Ícono de reproducción
                          onPressed: startGame,
                          padding: const EdgeInsets.all(10.0), // Espacio alrededor del ícono
                          color: gButtonColor, // Fondo del ícono
                          iconSize: 30.0, 
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Colors.black,
                              size: 25.0,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              '$_remainingTime s',
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),      
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.lightbulb_outline),
                              tooltip: 'Mostrar pista',
                              onPressed: showHintDialog,
                            ),            
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (gameStarted) ...[
                  LetterGrid(word: word),
                  HangmanFigure(tries: Game.tries),
                  Keyboard(
                    alphabets: alphabets,
                    onLetterPressed: (letter) {
                      setState(() {
                        Game.selectedChar.add(letter);
                        if (!word.split('').contains(letter.toUpperCase())) {
                          Game.tries++;
                        }
                        updateGameState();
                      });
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
