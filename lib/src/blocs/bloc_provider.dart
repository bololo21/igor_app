import 'package:dash/dash.dart';
import 'adventures_bloc.dart';
import 'sign_up_bloc.dart';
import 'login_bloc.dart';
import 'register_adventure_bloc.dart';

part 'bloc_provider.g.dart';

// lembrar de colocar todos os novos blocs neste arquivo e rodar o seguinte comando no cmd (na pasta do projeto):
// flutter packages pub run build_runner build
@BlocProvider.register(LoginBloc)
@BlocProvider.register(SignUpBloc)
@BlocProvider.register(RegisterAdventureBloc)
@BlocProvider.register(AdventuresBloc)
abstract class Provider {}