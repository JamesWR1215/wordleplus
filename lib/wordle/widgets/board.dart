import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:wordleplus/wordle/models/letter_model.dart';
import 'package:wordleplus/wordle/models/word_model.dart';

import 'board_tile.dart';

class Board extends StatelessWidget {
  //maps each word into a row of board tiles
  const Board({
    Key? key,
    required this.board,
    required this.flipCardKeys,
  }) : super(key: key);

  final List<Word> board;

  final List<List<GlobalKey<FlipCardState>>> flipCardKeys;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: board
          .asMap() //convert to map to get access to index when mapping
          .map(
            (i, word) => MapEntry(
              i,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: word.letters
                    .asMap()
                    .map(
                      (j, letter) => MapEntry(
                        j,
                        FlipCard(
                          //flip tiles when state changes
                          key: flipCardKeys[i][j],
                          flipOnTouch: false,
                          direction: FlipDirection.VERTICAL,
                          front: BoardTile(
                            letter: Letter(
                              val: letter.val,
                              status: LetterStatus.initial,
                            ),
                            val: letter.val,
                            status: LetterStatus.initial,
                          ),
                          back: BoardTile(
                              letter: letter,
                              val: letter.val,
                              status: LetterStatus.initial),
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
            ),
          )
          .values
          .toList(),
    ); //Column
  }
}
