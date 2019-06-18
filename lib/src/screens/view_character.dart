import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:igor_app/src/blocs/bloc_provider.dart';
import 'package:igor_app/src/blocs/view_adventure_bloc.dart';
import 'package:igor_app/src/models/adventure.dart';
import 'package:igor_app/src/models/player.dart';
import 'package:igor_app/src/models/session.dart';
import 'package:igor_app/src/screens/add_user.dart';
import 'package:igor_app/src/screens/create_session.dart';
import '../../app_config.dart';
import 'add_character.dart';
import 'app_bar.dart';

class ViewCharacterScreen extends StatefulWidget {
  final String userid;
  const ViewCharacterScreen({Key key, @required this.userid})
      : super(key: key);

  @override
  _ViewCharacterScreenState createState() => _ViewCharacterScreenState();
}

class _ViewCharacterScreenState extends State<ViewCharacterScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}