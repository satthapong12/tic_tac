import 'package:flutter/material.dart';
import 'play_history.dart';
import 'gamePage.dart';


class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState(PlayHistoryDatabase());
}

class _HistoryPageState extends State<HistoryPage> {
   final PlayHistoryDatabase _playHistoryDb;
    _HistoryPageState(this._playHistoryDb);

  @override
  void initState() {
     // Initialize the database
    super.initState();
    //_initDatabase();
    _loadPlayHistory();
  }
   Future<void> _initDatabase() async {
    await _playHistoryDb.openDatabasee();
  }

  @override
  void dispose() {
    final playHistoryDb = PlayHistoryDatabase();
    _playHistoryDb.closeDatabase();
    super.dispose();
  }
  // Inside a HistoryPage widget
Future<void> _loadPlayHistory() async {
  final playHistoryDb = PlayHistoryDatabase();
  await playHistoryDb.openDatabasee();
  final playHistory = await playHistoryDb.getPlayHistory();
  // Display the play history to the user
  await playHistoryDb.closeDatabase();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game History"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _playHistoryDb.getPlayHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No game history."));
          } else {
            final List<Map<String, dynamic>> gameHistory = snapshot.data!;
            return ListView.builder(
              itemCount: gameHistory.length,
              itemBuilder: (context, index) {
                final gameInfo = gameHistory[index];
                final String winner = gameInfo['winner'];
                final String playDate = gameInfo['play_date'];
                final String playTime = gameInfo['play_time'];
                return ListTile(
                  title: Text("Winner: $winner"),
                  subtitle: Text("Date: $playDate, Time: $playTime"),
                );
              },
            );
          }
        },
      ),
    );
  }
}
