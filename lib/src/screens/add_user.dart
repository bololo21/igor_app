import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:igor_app/src/blocs/add_user_bloc.dart';
import 'package:igor_app/src/blocs/bloc_provider.dart';
import 'package:igor_app/src/models/invite.dart';
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
  List<Invite> invitesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: _bloc.getUsersData(),
      builder: (context, usersSnapshot) {
        if (usersSnapshot.hasData) {
          List<DocumentSnapshot> usersDocs = usersSnapshot.data.documents;
          usersList = _bloc.mapToList(docList: usersDocs);
          if (usersList.isNotEmpty) {
            return StreamBuilder(
              stream: _bloc.getUsersInAdventure(widget.adventureUid),
              builder: (context, usersInAdventureSnapshot) {
                if (usersInAdventureSnapshot.hasData) {
                  List<DocumentSnapshot> usersInAdventureDocs =
                      usersInAdventureSnapshot.data.documents;
                  usersInAdventureList =
                      _bloc.mapToList(docList: usersInAdventureDocs);
                  return StreamBuilder(
                    stream: _bloc.getInvitedUsers(widget.adventureUid),
                    builder: (context, invitedUsersSnapshot) {
                      if (invitedUsersSnapshot.hasData) {
                        List<DocumentSnapshot> invitedUsersDocs =
                            invitedUsersSnapshot.data.documents;
                        invitesList =
                            _bloc.mapToInviteList(docList: invitedUsersDocs);

                        return buildList(usersList);
                      }
                      else {
                        return Text("Carregando...");
                      }
                    },
                  );
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
      Container(color: appConfig.themeColor),
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
                                  child: (usersInAdventureList.any((userIn) =>
                                              user.id == userIn.id) ||
                                          invitesList.any((invite) =>
                                              user.id == invite.userUid))
                                      ? Text(user.username,
                                          style:
                                              TextStyle(color: Colors.black12))
                                      : Text(user.username),
                                ),
                                onTap: () {
                                  if (usersInAdventureList
                                      .any((userIn) => user.id == userIn.id))
                                    Toast.show(
                                        "Este jogador já foi adicionado!",
                                        context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM);
                                  else if (invitesList.any((invite) =>
                                  user.id == invite.userUid)) {
                                    Toast.show("Este jogador já foi convidado!",
                                        context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM);
                                  } else {
                                    _bloc.inviteUser(user, widget.adventureUid);
                                    Toast.show("Jogador convidado!", context,
                                        duration: Toast.LENGTH_SHORT,
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
}
