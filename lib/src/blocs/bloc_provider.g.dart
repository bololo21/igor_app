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
      case IndexAdventureBloc:
        {
          return BlocCache.getBlocInstance(
              "IndexAdventureBloc", () => IndexAdventureBloc.instance());
        }
      case ViewAdventureBloc:
        {
          return BlocCache.getBlocInstance(
              "ViewAdventureBloc", () => ViewAdventureBloc.instance());
        }
      case AddUserBloc:
        {
          return BlocCache.getBlocInstance(
              "AddUserBloc", () => AddUserBloc.instance());
        }
      case CreateSessionBloc:
        {
          return BlocCache.getBlocInstance(
              "CreateSessionBloc", () => CreateSessionBloc.instance());
        }
      case SessionsBloc:
        {
          return BlocCache.getBlocInstance(
              "SessionsBloc", () => SessionsBloc.instance());
        }
      case AddCharacterBloc:
        {
          return BlocCache.getBlocInstance(
              "AddCharacterBloc", () => AddCharacterBloc.instance());
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
      case IndexAdventureBloc:
        {
          BlocCache.dispose("IndexAdventureBloc");
          break;
        }
      case ViewAdventureBloc:
        {
          BlocCache.dispose("ViewAdventureBloc");
          break;
        }
      case AddUserBloc:
        {
          BlocCache.dispose("AddUserBloc");
          break;
        }
      case CreateSessionBloc:
        {
          BlocCache.dispose("CreateSessionBloc");
          break;
        }
      case SessionsBloc:
        {
          BlocCache.dispose("SessionsBloc");
          break;
        }
      case AddCharacterBloc:
        {
          BlocCache.dispose("AddCharacterBloc");
          break;
        }
    }
  }
}
