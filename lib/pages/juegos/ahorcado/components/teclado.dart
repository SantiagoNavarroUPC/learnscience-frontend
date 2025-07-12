
import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';

class Keyboard extends StatelessWidget {
  final List<String> alphabets;
  final void Function(String) onLetterPressed;
  final List<String> selectedLetters; // Cambiado a List<String>

  const Keyboard({super.key, 
    required this.alphabets,
    required this.onLetterPressed,
    
    required this.selectedLetters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: GridView.count(
          crossAxisCount: 7,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: alphabets.map((letter) {
            return RawMaterialButton(
              onPressed: selectedLetters.contains(letter)
                  ? null
                  : () => onLetterPressed(letter),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              fillColor: selectedLetters.contains(letter)
                  ? gColorTheme1_900
                  : gBackgroundColor,
              child: Text(
                letter,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}