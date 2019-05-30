// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bloc_provider.dart';

// **************************************************************************
// BlocProviderGenerator
// **************************************************************************

class $Provider extends Provider {
  static T of<T extends Bloc>() {
    switch (T) {
      case LoginBloc:
        {
          return BlocCache.getBlocInstance(
              "LoginBloc", () => LoginBloc.instance());
        }
      case SignUpBloc:
        {
          return BlocCache.getBlocInstance(
              "SignUpBloc", () => SignUpBloc.instance());
        }
      case RegisterAdventureBloc:
        {
          return BlocCache.getBlocInstance(
              "RegisterAdventureBloc", () => RegisterAdventureBloc.instance());
        }
      case AdventuresBloc:
        {
          return BlocCache.getBlocInstance(
              "AdventuresBloc", () => AdventuresBloc.instance());
        }
      case CreateSessionBloc:
        {
          return BlocCache.getBlocInstance(
              "CreateSessionBloc", () => CreateSessionBloc.instance());
        }
    }
    return null;
  }

  static void dispose<T extends Bloc>() {
    switch (T) {
      case LoginBloc:
        {
          BlocCache.dispose("LoginBloc");
          break;
        }
      case SignUpBloc:
        {
          BlocCache.dispose("SignUpBloc");
          break;
        }
      case RegisterAdventureBloc:
        {
          BlocCache.dispose("RegisterAdventureBloc");
          break;
        }
      case AdventuresBloc:
        {
          BlocCache.dispose("AdventuresBloc");
          break;
        }
      case CreateSessionBloc:
        {
          BlocCache.dispose("CreateSessionBloc");
          break;
        }
    }
  }
}
