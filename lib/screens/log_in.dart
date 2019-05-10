import 'package:flutter/material.dart';
import 'package:igor_app/app_config.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  String _email, _password;
  bool x = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    appConfig.setConfig(context);
    return Scaffold(
        body: Stack(
      children: <Widget>[
        new Container(
          // configuração de background image
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
              GestureDetector(
                onTap: () => print('Pega no gooogle ${appConfig.height}'),
                child: Image(
                  image: AssetImage('assets/log_in/Google.png'),
                  width: 50 * appConfig.blockSize,
                ),
              ),
              SizedBox(
                height: 2 * appConfig.blockSizeVertical,
              ),
              Text(
                "OU",
                style: TextStyle(color: const Color(0xffe2e2e1)),
              ),
              Form(
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
                          TextFormField(
                            cursorColor: const Color(0xffe2e2e1),
                            keyboardType: TextInputType.emailAddress,
                            validator: (input) {
                              if (input.isEmpty)
                                return "E-mail não deve ser vazio.";
                            },
                            onSaved: (input) => _email = input,
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: const Color(0xffe2e2e1))),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: const Color(0xffe2e2e1))),
                                suffixIcon: Icon(
                                  Icons.error,
                                  color: Colors.greenAccent,
                                ),
                                labelText: 'E-mail',
                                labelStyle: TextStyle(
                                    color: const Color(0xffe2e2e1),
                                    fontSize: 22,
                                    fontFamily: 'Fira-sans')),
                          ),
                          TextFormField(
                            cursorColor: const Color(0xffe2e2e1),
                            validator: (input) {
                              if (input.isEmpty)
                                return "Senha não deve ser vazia";
                            },
                            onSaved: (input) => _password = input,
                            obscureText: true,
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: const Color(0xffe2e2e1))),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: const Color(0xffe2e2e1))),
                                suffixIcon: Icon(
                                  Icons.error,
                                  color: Colors.greenAccent,
                                ),
                                labelText: 'Senha',
                                labelStyle: TextStyle(
                                    color: const Color(0xffe2e2e1),
                                    fontSize: 22,
                                    fontFamily: 'Fira-sans')),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2 * appConfig.blockSizeVertical),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 5.0,
                        right: 5.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            checkColor: Colors.greenAccent,
                            activeColor: Colors.transparent,
                            value: x,
                            tristate: false,
                            onChanged: (value) {
                              setState(() {
                                x = value;
                              });
                            },
                          ),
                          Text(
                            "manter-me conectado",
                            style: TextStyle(
                                color: const Color(0xffe2e2e1),
                                fontFamily: 'Fira-sans'),
                          ),
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
                            child: Text("ENTRAR"),
                            textColor: const Color(0xff221233),
                            color: Colors.greenAccent,
                            onPressed: () => print("asda"),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: FlatButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Text("criar conta"),
                      textColor: const Color(0xff00e2ba),
                      onPressed: () => print("ad"),
                    ),
                  ),
                  Container(
                    child: FlatButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Text("esqueci minha senha"),
                      textColor: const Color(0xffe2e2e1),
                      onPressed: () => print("ad"),
                    ),
                  ),
                ],
              )
            ],
          )),
        )
      ],
    ));
  }
}
