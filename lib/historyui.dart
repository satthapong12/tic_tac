import 'package:flutter/material.dart';

class HistoryDialog extends StatelessWidget {
  final List<String> gameHistory;

  HistoryDialog(this.gameHistory);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Game History'),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: gameHistory.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                gameHistory[index],
                style: TextStyle(fontSize: 18), // ปรับขนาดตัวอักษรเพื่อความอ่านง่าย
              ),
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Close',
            style: TextStyle(fontSize: 16), // ปรับขนาดตัวอักษรเพื่อความสวยงาม
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
