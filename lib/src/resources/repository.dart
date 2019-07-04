import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:igor_app/src/models/player.dart';
import 'package:igor_app/src/models/user.dart';

import 'package:igor_app/src/resources/firestore_provider.dart';
import 'package:igor_app/src/resources/firebaseauth_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();
  final _firebaseAuthProvider = FirebaseAuthProvider();

  //users
  Future<FirebaseUser> authenticateUser(String email, String password) {
    Future<FirebaseUser> user = _firebaseAuthProvider.authenticateUser(email, password);
    user.then((u) => _firestoreProvider.saveDeviceToken());
    return user;
  }

  Future<void> registerUser(String email, String password, String username,
      String date, String gender) async {
    FirebaseUser user = await _firebaseAuthProvider.signUpUser(
        email, password, username, date, gender);
    return _firestoreProvider.registerUserData(
        user.uid, username, date, gender);
  }

  Future<void> logout() => _firebaseAuthProvider.logout();

  Stream<QuerySnapshot> getUsersData() => _firestoreProvider.getUsersData();

  Stream<DocumentSnapshot> getUserData(String userUid) =>
      _firestoreProvider.getUserData(userUid);

  Stream<DocumentSnapshot> getCharacterData(
          String adventureUid, String userid) =>
      _firestoreProvider.getCharacterData(adventureUid, userid);

  Stream<QuerySnapshot> getUsersInAdventure(String adventureUid) =>
      _firestoreProvider.getUsersInAdventure(adventureUid);

  Stream<QuerySnapshot> getInvitedUsers(String adventureUid) =>
      _firestoreProvider.getInvitedUsers(adventureUid);

  Future<void> addUserToAdventure(User user, String adventureUid, User master) {
    _firestoreProvider.addUserToAdventure(user, adventureUid);
    return _firestoreProvider.sendNotification(title: "Novo jogador na aventura :)", body: "${user.username} aceitou seu convite para entrar na sua aventura!", deviceTarget: master.token);
  }

  Future<void> inviteUser(User user, String adventureUid) {
    _firestoreProvider.inviteUser(user, adventureUid);
    return _firestoreProvider.sendNotification(title: "Você tem um novo convite de aventura :)", body: "Entre na área de convites da sua conta para aceitar ou recusar!", deviceTarget: user.token);
  }

  Future<void> addCharacterToAdventure(
          String userUid,
          String adventureUid,
          String characterName,
          String characterClass,
          String characterRace,
          String attack,
          String defense,
          String life,
          String avatar) =>
      _firestoreProvider.addCharacterToAdventure(
          userUid,
          adventureUid,
          characterName,
          characterClass,
          characterRace,
          attack,
          defense,
          life,
          avatar);

  //adventures

  Future<void> registerAdventure(
          String userUid,
          String masterUsername,
          String adventureName,
          String adventureDate,
          String description,
          String imagePath) =>
      _firestoreProvider.registerAdventureData(userUid, masterUsername,
          adventureName, adventureDate, description, imagePath);

  Future<void> createSession(
          String adventureUid, String sessionName, DateTime sessionDate) =>
      _firestoreProvider.createSessionData(
          adventureUid, sessionName, sessionDate);

  Stream<QuerySnapshot> myMasterAdventures(String userUid) =>
      _firestoreProvider.myMasterAdventures(userUid);

  Stream<QuerySnapshot> myPlayerAdventures(String userUid) =>
      _firestoreProvider.myPlayerAdventures(userUid);

  Stream<DocumentSnapshot> getAdventureData(String adventureUid) =>
      _firestoreProvider.getAdventureData(adventureUid);

  Stream<QuerySnapshot> getSessions(String adventureUid) =>
      _firestoreProvider.getSessions(adventureUid);

  Stream<QuerySnapshot> getInvites(String userUid) =>
      _firestoreProvider.getInvites(userUid);

  deleteInvite(String inviteUid) => _firestoreProvider.deleteInvite(inviteUid);

  deleteSession(String sessionUid) =>
      _firestoreProvider.deleteSession(sessionUid);

  deleteAdventure(String adventureUid) =>
      _firestoreProvider.deleteAdventure(adventureUid);

  Future<void> insertIntoSessionLog(
          String sessionUid, int diceValue, String playerName, String dice) =>
      _firestoreProvider.insertIntoSessionLog(
          sessionUid, diceValue, playerName, dice);

  Stream<DocumentSnapshot> getCurrentUserPlayer(
          String userUid, String adventureUid) =>
      _firestoreProvider.getCurrentUserPlayer(userUid, adventureUid);

  Stream<QuerySnapshot> getSessionLog(String sessionUid) {
    return _firestoreProvider.getSessionLog(sessionUid);
  }

  Future<void> updateAdventure(String adventureUid, String adventureName,
      String description, String imagePath) {
    return _firestoreProvider.updateAdventure(
        adventureUid, adventureName, description, imagePath);
  }

  Future<void> updateSession(String sessionUid, String sessionName, DateTime sessionDate) {
    return _firestoreProvider.updateSession(
        sessionUid, sessionName, sessionDate);
  }

  Future<void> leaveAdventure(Player player, String adventureUid, String userToken) {
    return _firestoreProvider.leaveAdventure(player.id, adventureUid);
    //return _firestoreProvider.sendNotification(title: "Ops...", body: "O mestre te removeu da aventura :(", deviceTarget: userToken);
  }

  Stream<QuerySnapshot> getNextSessions(String adventureUid) =>
      _firestoreProvider.getNextSessions(adventureUid);

}
