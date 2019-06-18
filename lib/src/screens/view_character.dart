import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:igor_app/src/blocs/bloc_provider.dart';
import 'package:igor_app/src/blocs/view_character_bloc.dart';
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
  final String adventureUid;
  const ViewCharacterScreen({Key key, @required this.userid, this.adventureUid})
      : super(key: key);

  @override
  _ViewCharacterScreenState createState() => _ViewCharacterScreenState();
}

class _ViewCharacterScreenState extends State<ViewCharacterScreen> {
    final _bloc = $Provider.of<ViewCharacterBloc>();
  @override
@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IgorAppBar(),
        drawer: IgorDrawer(context),
        floatingActionButton: Container(
        height: 70 * appConfig.blockSizeVertical,
        width: 90 * appConfig.blockSize,
          child: StreamBuilder(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (context, currentUser) {
              if (currentUser.hasData) {
                return StreamBuilder(
                    stream: _bloc.getCharacterData(widget.adventureUid, widget.userid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Player player =
                            _bloc.mapToPlayer(snapshot.data);
                        return showCharacterData(player);
                      } else {
                        return Text("Carregando...",
                            style: TextStyle(
                                fontFamily: 'Fira-sans', color: const Color(0xffe2e2e1)));
                      }
                    },);
              } else
                return Text("");
            },
          ),
        ),
  );
  }


   Widget showCharacterData(Player player) {
    return Container(
        height: 20 * appConfig.blockSizeVertical,
        width: 100 * appConfig.blockSize,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Text(
                "${player.characterName}",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              top: 10 * appConfig.blockSizeVertical,
              left: 15 * appConfig.blockSize,
            ),
            // Positioned(
            //   child: Text(
            //     "${player.characterRace}",
            //     style: TextStyle(color: Colors.white, fontSize: 22),
            //   ),
            //   top: 4 * appConfig.blockSizeVertical,
            //   left: 15 * appConfig.blockSize,
            // ),
            //             Positioned(
            //   child: Text(
            //     "${player.characterClass}",
            //     style: TextStyle(color: Colors.white, fontSize: 22),
            //   ),
            //   top: 4 * appConfig.blockSizeVertical,
            //   left: 15 * appConfig.blockSize,
            // ),
            //             Positioned(
            //   child: Text(
            //     "${player.attack}",
            //     style: TextStyle(color: Colors.white, fontSize: 22),
            //   ),
            //   top: 4 * appConfig.blockSizeVertical,
            //   left: 15 * appConfig.blockSize,
            // ),
            //             Positioned(
            //   child: Text(
            //     "${player.defense}",
            //     style: TextStyle(color: Colors.white, fontSize: 22),
            //   ),
            //   top: 4 * appConfig.blockSizeVertical,
            //   left: 15 * appConfig.blockSize,
            // ),
            //             Positioned(
            //   child: Text(
            //     "${player.life}",
            //     style: TextStyle(color: Colors.white, fontSize: 22),
            //   ),
            //   top: 4 * appConfig.blockSizeVertical,
            //   left: 15 * appConfig.blockSize,
            // ),

          ],
        ));
  }

    Color pickColor(Adventure adventure) {
    if (adventure.imagePath == 'Coast') {
      return const Color(0xfff9a073);
    } else if (adventure.imagePath == 'Corvali') {
      return const Color(0xff0f857e);
    } else if (adventure.imagePath == 'Heartlands') {
      return const Color(0xff1a3f51);
    } else if (adventure.imagePath == 'Krevast') {
      return const Color(0xff6c203e);
    } else {
      return const Color(0xff1e2843);
    }
  }
}