import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vhome_repository/vhome_repository.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
    AuthenticationBloc({
      required VhomeRepository repository
    })  : _repository = repository,
          super(const AuthenticationState.pending()) {
      on<_AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
      on<AuthenticationGroupSelected>(_onAuthenticationGroupSelected);
      on<AuthenticationGroupUnselectionRequested>(_onAuthenticationGroupUnselectionRequested);
      on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
      _authStateSubscription = _repository.authState$.listen(
        (status) => add(_AuthenticationStatusChanged(status: status)),
      );
    }

    final VhomeRepository _repository;
    late StreamSubscription<AuthState> _authStateSubscription;

    @override
    Future<void> close() {
      _authStateSubscription.cancel();
      return super.close();
    }

    Future<void> _onAuthenticationStatusChanged(
      _AuthenticationStatusChanged event,
      Emitter<AuthenticationState> emit
    ) async {
      final user = await _repository.tryGetUser();
      switch (event.status) {
        case AuthState.unauthenticated:
          return emit(AuthenticationState.unauthenticated(user));
        case AuthState.groupUnselected:
          return emit(
            user != null
              ? AuthenticationState.groupUnselected(user)
              : AuthenticationState.unauthenticated(user)
          );
        case AuthState.groupSelected:
          return emit(
            user != null ?
              AuthenticationState.groupSelected(user) :
              AuthenticationState.unauthenticated(user)
          );
        default:
          return emit(const AuthenticationState.pending());
      }
    }

    void _onAuthenticationGroupSelected(
      AuthenticationGroupSelected event,
      Emitter<AuthenticationState> emit,
    ) {
      unawaited(_repository.selectGroup(event.group.id));
    }

    void _onAuthenticationGroupUnselectionRequested(
      AuthenticationGroupUnselectionRequested event,
      Emitter<AuthenticationState> emit,
    ) {
      unawaited(_repository.unselectGroup());
    }

    void _onAuthenticationLogoutRequested(
      AuthenticationLogoutRequested event,
      Emitter<AuthenticationState> emit,
    ) {
      unawaited(_repository.logout());
    }
  }
