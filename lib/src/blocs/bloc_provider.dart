import 'package:dash/dash.dart';
import 'package:igor_app/src/blocs/sign_up_bloc.dart';
import 'login_bloc.dart';

part 'bloc_provider.g.dart';

@BlocProvider.register(LoginBloc)
@BlocProvider.register(SignUpBloc)
abstract class Provider {}