class Adventure {
  final String _id;
  final String _name;
  final String _description;
  final String _createdAt;
  final String _masterUid;
  final String _imagePath;

  Adventure(this._id, this._name, this._description, this._createdAt, this._masterUid, this._imagePath);

  String get id => _id;  String get name => _name;

  String get description => _description;

  String get createdAt => _createdAt;

  String get masterUid => _masterUid;

  String get imagePath => _imagePath;
}