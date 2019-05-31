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

  Future<void> registerUser(String email, String password, String username, String date, String gender) async {
    FirebaseUser user = await _firebaseAuthProvider.signUpUser(email, password, username, date, gender);
    return _firestoreProvider.registerUserData(user.uid, username, date, gender);
  }

  Future<void> logout() =>
      _firebaseAuthProvider.logout();

  //adventures

  Future<void> registerAdventure(String userUid, String masterUsername, String adventureName, String adventureDate, String description, String imagePath) =>
      _firestoreProvider.registerAdventureData(userUid, masterUsername, adventureName, adventureDate, description, imagePath);

  Future<void> createSession(String adventureUid, String sessionName, String sessionDate) =>
      _firestoreProvider.createSessionData(adventureUid, sessionName, sessionDate);

  Future<void> registerPlayerData(String adventureUid, String playerUid) =>
      _firestoreProvider.registerPlayerData(adventureUid, playerUid);

  Stream<QuerySnapshot> myAdventures(String userUid) =>
      _firestoreProvider.myAdventures(userUid);

  Stream<DocumentSnapshot> getAdventureData(String adventureUid) =>
      _firestoreProvider.getAdventureData(adventureUid);

  Stream<QuerySnapshot> getUsersData() =>
      _firestoreProvider.getUsersData();

  Stream<DocumentSnapshot> getUserData(String userUid) => _firestoreProvider.getUserData(userUid);

  Stream<QuerySnapshot> getUsersInAdventure(String adventureUid) =>
      _firestoreProvider.getUsersInAdventure(adventureUid);

  Future<void> addUserToAdventure(User user, String adventureUid) =>
      _firestoreProvider.addUserToAdventure(user, adventureUid);

}