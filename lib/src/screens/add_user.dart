import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:igor_app/src/blocs/add_user_bloc.dart';
import 'package:igor_app/src/blocs/bloc_provider.dart';
import 'package:igor_app/src/models/adventure.dart';
import 'package:igor_app/src/models/user.dart';
import 'package:igor_app/src/screens/view_adventure.dart';
import 'package:toast/toast.dart';

import '../../app_config.dart';

class AddUserScreen extends StatefulWidget {
  final String adventureUid;
  const AddUserScreen({Key key, @required this.adventureUid}) : super(key: key);

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _bloc = $Provider.of<AddUserBloc>();

  List<User> usersList = [];
  List<User> usersInAdventureList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: _bloc.getUsersData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> docs = snapshot.data.documents;
          usersList = _bloc.mapToList(docList: docs);
          if (usersList.isNotEmpty) {
            return StreamBuilder(
              stream: _bloc.getUsersInAdventure(widget.adventureUid),
              builder: (context, snapshot2) {
                if (snapshot2.hasData) {
                  List<DocumentSnapshot> docs2 = snapshot2.data.documents;
                  usersInAdventureList = _bloc.mapToList(docList: docs2);
                  return buildList(usersList);
                } else {
                  return Text("Carregando...");
                }
              },
            );
          } else {
            return Text("Nenhum usuário encontrado :(",
                style: TextStyle(
                    fontFamily: 'Fira-sans', color: const Color(0xffe2e2e1)));
          }
        } else {
          return Text("Carregando...",
              style: TextStyle(
                  fontFamily: 'Fira-sans', color: const Color(0xffe2e2e1)));
        }
      },
    ));
  }

  Widget buildList(List<User> userList) {
    return Stack(children: <Widget>[
      StreamBuilder(
        stream: _bloc.getAdventureData(widget.adventureUid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Adventure adventure = _bloc.mapToAdventure(document: snapshot.data);
            return Container(
              color: pickColor(adventure),
            );
          } else
            return Text("");
        },
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                    color: const Color(0xffe2e2e1),
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(5.0),
                        topRight: const Radius.circular(5.0))),
                width: 95 * appConfig.blockSize,
                height: 90 * appConfig.blockSizeVertical,
                child: new ListView(
                  children: usersList.map((User user) {
                    return Column(
                      children: <Widget>[

                        Container(
                          width: 100 * appConfig.blockSize,
                          height: 6 * appConfig.blockSizeVertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.transparent,
                                  height: 6 * appConfig.blockSizeVertical,
                                  width: 100 * appConfig.blockSize,
                                  child: (usersInAdventureList
                                      .any((userIn) => user.id == userIn.id)) ?
                                  Text(user.username, style: TextStyle(color: Colors.black12))
                                  :
                                  Text(user.username),
                                ),
                                onTap: () {
                                  if (usersInAdventureList
                                      .any((userIn) => user.id == userIn.id))
                                    Toast.show(
                                        "Este jogador já foi adicionado!",
                                        context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                  else {
                                    _bloc.addUserToAdventure(
                                        user, widget.adventureUid);
                                    Toast.show("Jogador adicionado!", context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Colors.black12),

                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
      Positioned(
        top: 11 * appConfig.blockSizeVertical,
        left: 5 * appConfig.blockSize,
        child: Row(
          children: <Widget>[
            GestureDetector(
              child: Icon(
                Icons.close,
                color: Colors.black12,
              ),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewAdventureScreen(
                          adventureUid: widget.adventureUid))),
            ),
            SizedBox(width: 20 * appConfig.blockSize),
            Text("ADICIONAR USUÁRIOS",
                style: TextStyle(
                    fontFamily: 'Fira-sans', fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    $Provider.dispose<AddUserBloc>();
    super.dispose();
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
