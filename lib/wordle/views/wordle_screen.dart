// ignore_for_file: unused_field, empty_statements

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wordleplus/wordle/models/letter_model.dart';
import 'package:wordleplus/wordle/models/word_model.dart';

import '../data/word_list.dart';
import '../widgets/board.dart';

enum GameStatus { playing, submitting, lost, won } //different states of game

class WordleScreen extends StatefulWidget {
  //handles game state of application
  const WordleScreen({Key? key}) : super(key: key);

  @override
  State<WordleScreen> createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> {
  GameStatus _gameStatus = GameStatus.playing; //set status to playing on init

  final List<Word> _board = List.generate(
    //generates board with 6 words
    6,
    (_) => Word(letters: List.generate(5, (_) => Letter.empty())),
  );

  int _currentWordIndex = 0; //track which guess player is on

  Word? get _currentWord => //get current guess of word
      _currentWordIndex < _board.length
          ? _board[_currentWordIndex]
          : null; //returns word or null if out of range

  // ignore: prefer_final_fields
  Word _solution = Word.fromString(
    fiveLetterWords[Random().nextInt(fiveLetterWords.length)]
        .toUpperCase(), //grabs randon word as solution
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'WORDLE PLUS',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Board(board: _board), //custom widget that takes in list of words
      ]),
    );
  }
}
