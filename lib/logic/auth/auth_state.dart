

class AuthState {}

class AuthInitial extends AuthState{}

class AuthInProgress extends AuthState{}
class AuthSuccess extends AuthState{}
class AuthFailure extends AuthState{
  String message;
  AuthFailure({required this.message});
}
class AuthRegisterSuccess extends AuthState{
  String message;
  AuthRegisterSuccess({required this.message});
}
