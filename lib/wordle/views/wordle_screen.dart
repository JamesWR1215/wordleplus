// ignore_for_file: unused_field, empty_statements

import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:wordleplus/app/app_colors.dart';
import 'package:wordleplus/wordle/models/letter_model.dart';
import 'package:wordleplus/wordle/models/word_model.dart';
import 'package:wordleplus/wordle/widgets/keyboard.dart';

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

  final List<List<GlobalKey<FlipCardState>>> _flipCardKeys = List.generate(
    //list of lists of global flip card keys & states
    6,
    (_) => List.generate(5, (_) => GlobalKey<FlipCardState>()),
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

  final Set<Letter> _keyboardLetters = {}; //keep track of letters and status

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
        Board(
            board: _board,
            flipCardKeys:
                _flipCardKeys), //custom widget that takes in list of words
        const SizedBox(height: 80),
        Keyboard(
          onKeyTapped: _onKeyTapped,
          onDeleteTapped: _onDeleteTapped,
          onEnterTapped: _onEnterTapped,
          letters: _keyboardLetters,
        )
      ]),
    );
  }

  void _onKeyTapped(String val) {
    if (_gameStatus == GameStatus.playing) {
      //checks if game status is playing
      setState(() =>
          _currentWord?.addLetter(val)); //add letter to word and rebuild UI
    }
  }

  void _onDeleteTapped() {
    if (_gameStatus == GameStatus.playing) {
      //checks if game status is playing
      setState(() => _currentWord?.removeLetter()); //remove letter from word
    }
  }

  Future<void> _onEnterTapped() async {
    if (_gameStatus == GameStatus.playing && //checks if game status is playing
        _currentWord != null &&
        !_currentWord!.letters.contains(Letter.empty())) {
      //checks for no empty letters
      _gameStatus =
          GameStatus.submitting; // prevents users from spamming enter button

      for (var i = 0; i < _currentWord!.letters.length; i++) {
        //compare submited word with solution, iterate thru both words
        final currentWordLetter = _currentWord!.letters[i];
        final currentSolutionLetter = _solution.letters[i];

        setState(() {
          //update letter status of current word's letters
          if (currentWordLetter == currentSolutionLetter) {
            _currentWord!.letters[i] = currentWordLetter.copyWith(
                status: LetterStatus.correct); //correct letter
          } else if (_solution.letters.contains(currentWordLetter)) {
            _currentWord!.letters[i] = currentWordLetter.copyWith(
                status: LetterStatus.inWord); //letter in wrong spot
          } else {
            _currentWord!.letters[i] = currentWordLetter.copyWith(
                status: LetterStatus.notInWord); //not in word
          }
        });

        final letter = _keyboardLetters.firstWhere(
          //grab existing letter
          (e) => e.val == currentWordLetter.val,
          orElse: () => Letter.empty(),
        );
        if (letter.status != LetterStatus.correct) {
          //if letter is not correct, update keyboard state
          _keyboardLetters.removeWhere((e) => e.val == currentWordLetter.val);
          _keyboardLetters.add(_currentWord!.letters[i]);
        }

        await Future.delayed(
          const Duration(microseconds: 150),
          () => _flipCardKeys[_currentWordIndex][i]
              .currentState
              ?.toggleCard(), //flip card after word's letter status updated
        );
      }

      _checkIfWinOrLoss();
    }
  }

  void _checkIfWinOrLoss() {
    if (_currentWord!.wordString == _solution.wordString) {
      //compares current word and solution word strings
      _gameStatus = GameStatus.won;
      ScaffoldMessenger.of(context).showSnackBar(// win notification
          SnackBar(
        dismissDirection: DismissDirection.none,
        duration: const Duration(days: 1),
        backgroundColor: correctColor,
        content: const Text(
          'Winner!',
          style: TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          label: 'New Game',
          onPressed: _restart,
          textColor: Colors.white,
        ),
      ));
    } else if (_currentWordIndex + 1 >= _board.length) {
      _gameStatus = GameStatus.lost;
      ScaffoldMessenger.of(context).showSnackBar(
        // loss notification
        SnackBar(
          dismissDirection: DismissDirection.none,
          duration: const Duration(days: 1),
          backgroundColor: Colors.red,
          content: Text(
            'Loser! Solution: ${_solution.wordString}',
            style: const TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            label: 'New Game',
            onPressed: _restart,
            textColor: Colors.white,
          ),
        ),
      );
    } else {
      //user has not won or lost yet
      _gameStatus = GameStatus.playing;
    }
    _currentWordIndex += 1;
  }

  void _restart() {
    setState(() {
      //reset state variables back to initial states
      _gameStatus = GameStatus.playing;
      _currentWordIndex = 0;
      _board
        ..clear()
        ..addAll(
          List.generate(
            6,
            (_) => Word(letters: List.generate(5, (_) => Letter.empty())),
          ),
        );
      _solution = Word.fromString(
        //set solution to new random word
        fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase(),
      );
      _flipCardKeys //reset flipcard keys to initial state
        ..clear()
        ..addAll(
          List.generate(
            6,
            (_) => List.generate(5, (_) => GlobalKey<FlipCardState>()),
          ),
        );
      _keyboardLetters.clear(); //clears status of all letters
    });
  }
}
