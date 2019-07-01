import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:igor_app/src/models/user.dart';

import 'package:igor_app/src/resources/firestore_provider.dart';
import 'package:igor_app/src/resources/firebaseauth_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();
  final _firebaseAuthProvider = FirebaseAuthProvider();

  //users

  Future<FirebaseUser> authenticateUser(String email, String password) =>
      _firebaseAuthProvider.authenticateUser(email, password);

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

  Future<void> addUserToAdventure(User user, String adventureUid) =>
      _firestoreProvider.addUserToAdventure(user, adventureUid);

  Future<void> inviteUser(User user, String adventureUid) =>
      _firestoreProvider.inviteUser(user, adventureUid);

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
          String adventureUid, String sessionName, String sessionDate) =>
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

  deleteSession(String sessionUid) => _firestoreProvider.deleteSession(sessionUid);

  deleteAdventure(String adventureUid) => _firestoreProvider.deleteAdventure(adventureUid);

  Future<void> insertIntoSessionLog(
          String sessionUid, int diceValue, String playerName) =>
      _firestoreProvider.insertIntoSessionLog(sessionUid, diceValue, playerName);

  Stream<DocumentSnapshot> getCurrentUserPlayer(
          String userUid, String adventureUid) =>
      _firestoreProvider.getCurrentUserPlayer(userUid, adventureUid);

  Stream<QuerySnapshot> getSessionLog(String sessionUid) {
   return  _firestoreProvider.getSessionLog(sessionUid);
  }
}
