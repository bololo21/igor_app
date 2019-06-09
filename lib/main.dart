import 'package:flutter/material.dart';
import 'package:igor_app/src/screens/log_in.dart';
import 'package:igor_app/src/screens/sessions.dart';
import 'package:igor_app/src/screens/sign_up.dart';
import 'src/screens/create_session.dart';
import 'src/screens/index_adventure.dart';
import 'src/screens/register_adventure.dart';
import 'src/screens/sessions.dart';

void main() {
  runApp(MyApp());
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
        primarySwatch: Colors.deepPurple,
        primaryColor: const Color(0xff221233)
      ),
      routes:  {
        '/': (context) => LogInScreen(),
        '/log_in': (context) => LogInScreen(),
        '/sign_up': (context) => SignUpScreen(),
        '/register_adventure': (context) => RegisterAdventureScreen(),
        '/index_adventure': (context) => IndexAdventureScreen(),
        '/create_session': (context) => RegisterSessionScreen(adventureUid: null,),
        '/sessions': (context) => SessionsScreen(adventureUid: null,)
      },
    );
  }
}
