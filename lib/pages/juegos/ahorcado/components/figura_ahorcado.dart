
import 'package:flutter/widgets.dart';
import 'package:flutter_application/pages/juegos/ahorcado/ahorcado.dart';

class HangmanFigure extends StatelessWidget {
  final int tries;

  const HangmanFigure({super.key, required this.tries});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          figureImage(tries >= 0, "assets/images/games/hang.png"),
          figureImage(tries >= 1, "assets/images/games/head.png"),
          figureImage(tries >= 2, "assets/images/games/body.png"),
          figureImage(tries >= 3, "assets/images/games/ra.png"),
          figureImage(tries >= 4, "assets/images/games/la.png"),
          figureImage(tries >= 5, "assets/images/games/rl.png"),
          figureImage(tries >= 6, "assets/images/games/ll.png"),
        ],
      ),
    );
  }
}