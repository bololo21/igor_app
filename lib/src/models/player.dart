class Player {
  final String _id;
  final String _username;
  final String _characterName;
  final String _characterRace;
  final String _characterClass;
  final String _attack;
  final String _defense;
  final String _life;
  final String _avatar;

  Player(this._id, this._username, this._characterName , this._characterClass, this._characterRace, this._attack, this._defense, this._life, this._avatar);

  String get id => _id;
  String get username => _username;
  String get characterName => _characterName;
  String get characterRace => _characterRace;
  String get characterClass => _characterClass;
  String get attack => _attack;
  String get defense => _defense;
  String get life => _life;
  String get avatar => _avatar;

}