import 'gamePage.dart';
import 'history_page.dart';
import 'play_history.dart';

class bot {
   void botMakeMove() {
    // Bot makes a move based on a simple strategy
    List<int> availableIndexes = [];
    for (var i = 0; i < occupied.length; i++) {
      if (occupied[i].isEmpty) {
        availableIndexes.add(i);
      }
    }

    if (availableIndexes.isNotEmpty) {
      // Check for winning move
      for (var index in availableIndexes) {
        List<String> newOccupied = List.from(occupied);
        newOccupied[index] = PLAYER_O;
        if (isWinningMove(newOccupied, PLAYER_O)) {
          setState(() {
            occupied[index] = PLAYER_O;
            changeTurn();
            checkForWinner();
            checkForDraw();
          });
          return;
        }
      }

      // Check for blocking opponent's winning move
      for (var index in availableIndexes) {
        List<String> newOccupied = List.from(occupied);
        newOccupied[index] = PLAYER_X;
        if (isWinningMove(newOccupied, PLAYER_X)) {
          setState(() {
            occupied[index] = PLAYER_O;
            changeTurn();
            checkForWinner();
            checkForDraw();
          });
          return;
        }
      }

      // Choose a random available move
      final randomIndex =
          availableIndexes[Random().nextInt(availableIndexes.length)];
      setState(() {
        occupied[randomIndex] = PLAYER_O;
        changeTurn();
        checkForWinner();
        checkForDraw();
      });
    }
  }
}