class Adventure {
  final String _name;
  final String _description;
  final String _createdAt;
  final String _masterUid;
  int _id;

  Adventure(this._name, this._description, this._createdAt, this._masterUid){
    this._id = DateTime.now().millisecondsSinceEpoch;
  }

  String get name => _name;

  String get description => _description;

  String get createdAt => _createdAt;

  String get masterUid => _masterUid;

  int get id => _id;
}