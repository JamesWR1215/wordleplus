import 'package:equatable/equatable.dart';
import 'package:wordleplus/wordle/wordle.dart';

class Word extends Equatable {
  final List<Letter> letters;
  const Word({required this.letters}); //list of letters in word

  factory Word.fromString(String word) => //convert string of letters to List
      Word(
          letters: word
              .split('')
              .map((e) => Letter(val: e))
              .toList()); // maps each element to a letter

  String get wordString => letters //get string version of word
      .map((e) => e.val)
      .join(); // joins string val of each letter

  void addLetter(String val) {
    //add letter to word
    final currentIndex =
        letters.indexWhere((e) => e.val.isEmpty); //first index of empty string
    if (currentIndex != -1) {
      letters[currentIndex] =
          Letter(val: val); //sets letters at proper positions
    }

    void removeLetter() {
      final recentLetterIndex =
          letters.lastIndexWhere(//index of most recent letter
              (e) => e.val.isNotEmpty); //last index that is not empty string
      if (recentLetterIndex != -1) {
        letters[recentLetterIndex] =
            Letter.empty(); //empty letter at that position
      }
    }
  }

  @override // dont forget to add props
  List<Object?> get props => [letters];
}
