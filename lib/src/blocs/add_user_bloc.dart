import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash/dash.dart';
import 'package:igor_app/src/models/adventure.dart';
import 'package:igor_app/src/models/invite.dart';
import 'package:igor_app/src/models/user.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class AddUserBloc extends Bloc {
  final _repository = Repository();
  final _username = BehaviorSubject<String>();

  Observable<String> get username => _username.stream;

  Function(String) get changeUsername => _username.sink.add;

  Stream<DocumentSnapshot> getAdventureData(String adventureUid) {
    return _repository.getAdventureData(adventureUid);
  }

  Adventure mapToAdventure({DocumentSnapshot document}) {
    Adventure adventure = Adventure(
        document.documentID,
        document.data["name"],
        document.data["description"],
        document.data["createdAt"],
        document.data["masterUid"],
        document.data["imagePath"]);
    return adventure;
  }

  Stream<QuerySnapshot> getUsersData() {
    return _repository.getUsersData();
  }

  Stream<QuerySnapshot> getUsersInAdventure(String adventureUid) {
    return _repository.getUsersInAdventure(adventureUid);
  }

  Stream<QuerySnapshot> getInvitedUsers(String adventureUid) {
    return _repository.getInvitedUsers(adventureUid);
  }

  Future<void> inviteUser(User user, String adventureUid){
    return _repository.inviteUser(user, adventureUid);
  }

  List mapToList({List<DocumentSnapshot> docList}) {
    List<User> userList = [];
    docList.forEach((document) {
      User user = User(
        document.documentID,
        document.data["username"]
      );
      userList.add(user);
    });
    return userList;
  }

  List mapToInviteList({List<DocumentSnapshot> docList}) {
    List<Invite> inviteList = [];
    docList.forEach((document) {
      Invite invite = Invite(
          document.data["userUid"],
          document.data["adventureUid"],
          document.documentID
      );
      inviteList.add(invite);
    });
    return inviteList;
  }

  //dispose all open sink
  void dispose() async {
    await _username.drain();
    _username.close();
  }

  static Bloc instance() => AddUserBloc();
}
