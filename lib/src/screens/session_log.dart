import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d20/d20.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:igor_app/app_config.dart';
import 'package:igor_app/src/blocs/bloc_provider.dart';
import 'package:igor_app/src/blocs/session_log_bloc.dart';
import 'package:igor_app/src/models/log.dart';
import 'package:igor_app/src/models/player.dart';

class SessionLogScreen extends StatefulWidget {
  final String sessionUid;
  final String adventureUid;
  const SessionLogScreen(
      {Key key, @required this.sessionUid, @required this.adventureUid})
      : super(key: key);

  @override
  _SessionLogScreenState createState() => _SessionLogScreenState();
}

class _SessionLogScreenState extends State<SessionLogScreen> {
  final _bloc = $Provider.of<SessionLogBloc>();
  D20 d20 = D20();
  int diceValue;
  Player currentPlayer;
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: returnButton(),
      body: Container(
        height: appConfig.blockSizeVertical * 100,
        width: appConfig.blockSize * 100,
        color: appConfig.themeColor,
        child: Center(
            child: Stack(children: <Widget>[
          Container(
            height: appConfig.blockSizeVertical * 80,
            width: appConfig.blockSize * 85,
            decoration: new BoxDecoration(
                color: const Color(0xffe2e2e1),
                borderRadius: new BorderRadius.all(Radius.circular(7.0))),
            child: StreamBuilder(
                stream: _bloc.getSessionLog(widget.sessionUid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> logs = snapshot.data.documents;
                    List<Log> logsList = _bloc.mapToLogList(docList: logs);
                    return Column(
                      children: <Widget>[
                        Container(
                            height: 10 * appConfig.blockSizeVertical,
                            padding: EdgeInsets.only(
                                top: 4 * appConfig.blockSizeVertical,
                                left: 7 * appConfig.blockSize,
                                right: 7 * appConfig.blockSize),
                            child: Text(
                              "Histórico de Jogadas",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  fontFamily: 'Fira-sans'),
                            )),
                        logsList.isNotEmpty
                            ? Container(
                                height: 70 * appConfig.blockSizeVertical,
                                padding: EdgeInsets.only(
                                    left: 7 * appConfig.blockSize,
                                    right: 7 * appConfig.blockSize,
                                    bottom: 4 * appConfig.blockSizeVertical),
                                child: buildList(logsList))
                            : Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                      "Aperte no botão para rodar o dado!"),
                                ),
                              ),
                      ],
                    );
                  } else
                    return Text("");
                }),
          ),
          Positioned(
            child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context)),
            top: 0,
            left: 0,
          )
        ])),
      ),
    );
  }

  Scrollbar buildList(List<Log> logsList) {
    return Scrollbar(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.separated(
            controller: _scrollController,
            separatorBuilder: (BuildContext context, int index) =>
                Divider(color: Colors.transparent, height: 3),
            itemCount: logsList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Text(
                  "${logsList[index].characterName} rodou ${logsList[index].diceValue.toString()}!",
                  style: TextStyle(fontFamily: 'Fira-sans'));
            }),
      ),
    );
  }

  Widget returnButton() {
    return Container(
      child: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            FirebaseUser currentUser = snapshot.data;
            return StreamBuilder(
              stream: _bloc.getCurrentUserPlayer(
                  currentUser.uid, widget.adventureUid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  currentPlayer = _bloc.mapToPlayer(snapshot.data);
                  return FloatingActionButton(
                      child: Image.asset('assets/adventures/espadas.webp',
                          height: 5 * appConfig.blockSizeVertical),
                      onPressed: () {
                        setState(() {
                          diceValue = d20.roll('1d20');
                        });
                        _bloc
                            .insertIntoSessionLog(widget.sessionUid, diceValue,
                                currentPlayer.characterName)
                            .then((log) => _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut));
                      });
                } else
                  return Text("");
              },
            );
          } else
            return Text("");
        },
      ),
    );
  }
}
