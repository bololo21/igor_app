import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  //adventures

  Future<void> registerAdventure(String userUid, String adventureName, String adventureDate, String description) =>
      _firestoreProvider.registerAdventureData(userUid, adventureName, adventureDate, description);

  Future<void> registerPlayerData(String adventureUid, String playerUid) =>
      _firestoreProvider.registerPlayerData(adventureUid, playerUid);

  Stream<QuerySnapshot> myAdventures(String userUid) =>
      _firestoreProvider.myAdventures(userUid);

}