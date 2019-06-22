import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash/dash.dart';
import 'package:igor_app/src/models/adventure.dart';
import 'package:igor_app/src/models/invite.dart';
import 'package:igor_app/src/models/user.dart';
import '../resources/repository.dart';

class InvitesBloc extends Bloc {
  final _repository = Repository();

  Stream<QuerySnapshot> getInvites(String userUid) {
    return _repository.getInvites(userUid);
  }

  Future<void> addUserToAdventure(User user, String adventureUid) {
    return _repository.addUserToAdventure(user, adventureUid);
  }

  List mapToInviteList({List<DocumentSnapshot> docList}) {
    List<Invite> inviteList = [];
    docList.forEach((document) {
      Invite invite = Invite(
          document.data["userUid"],
          document.data["adventureUid"],
          document.documentID,
      );
      inviteList.add(invite);
    });
    return inviteList;
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

  User mapToUser({DocumentSnapshot document}) {
    User user = User(
        document.documentID,
        document.data["username"]);
    return user;
  }

  Stream<DocumentSnapshot> getAdventureData(String adventureUid) {
    return _repository.getAdventureData(adventureUid);
  }

  Stream<DocumentSnapshot> getUserData(String userUid) {
    return _repository.getUserData(userUid);
  }

  deleteInvite(String inviteUid){
    return _repository.deleteInvite(inviteUid);
  }

  //dispose all open sink
  void dispose() async {
  }

  static Bloc instance() => InvitesBloc();

}