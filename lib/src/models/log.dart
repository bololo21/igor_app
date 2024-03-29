import 'package:cloud_firestore/cloud_firestore.dart';

class Log {
  final String _characterName;
  final int _diceValue;
  final String _id;
  final String _dice;
  final Timestamp _timestamp;

  Log(this._id, this._characterName, this._diceValue, this._dice, this._timestamp);

  String get characterName => _characterName;
  String get dice => _dice;
  int get diceValue => _diceValue;
  String get id => _id;
  Timestamp get timestamp => _timestamp;

}