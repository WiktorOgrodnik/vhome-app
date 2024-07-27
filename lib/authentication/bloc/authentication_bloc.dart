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
      switch (event.status) {
        case AuthState.unauthenticated:
          return emit(const AuthenticationState.unauthenticated());
        case AuthState.groupUnselected:
          final user = await _repository.tryGetUser();
          return emit(
            user != null
              ? AuthenticationState.groupUnselected(user)
              : const AuthenticationState.unauthenticated()
          );
        case AuthState.groupSelected:
          final user = await _repository.tryGetUser();

          return emit(
            user != null ?
              AuthenticationState.groupSelected(user) :
              const AuthenticationState.unauthenticated()
          );
        default:
          return emit(const AuthenticationState.pending());
      }
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
