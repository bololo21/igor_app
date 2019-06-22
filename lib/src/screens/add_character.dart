import 'package:flutter/material.dart';
import 'package:igor_app/src/blocs/add_character_bloc.dart';
import 'package:igor_app/src/blocs/bloc_provider.dart';

import '../../app_config.dart';
import 'view_adventure.dart';

class AddCharacterScreen extends StatefulWidget {
  final String adventureUid;
  final String userUid;
  const AddCharacterScreen(
      {Key key, @required this.adventureUid, @required this.userUid})
      : super(key: key);

  @override
  _AddCharacterScreenState createState() => _AddCharacterScreenState();
}

class _AddCharacterScreenState extends State<AddCharacterScreen> {
  final _bloc = $Provider.of<AddCharacterBloc>();
  String _avatar;
  List<String> imagesList = ['p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7', 'p8'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          color: appConfig.themeColor,
        ),
        SingleChildScrollView(
          child: Center(
              child: Column(
            children: <Widget>[
              SizedBox(
                height: 10 * appConfig.blockSizeVertical,
              ),
              Container(
                decoration: new BoxDecoration(
                    color: const Color(0xffe2e2e1),
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(5.0),
                        topRight: const Radius.circular(5.0))),
                padding: EdgeInsets.fromLTRB(
                    2 * appConfig.blockSize,
                    1 * appConfig.blockSizeVertical,
                    2 * appConfig.blockSize,
                    2 * appConfig.blockSizeVertical),
                margin: EdgeInsets.fromLTRB(
                    2 * appConfig.blockSize, 0, 2 * appConfig.blockSize, 0),
                //color: const Color(0xffe2e2e1),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            child: Icon(Icons.close, color: Colors.black12),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewAdventureScreen(
                                        adventureUid: widget.adventureUid))),
                          ),
                          SizedBox(width: 2 * appConfig.blockSize),
                          Text("Criar Personagem",
                              style: TextStyle(color: appConfig.themeColor)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: Column(
                          children: <Widget>[
                            StreamBuilder(
                                stream: _bloc.characterName,
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  return TextField(
                                    onChanged: _bloc.changeCharacterName,
                                    decoration: InputDecoration(
                                        labelText: 'Nome do Personagem',
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontFamily: 'Fira-sans'),
                                        errorText: snapshot.error),
                                  );
                                }),
                            StreamBuilder(
                                stream: _bloc.characterClass,
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  return TextField(
                                    onChanged: _bloc.changeCharacterClass,
                                    decoration: InputDecoration(
                                        labelText: 'Classe do Personagem',
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontFamily: 'Fira-sans'),
                                        errorText: snapshot.error),
                                  );
                                }),
                            StreamBuilder(
                                stream: _bloc.characterRace,
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  return TextField(
                                    onChanged: _bloc.changeCharacterRace,
                                    decoration: InputDecoration(
                                        labelText: 'Raça do Personagem',
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontFamily: 'Fira-sans'),
                                        errorText: snapshot.error),
                                  );
                                }),
                            StreamBuilder(
                                stream: _bloc.attack,
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  return TextField(
                                    keyboardType: TextInputType.number,
                                    onChanged: _bloc.changeAttack,
                                    decoration: InputDecoration(
                                        labelText: 'Ataque do Personagem',
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontFamily: 'Fira-sans'),
                                        errorText: snapshot.error),
                                  );
                                }),
                            StreamBuilder(
                                stream: _bloc.defense,
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  return TextField(
                                    keyboardType: TextInputType.number,
                                    onChanged: _bloc.changeDefense,
                                    decoration: InputDecoration(
                                        labelText: 'Defesa do Personagem',
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontFamily: 'Fira-sans'),
                                        errorText: snapshot.error),
                                  );
                                }),
                            StreamBuilder(
                                stream: _bloc.life,
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  return TextField(
                                    keyboardType: TextInputType.number,
                                    onChanged: _bloc.changeLife,
                                    decoration: InputDecoration(
                                        labelText: 'Vida do Personagem',
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontFamily: 'Fira-sans'),
                                        errorText: snapshot.error),
                                  );
                                }),
                            StreamBuilder(
                                stream: _bloc.avatar,
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  return Container(
                                    width: 50 * appConfig.blockSize,
                                    child: new FormField(
                                      builder: (FormFieldState state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
                                            labelText: 'Avatar do Personagem',
                                          ),
                                          isEmpty: _avatar == '',
                                          child: new DropdownButtonHideUnderline(
                                              child: ButtonTheme(
                                                alignedDropdown: true,
                                                  child: new DropdownButton(
                                                      value: _avatar,
                                                      isDense: true,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _avatar = value;
                                                        });
                                                        _bloc.changeAvatar(value);
                                                      },
                                                      items: imagesList
                                                          .map((String val) {
                                                        return DropdownMenuItem(
                                                            value: val,
                                                            child: Center(
                                                              child: Container(
                                                                  height: 5 *
                                                                      appConfig
                                                                          .blockSizeVertical,
                                                                  width: 5 *
                                                                      appConfig
                                                                          .blockSizeVertical,
                                                                  decoration: new BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      image: new DecorationImage(
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          image: new ExactAssetImage(
                                                                              'assets/players/$val.webp')))),
                                                            )

                                                        );
                                                      }).toList()),

                                              )),
                                        );
                                      },
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                      SizedBox(height: 2 * appConfig.blockSizeVertical),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            MaterialButton(
                                child: Text("PRONTO"),
                                textColor: const Color(0xffe2e2e1),
                                color: appConfig.themeColor,
                                onPressed: () {
                                  _bloc.addCharacterToAdventure(
                                      widget.userUid, widget.adventureUid);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ViewAdventureScreen(
                                                  adventureUid:
                                                      widget.adventureUid)));
                                })
                          ],
                        ),
                      ),
                      SizedBox(height: 59 * appConfig.blockSizeVertical),
                    ],
                  ),
                ),
              ),
            ],
          )),
        )
      ],
    ));
  }

  @override
  void dispose() {
    $Provider.dispose<AddCharacterBloc>();
    super.dispose();
  }

}
