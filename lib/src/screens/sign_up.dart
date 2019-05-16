import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:igor_app/app_config.dart';
import 'package:igor_app/session.dart';
import 'package:igor_app/src/blocs/bloc_provider.dart';
import 'package:igor_app/src/blocs/sign_up_bloc.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

TextEditingController dateController = new TextEditingController();
TextEditingController emailController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();
TextEditingController usernameController = new TextEditingController();
TextEditingController genderController = new TextEditingController();

class _SignUpScreenState extends State<SignUpScreen> {
  String _email, _password, _username, _date, _gender;
  bool x = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _bloc = $Provider.of<SignUpBloc>();

  @override
  Widget build(BuildContext context) {
    appConfig.setConfig(context);
    return Scaffold(
        body: Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/log_in/Backgrownd.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Center(
              child: Column(
            children: <Widget>[
              SizedBox(
                height: 12 * appConfig.blockSizeVertical,
              ),
              Image(
                image: AssetImage('assets/log_in/Igor.png'),
                width: 50 * appConfig.blockSize,
              ),
              SizedBox(
                height: 8 * appConfig.blockSizeVertical,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 4 * appConfig.blockSizeVertical,
                    0, 2 * appConfig.blockSizeVertical),
                margin: EdgeInsets.fromLTRB(
                    10 * appConfig.blockSize, 0, 10 * appConfig.blockSize, 0),
                color: const Color(0xffe2e2e1),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: Column(
                          children: <Widget>[
                            StreamBuilder(
                                stream: _bloc.email,
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  return TextField(
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: _bloc.changeEmail,
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          Icons.error,
                                          color: Colors.greenAccent,
                                        ),
                                        labelText: 'E-mail',
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontFamily: 'Fira-sans'),
                                        errorText: snapshot.error),
                                  );
                                }),
                            StreamBuilder(
                                stream: _bloc.password,
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  return TextField(
                                    obscureText: true,
                                    onChanged: _bloc.changePassword,
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          Icons.error,
                                          color: Colors.greenAccent,
                                        ),
                                        labelText: 'Senha',
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontFamily: 'Fira-sans'),
                                        errorText: snapshot.error),
                                  );
                                }),
                            StreamBuilder(
                                stream: _bloc.username,
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  return TextField(
                                    onChanged: _bloc.changeUsername,
                                    decoration: InputDecoration(
                                        labelText: 'Nome de usuário',
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontFamily: 'Fira-sans')),
                                  );
                                }),
                            InkWell(
                              onTap: () {
                                _selectDate(); // Call Function that has showDatePicker()
                              },
                              child: IgnorePointer(
                                  child: StreamBuilder(
                                      stream: _bloc.date,
                                      builder: (context,
                                          AsyncSnapshot<String> snapshot) {
                                        return TextField(
                                          controller: dateController,
                                          onChanged: _bloc.changeDate(_date),
                                          decoration: InputDecoration(
                                              labelText: 'Data de nascimento',
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontFamily: 'Fira-sans')),
                                        );
                                      })),
                            ),
                            StreamBuilder(
                                stream: _bloc.gender,
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  return new FormField(
                                    builder: (FormFieldState state) {
                                      return InputDecorator(
                                        decoration: InputDecoration(
                                          labelText: 'Sexo',
                                        ),
                                        isEmpty: _gender == '',
                                        child: new DropdownButtonHideUnderline(
                                          child: new DropdownButton(
                                            value: _gender,
                                            isDense: true,
                                            onChanged: (value){
                                              setState(() {
                                                _gender = value;
                                              });
                                              _bloc.changeGender(value);
                                            },
                                            items: <String>[
                                              'Masculino',
                                              'Feminino',
                                              'Outro'
                                            ].map((String value) {
                                              return new DropdownMenuItem(
                                                value: value,
                                                child: new Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),

                            /*    TextFormField(
                              onSaved: (input) => _gender = input,
                              decoration: InputDecoration(
                                  labelText: 'Sexo',
                                  labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontFamily: 'Fira-sans')),
                            ),*/
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
                                child: Text("CRIAR"),
                                textColor: const Color(0xff221233),
                                color: Colors.greenAccent,
                                onPressed: () {
                                  _bloc.signUp();
                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /*FutureBuilder(
                future: FirebaseAuth.instance.currentUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return Text("${snapshot.data}");
                  else
                    return Text("nada");
                },
              ),*/
            ],
          )),
        )
      ],
    ));
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1930),
        lastDate: new DateTime.now());
    if (picked != null) {
      setState(() => _date = picked.day.toString() +
          '/' +
          picked.month.toString() +
          '/' +
          picked.year.toString());
      dateController.text = _date;

    }
  }
}
