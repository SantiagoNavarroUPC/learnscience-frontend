import 'package:flutter/material.dart';

class LetterTile extends StatelessWidget {
  final String letter;
  final int row;
  final int col;
  final Function(int, int, String) onLetterDrag;

  const LetterTile({
    super.key,
    required this.letter,
    required this.row,
    required this.col,
    required this.onLetterDrag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (_) => onLetterDrag(row, col, letter),
      onPanUpdate: (details) => onLetterDrag(row, col, letter),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(2),
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
        ),
        child: Text(
          letter,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
