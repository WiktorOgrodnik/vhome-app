part of 'register_bloc.dart';

enum RegisterStatus {
  loadingPicture,
  ready,
}

final class RegisterState extends Equatable {
  const RegisterState({
    this.formStatus = FormzSubmissionStatus.initial,
    this.status = RegisterStatus.ready,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.repeatPassword = const RepeatPassword.pure(),
    this.picture,
    this.isValid = false,
  });

  final FormzSubmissionStatus formStatus;
  final RegisterStatus status;
  final Username username;
  final Password password;
  final RepeatPassword repeatPassword;
  final Uint8List? picture;
  final bool isValid;

  RegisterState copyWith({
    FormzSubmissionStatus? formStatus,
    RegisterStatus? status,
    Username? username,
    Password? password,
    RepeatPassword? repeatPassword,
    Uint8List? picture,
    bool? isValid,
  }) {
    return RegisterState(
      formStatus: formStatus ?? this.formStatus,
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      repeatPassword: repeatPassword ?? this.repeatPassword,
      picture: picture ?? this.picture,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [formStatus, status, username, password, repeatPassword, picture, isValid];
}
