import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math';
import 'history_page.dart';
import 'play_history.dart';

class Gamepage extends StatefulWidget {
  @override
  //State<gamepage> createState() => _gamepageState();
  State<Gamepage> createState() => _GamepageState();
}

class _GamepageState extends State<Gamepage> {
  static const String PLAYER_X = "X";
  static const String PLAYER_O = "O";
  late String currentPlayer;
  late bool gameEnd;
  late List<String> occupied;
  bool isAgainstBot = false;
  late PlayHistoryDatabase _playHistoryDb;

  @override
  void initState() {
    super.initState();
    _playHistoryDb = PlayHistoryDatabase();
    _initializeDatabase();
    initializeGame();
    if (isAgainstBot && currentPlayer == PLAYER_O) {
      Future.delayed(Duration(seconds: 1), () {
        botMakeMove();
      });
    }
  }

  Future<void> _initializeDatabase() async {
    await _playHistoryDb.openDatabasee();
  }

  void initializeGame() {
    currentPlayer = PLAYER_X;
    gameEnd = false;
    occupied = ["", "", "", "", "", "", "", "", ""];
    //if (isAgainstBot && currentPlayer == PLAYER_O) {
    // If playing against bot and it's the bot's turn
    //botMakeMove();
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tic Tac Toe",
          style: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Tic Tac",
              style: TextStyle(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "$currentPlayer Turn",
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            //_headerText(),
            _gameContainer(),
            _restartButton(),
            _toggleGameModeButton(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: "Play Game",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "View History",
          ),
        ],
        currentIndex: _selectedIndex, // เลือก Index ของเเถบปัจจุบัน
        onTap:
            _onBottomNavigationBarItemTapped, // ฟังก์ชันที่เรียกเมื่อเลือกเเถบ
      ),
    );
  }

  int _selectedIndex = 0;

  // ฟังก์ชันที่เรียกเมื่อเลือกเเถบ BottomNavigationBar
  void _onBottomNavigationBarItemTapped(int index) {
    if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => HistoryPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

Widget _toggleGameModeButton() {
  return ElevatedButton(
    onPressed: () {
      setState(() {
        isAgainstBot = true;
        currentPlayer = PLAYER_X; // Assuming you want the player to start
        botMakeMove();
      });
    },
    child: Text("Play a Bot"),
  );
}



  Widget _gameContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 2,
      margin: const EdgeInsets.all(8),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: 9,
          itemBuilder: (context, int index) {
            return _box(index);
          }),
    );
  }

  Widget _box(int index) {
    return InkWell(
      onTap: () {
        //on click of box
        if (gameEnd || occupied[index].isNotEmpty) {
          //return is gmae already end or box already clicked
          return;
        }
        setState(() {
          occupied[index] = currentPlayer;
          changeTurn();
          checkForWinner(occupied, currentPlayer);
          checkForDraw(occupied);
        });
      },
      child: Container(
        color: Colors.green,
        margin: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            occupied[index],
            style: const TextStyle(fontSize: 50),
          ),
        ),
      ),
    );
  }

  _restartButton() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            initializeGame();
          });
        },
        child: const Text("Restart Game"));
  }

  changeTurn() {
    if (currentPlayer == PLAYER_X) {
      currentPlayer = PLAYER_O;
    } else {
      currentPlayer = PLAYER_X;
    }
  }

  bool checkForWinner(List<String> board, String player) {
    //Define winning positions
    List<List<int>> winningList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var winngingPos in winningList) {
      String playerPosition0 = occupied[winngingPos[0]];
      String playerPosition1 = occupied[winngingPos[1]];
      String playerPosition2 = occupied[winngingPos[2]];

      if (playerPosition0.isNotEmpty) {
        if (playerPosition0 == playerPosition1 &&
            playerPosition0 == playerPosition2) {
          showGameOverMessage("Player $playerPosition0 Win");
          gameEnd = true;
          return true;
        }
      }
    }
    return false;
  }

  bool checkForDraw(List<String> board) {
    if (gameEnd) {
      return false;
    }
    bool draw = true;
    for (var occupiedPlayer in occupied) {
      if (occupiedPlayer.isEmpty) {
        draw = false;
      }
    }
    if (draw) {
      showGameOverMessage("Draw");
      gameEnd = true;
    }
    return draw;
  }

  showGameOverMessage(String message) {
    final DateTime now = DateTime.now();
    final String playDate = "${now.year}-${now.month}-${now.day}";
    final String playTime = "${now.hour}:${now.minute}:${now.second}";
    _playHistoryDb.insertPlay(message, playDate, playTime);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Game Over \n $message",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
    endGame();
  }

  void endGame() async {
    // Call the endGame method to save the winner to the database
    String winner = currentPlayer; // Assuming "currentPlayer" is the winner
    await _playHistoryDb.openDatabasee();
    await _playHistoryDb.insertPlay(
        winner, DateTime.now().toString(), DateTime.now().toString());
    await _playHistoryDb.closeDatabase();
  }

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
            checkForWinner(occupied, currentPlayer);
            checkForDraw(occupied);
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
            checkForWinner(occupied, currentPlayer);
            checkForDraw(occupied);
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
        checkForWinner(occupied, currentPlayer);
        checkForDraw(occupied);
      });
    }
  }
  List<int> availableMoves(List<String> board) {
  List<int> moves = [];
  for (int i = 0; i < board.length; i++) {
    if (board[i].isEmpty) {
      moves.add(i);
    }
  }
  return moves;
}
int minimax(List<String> board, String currentPlayer) {
  if (checkForWinner(board, PLAYER_X)) {
    return -10; // X wins
  } else if (checkForWinner(board, PLAYER_O)) {
    return 10; // O wins
  } else if (checkForDraw(board)) {
    return 0; // It's a draw
  }

  List<int> scores = [];
  List<int> moves = availableMoves(board);

  for (int move in moves) {
    List<String> newBoard = makeMove(board, move, currentPlayer);

    if (currentPlayer == PLAYER_O) {
      int score = minimax(newBoard, PLAYER_X); // Recursive call for X's turn
      scores.add(score);
    } else {
      int score = minimax(newBoard, PLAYER_O); // Recursive call for O's turn
      scores.add(score);
    }
  }

  if (currentPlayer == PLAYER_O) {
    int maxScore = scores.reduce(max);
    return maxScore;
  } else {
    int minScore = scores.reduce(min);
    return minScore;
  }
}
List<String> makeMove(List<String> board, int move, String player) {
  List<String> newBoard = List.from(board);
  newBoard[move] = player;
  return newBoard;
}
  
  int findBestMove(List<String> board) {
    int bestMove = -1;
    int bestScore = -10000;
    for (int move in availableMoves(board)) {
      int score = minimax(makeMove(board, move, PLAYER_O), PLAYER_X);
      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }
    return bestMove;
  }
  bool isWinningMove(List<String> board, String player) {
  List<List<int>> winningList = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  for (var winningPos in winningList) {
    int pos1 = winningPos[0];
    int pos2 = winningPos[1];
    int pos3 = winningPos[2];

    if (board[pos1] == player && board[pos2] == player && board[pos3] == player) {
      return true;
    }
  }

  return false;
}
}
