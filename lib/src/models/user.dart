class User {
  final String _id;
  final String _username;
  final String _token;


  User(this._id, this._username, this._token);

  String get id => _id;
  String get username => _username;
  String get token => _token;


}