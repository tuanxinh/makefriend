

class AuthEvent {}

class AuthLogin extends AuthEvent {
  String email;
  String password;
  AuthLogin({required this.email, required this.password});
}

class AuthRegister extends AuthEvent {
  String email;
  String hoten;
  String password;
  AuthRegister({required this.email, required this.password, required this.hoten});
}