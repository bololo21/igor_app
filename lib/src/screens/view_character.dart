import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:igor_app/src/blocs/bloc_provider.dart';
import 'package:igor_app/src/blocs/view_character_bloc.dart';
import 'package:igor_app/src/models/player.dart';
import '../../app_config.dart';
import 'app_bar.dart';

class ViewCharacterScreen extends StatefulWidget {
  final String userUid;
  final String adventureUid;
  const ViewCharacterScreen(
      {Key key, @required this.userUid, this.adventureUid})
      : super(key: key);

  @override
  _ViewCharacterScreenState createState() => _ViewCharacterScreenState();
}

class _ViewCharacterScreenState extends State<ViewCharacterScreen> {
  final _bloc = $Provider.of<ViewCharacterBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IgorAppBar(),
      drawer: IgorDrawer(context),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, currentUser) {
            if (currentUser.hasData) {
              return StreamBuilder(
                stream:
                    _bloc.getCharacterData(widget.adventureUid, widget.userUid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Player player = _bloc.mapToPlayer(snapshot.data);
                    return showCharacterData(player);
                  } else {
                    return Text("Carregando...",
                        style: TextStyle(
                            fontFamily: 'Fira-sans',
                            color: const Color(0xffe2e2e1)));
                  }
                },
              );
            } else
              return Text("");
          },
        ),
      ),
    );
  }

  Widget showCharacterData(Player player) {
    return Stack(children: <Widget>[
      Container(
        color: appConfig.themeColor,
      ),
      Container(
        padding: EdgeInsets.all(30),
        child: Container(
          height: 100 * appConfig.blockSizeVertical,
          width: 100 * appConfig.blockSize,
          padding: EdgeInsets.all(40),
          decoration: new BoxDecoration(
              color: const Color(0xffe2e2e1),
              borderRadius: new BorderRadius.all(Radius.circular(7.0))),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    height: 5 * appConfig.blockSizeVertical,
                    width: 5 * appConfig.blockSizeVertical,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new ExactAssetImage(
                                'assets/players/${player.avatar}.webp')))),
                SizedBox(height: 1 * appConfig.blockSizeVertical),
                Container(
                  child: Text(
                    "${player.characterName}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 4 * appConfig.blockSizeVertical),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Raça",
                      style: TextStyle(color: appConfig.themeColor, fontSize: 18),
                    ),
                    Text(
                      "${player.characterRace}",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 1 * appConfig.blockSizeVertical),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Classe",
                      style: TextStyle(color: appConfig.themeColor, fontSize: 18),
                    ),
                    Text(
                      "${player.characterClass}",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 1 * appConfig.blockSizeVertical),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Ataque",
                      style: TextStyle(color: appConfig.themeColor, fontSize: 18),
                    ),
                    Text(
                      "${player.attack}",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 1 * appConfig.blockSizeVertical),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Defesa",
                      style: TextStyle(color: appConfig.themeColor, fontSize: 18),
                    ),
                    Text(
                      "${player.defense}",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 1 * appConfig.blockSizeVertical),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Vida",
                      style: TextStyle(color: appConfig.themeColor, fontSize: 18),
                    ),
                    Text(
                      "${player.life}",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned(
    child: IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
    top: 40,
    left: 40,
    )
    ]);
  }
}
