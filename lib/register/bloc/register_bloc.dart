import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:vhome_frontend/register/register.dart';
import 'package:vhome_repository/vhome_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required VhomeRepository repository
  }) : _repository = repository, super(RegisterState()) {
    on<RegisterSubmitted>(_onSubmitted);
    on<RegisterUsernameChanged>(_onUsernameChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterRepeatPasswordChanged>(_onRepeatPasswordChanged);
    on<RegisterUserPictureChangeRequested>(_onRegisterUserPictureChangeRequested);
  }

  final VhomeRepository _repository;

  void _onUsernameChanged(
    RegisterUsernameChanged event,
    Emitter<RegisterState> emit
  ) {
    final username = Username.dirty(event.username); 
    emit(
      state.copyWith(
        username: username,
        isValid: Formz.validate([username, state.password, state.repeatPassword])
      )
    );  
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit
  ) {
    final password = Password.dirty(event.password); 
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.username, password, state.repeatPassword])
      )
    );
  }

  void _onRepeatPasswordChanged(
    RegisterRepeatPasswordChanged event,
    Emitter<RegisterState> emit
  ) {
    final repeatPassword = RepeatPassword.dirty(
      password: state.password.value,
      value: event.repeatPassword
    );

    emit(
      state.copyWith(
        repeatPassword: repeatPassword,
        isValid: Formz.validate([state.username, state.password, repeatPassword])
      )
    );
  }

  Future<void> _onRegisterUserPictureChangeRequested(
    RegisterUserPictureChangeRequested event,
    Emitter<RegisterState> emit,
  ) async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'images',
      extensions: <String>['png'],
    );
    final XFile? file =
      await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

    emit(state.copyWith(status: RegisterStatus.loadingPicture));

    if (file != null) {
      final picture = await file.readAsBytes();
      emit(state.copyWith(status: RegisterStatus.ready, picture: picture));
    }
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (state.isValid) {
      try {
        await _repository.registerUser(
          state.username.value,
          state.password.value,
          state.picture
        );
        emit(state.copyWith(formStatus: FormzSubmissionStatus.success));
      } catch (error) {
        emit(state.copyWith(formStatus: FormzSubmissionStatus.failure));
      }
    }
  }
}
