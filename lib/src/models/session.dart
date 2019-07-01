class Session {
  final String _id;
  final String _name;
  final String _adventureUid;
  final DateTime _date;

  Session(this._id, this._name, this._adventureUid, this._date);

  String get id => _id;
  String get name => _name;
  String get adventureUid => _adventureUid;
  DateTime get date => _date;

}