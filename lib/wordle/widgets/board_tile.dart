import 'package:flutter/material.dart';
import 'package:wordleplus/wordle/wordle.dart';
import '../models/letter_model.dart';

class BoardTile extends StatelessWidget {
  const BoardTile(
      {Key? key,
      required this.letter,
      required String val,
      required LetterStatus status})
      : super(key: key);
  final Letter letter;

  @override
  Widget build(BuildContext context) {
    //creates board tile
    return Container(
      margin: const EdgeInsets.all(4),
      height: 48,
      width: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: letter.backgroundColor,
        border: Border.all(color: letter.borderColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        //display leter value
        letter.val,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
