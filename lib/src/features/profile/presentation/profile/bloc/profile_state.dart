abstract class ProfileState {}

class InitialProfileState extends ProfileState {}

/// Logout

class LogoutLoadingState extends ProfileState {}

class LogoutSucceed extends ProfileState {}

class LogoutFailed extends ProfileState {
  final String? message;

  LogoutFailed({this.message});
}
