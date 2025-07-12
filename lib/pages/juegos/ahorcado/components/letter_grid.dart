
import 'package:flutter/material.dart';
import 'package:flutter_application/models/juego.dart';
import 'package:flutter_application/pages/juegos/ahorcado/ahorcado.dart';

class LetterGrid extends StatelessWidget {
  final String word;

  const LetterGrid({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final double containerHeight = word.length > 7 ? 100.0 : 50.0;

    return Container(
      height: containerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemCount: word.length,
        itemBuilder: (context, index) {
          final letter = word[index];
          final hidden = !Game.selectedChar.contains(letter);
          return letterWidget(letter, hidden);
        },
      ),
    );
  }
}