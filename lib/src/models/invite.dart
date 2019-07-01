class Invite {
  final String _userUid;
  final String _adventureUid;
  final String _inviteUid;

  Invite(this._userUid, this._adventureUid, this._inviteUid);

  String get userUid => _userUid;
  String get adventureUid => _adventureUid;
  String get inviteUid => _inviteUid;

}