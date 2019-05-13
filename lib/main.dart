import 'package:flutter/material.dart';
import 'package:igor_app/app_config.dart';
import 'package:igor_app/screens/log_in.dart';
import 'package:igor_app/screens/sign_up.dart';
import 'package:igor_app/session.dart';
import 'package:observable_state/observable_state.dart';

void main() {
  final session = Session();
  runApp(
      ObservableProvider(
        state: session,
        child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: const Color(0xff221233)
      ),
      routes:  {

        '/': (context) => LogInScreen(),
        '/log_in': (context) => LogInScreen(),
        '/sign_up': (context) => SignUpScreen(),
      },
    );
  }
}
