import 'package:flutter/material.dart';
import 'dart:async';
import 'package:igor_app/app_config.dart';
import 'package:igor_app/src/blocs/bloc_provider.dart';
import 'package:igor_app/src/blocs/create_session_bloc.dart';
import 'package:igor_app/src/models/session.dart';
import 'package:igor_app/src/screens/view_adventure.dart';
import 'package:intl/intl.dart';

class RegisterSessionScreen extends StatefulWidget {
  final String adventureUid;
  final Session session;
  const RegisterSessionScreen({Key key, @required this.adventureUid, this.session}) : super(key: key);
  @override
  _RegisterSessionScreenState createState() => _RegisterSessionScreenState();
}

class _RegisterSessionScreenState extends State<RegisterSessionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _bloc = $Provider.of<CreateSessionBloc>();
  DateTime _dateButton = DateTime.now();
  TextEditingController _nameController = new TextEditingController();

  @override
  void initState() {
    if (widget.session != null) {
      _nameController.text = widget.session.name;
      _dateButton = widget.session.date;
    }
    super.initState();
  }

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
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            child: Icon(
                              Icons.close,
                              color: Colors.black12,
                            ),
                            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewAdventureScreen(adventureUid: widget.adventureUid))),
                          ),
                          SizedBox(width: 2 * appConfig.blockSize),
                          widget.session == null ?
                          Text(
                            "Criar Sessão",
                            style: TextStyle(color: appConfig.themeColor),
                          ):
                          Text(
                            "Editar Sessão",
                            style: TextStyle(color: appConfig.themeColor),
                          ),
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
                                stream: _bloc.sessionName,
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  return TextField(
                                    controller: _nameController,
                                    onChanged: _bloc.changeSessionName,
                                    decoration: InputDecoration(
                                        labelText:
                                            'De um nome à próxima sessão',
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontFamily: 'Fira-sans'),
                                        errorText: snapshot.error),
                                  );
                                }),
                          ],
                        ),
                      ),
                      SizedBox(height: 3 * appConfig.blockSizeVertical),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            MaterialButton(
                                child: Text(DateFormat('dd/MM').format(_dateButton)),
                                textColor: const Color(0xffe2e2e1),
                                color: appConfig.themeColor,
                                onPressed: () {
                                  _selectDate(context);
                                }),
                                MaterialButton(
                                child: Text("CRIAR"),
                                textColor: const Color(0xffe2e2e1),
                                color: appConfig.themeColor,
                                onPressed: () {
                                  if (widget.session == null) {
                                    if (_dateButton == DateTime.now())
                                      _bloc.changeDate(DateTime.now());
                                    _bloc.createSession(widget.adventureUid);
                                  }
                                  else {
                                    if (_dateButton == widget.session.date)
                                      _bloc.changeDate(widget.session.date);
                                    _bloc.changeSessionName(_nameController.text);
                                    _bloc.updateSession(widget.session.id);
                                  }
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewAdventureScreen(adventureUid: widget.adventureUid)));
                                })
                          ],
                        ),
                      ),
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
    $Provider.dispose<CreateSessionBloc>();
    super.dispose();
  }

  Future _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2018),
      lastDate: new DateTime(2020),
    );
    if (picked != null) {
      _bloc.changeDate(picked);
      setState(() {
        _dateButton = picked;
      });
    }
  }
}