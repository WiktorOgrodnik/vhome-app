part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}


final class RegisterUsernameChanged extends RegisterEvent {
  const RegisterUsernameChanged({required this.username});
  final String username;

  @override
  List<Object> get props => [username];
}

final class RegisterPasswordChanged extends RegisterEvent {
  const RegisterPasswordChanged({required this.password});
  final String password;

  @override
  List<Object> get props => [password];
}

final class RegisterRepeatPasswordChanged extends RegisterEvent {
  const RegisterRepeatPasswordChanged({required this.repeatPassword});
  final String repeatPassword;

  @override
  List<Object> get props => [repeatPassword];
}

final class RegisterUserPictureChangeRequested extends RegisterEvent {
  const RegisterUserPictureChangeRequested();
}

final class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted();
}
