import 'package:dash/dash.dart';
import 'package:igor_app/src/blocs/add_user_bloc.dart';
import 'package:igor_app/src/blocs/view_character_bloc.dart';
import 'add_character_bloc.dart';
import 'index_adventure_bloc.dart';
import 'sign_up_bloc.dart';
import 'login_bloc.dart';
import 'register_adventure_bloc.dart';
import 'create_session_bloc.dart';
import 'view_adventure_bloc.dart';
import 'view_character_bloc.dart';
import 'sessions_bloc.dart';

part 'bloc_provider.g.dart';

// lembrar de colocar todos os novos blocs neste arquivo e rodar o seguinte comando no cmd (na pasta do projeto):
// flutter packages pub run build_runner build

@BlocProvider.register(LoginBloc)
@BlocProvider.register(SignUpBloc)
@BlocProvider.register(RegisterAdventureBloc)
@BlocProvider.register(IndexAdventureBloc)
@BlocProvider.register(ViewAdventureBloc)
@BlocProvider.register(AddUserBloc)
@BlocProvider.register(CreateSessionBloc)
@BlocProvider.register(SessionsBloc)
@BlocProvider.register(AddCharacterBloc)
@BlocProvider.register(ViewCharacterBloc)
abstract class Provider {}