import 'package:flutter/material.dart';
import 'package:igor_app/app_config.dart';
import 'package:igor_app/src/blocs/bloc_provider.dart';
import 'package:igor_app/src/blocs/create_session_bloc.dart';

class RegisterSessionScreen extends StatefulWidget {
  @override
  _RegisterSessionScreenState createState() => _RegisterSessionScreenState();
}

class _RegisterSessionScreenState extends State<RegisterSessionScreen> {
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //final _bloc = $Provider.of<CreateSessionBloc>();

  @override
  Widget build(BuildContext context) {
    appConfig.setConfig(context);
    return Scaffold(
        floatingActionButton: Container(
          width: 17 * appConfig.blockSize,
          height: 17 * appConfig.blockSize,
          child: FloatingActionButton(
            child: Image.asset('assets/adventures/Botão_Criar_Nova_Aventura.png'),
            onPressed: () => Navigator.pushNamed(context, '/register_adventure'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        )
);
  }
  @override
  void dispose() {
    $Provider.dispose<CreateSessionBloc>();
    super.dispose();
  }
}
