import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';

class CommonBloc {
  CommonBloc._();
  static final authenticationBloc = AuthenticationBloc();

  static final List<BlocProvider> blocProvider = [
    BlocProvider<AuthenticationBloc>(create: (_) => authenticationBloc),
  ];

  Future<void> close() async {
    await authenticationBloc.close();
  }
}
