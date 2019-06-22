import 'package:d20/d20.dart';
import 'package:flutter/material.dart';
import 'package:d20/roll_statistics.dart';

class DiceRolling extends StatefulWidget {
  @override
  _DiceRollingState createState() => _DiceRollingState();
}

class _DiceRollingState extends State<DiceRolling> {
  @override
  final D20 d20 = D20();
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(d20.roll('1d20').toString(), style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}
