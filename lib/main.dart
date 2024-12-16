import 'package:flutter/material.dart';

void main() {
  runApp(TrixCounterApp());
}

class TrixCounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trix Game Counter',
      home: TrixCounterPage(),
    );
  }
}

class TrixCounterPage extends StatefulWidget {
  @override
  _TrixCounterPageState createState() => _TrixCounterPageState();
}

class _TrixCounterPageState extends State<TrixCounterPage> {
  List<int> scores = [0, 0, 0, 0];
  List<String> playerNames = ['player1', 'player2', 'player3', 'player4'];
  List<TextEditingController> controllers = List.generate(4, (_) => TextEditingController());

  void updateScore(int playerIndex, int change) {
    setState(() {
      scores[playerIndex] += change;
    });
  }

  void resetScores() {
    setState(() {
      scores = [0, 0, 0, 0];
      controllers.forEach((controller) => controller.clear());
    });
  }

  String getLeader() {
    int maxScore = scores.reduce((a, b) => a > b ? a : b);
    List<String> leaders = [];
    for (int i = 0; i < scores.length; i++) {
      if (scores[i] == maxScore) {
        leaders.add(playerNames[i]);
      }
    }
    return leaders.join(', ');
  }

  String getLoser() {
    int minScore = scores.reduce((a, b) => a < b ? a : b);
    List<String> losers = [];
    for (int i = 0; i < scores.length; i++) {
      if (scores[i] == minScore) {
        losers.add(playerNames[i]);
      }
    }
    return losers.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: Text('Trix Game Counter'),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white70,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: resetScores,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            ...List.generate(4, (index) => buildPlayerCard(index)),
            SizedBox(height: 16.0),
            Text(
              'Winner: ${getLeader()}',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 8.0),
            Text(
              'Loser: ${getLoser()}',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlayerCard(int playerIndex) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        playerNames[playerIndex] = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: playerNames[playerIndex],
                    ),
                  ),
                ),
                SizedBox(width: 30.0),
                Text(
                  scores[playerIndex].toString(),
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: controllers[playerIndex],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter points',
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.red),
                  onPressed: () {
                    final input = int.tryParse(controllers[playerIndex].text) ?? 0;
                    updateScore(playerIndex, -input);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.green),
                  onPressed: () {
                    final input = int.tryParse(controllers[playerIndex].text) ?? 0;
                    updateScore(playerIndex, input);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
