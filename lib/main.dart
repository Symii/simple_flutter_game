import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(BattleGame());
}

class BattleGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battle Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BattleScreen(),
    );
  }
}

class BattleScreen extends StatefulWidget {
  @override
  _BattleScreenState createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  int playerHp = 100;
  int playerStamina = 50;
  int enemyHp = 100;
  int enemyStamina = 50;
  Random random = Random();

  void performAction(String action) {
    setState(() {
      if (action == 'weak_attack' && playerStamina >= 5) {
        int damage = random.nextInt(10) + 5;
        enemyHp -= damage;
        playerStamina -= 5;
      } else if (action == 'medium_attack' && playerStamina >= 10) {
        int damage = random.nextInt(15) + 10;
        enemyHp -= damage;
        playerStamina -= 10;
      } else if (action == 'strong_attack' && playerStamina >= 20) {
        int damage = random.nextInt(25) + 20;
        enemyHp -= damage;
        playerStamina -= 20;
      } else if (action == 'regenerate') {
        int heal = random.nextInt(15) + 10;
        playerHp = min(playerHp + heal, 100);
        playerStamina = min(playerStamina + 15, 50);
      }

      enemyTurn();

      if (playerHp <= 0) {
        showEndDialog('Przegrałeś!');
      } else if (enemyHp <= 0) {
        showEndDialog('Wygrałeś!');
      }
    });
  }

  void enemyTurn() {
    if (enemyHp <= 0) return;

    int choice = random.nextInt(4);
    if (choice == 0 && enemyStamina >= 5) {
      int damage = random.nextInt(10) + 5;
      playerHp -= damage;
      enemyStamina -= 5;
    } else if (choice == 1 && enemyStamina >= 10) {
      int damage = random.nextInt(15) + 10;
      playerHp -= damage;
      enemyStamina -= 10;
    } else if (choice == 2 && enemyStamina >= 20) {
      int damage = random.nextInt(25) + 20;
      playerHp -= damage;
      enemyStamina -= 20;
    } else if (choice == 3) {
      int heal = random.nextInt(15) + 10;
      enemyHp = min(enemyHp + heal, 100);
      enemyStamina = min(enemyStamina + 15, 50);
    }
  }

  void showEndDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Koniec gry'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: Text('Zagraj ponownie'),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      playerHp = 100;
      playerStamina = 50;
      enemyHp = 100;
      enemyStamina = 50;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battle Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Twoje HP:', style: TextStyle(fontSize: 18)),
                      SizedBox(
                        width: double.infinity,
                        child: LinearProgressIndicator(
                          value: playerHp / 100,
                          backgroundColor: Colors.red.shade100,
                          color: Colors.red,
                        ),
                      ),
                      Text('Wytrzymałość:', style: TextStyle(fontSize: 18)),
                      SizedBox(
                        width: double.infinity,
                        child: LinearProgressIndicator(
                          value: playerStamina / 50,
                          backgroundColor: Colors.blue.shade100,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('HP Przeciwnika:', style: TextStyle(fontSize: 18)),
                      SizedBox(
                        width: double.infinity,
                        child: LinearProgressIndicator(
                          value: enemyHp / 100,
                          backgroundColor: Colors.red.shade100,
                          color: Colors.red,
                        ),
                      ),
                      Text('Wytrzymałość:', style: TextStyle(fontSize: 18)),
                      SizedBox(
                        width: double.infinity,
                        child: LinearProgressIndicator(
                          value: enemyStamina / 50,
                          backgroundColor: Colors.blue.shade100,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: playerStamina >= 5 ? () => performAction('weak_attack') : null,
                  child: Text('Słaby Atak'),
                ),
                ElevatedButton(
                  onPressed: playerStamina >= 10 ? () => performAction('medium_attack') : null,
                  child: Text('Średni Atak'),
                ),
                ElevatedButton(
                  onPressed: playerStamina >= 20 ? () => performAction('strong_attack') : null,
                  child: Text('Mocny Atak'),
                ),
                ElevatedButton(
                  onPressed: () => performAction('regenerate'),
                  child: Text('Regeneracja'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
