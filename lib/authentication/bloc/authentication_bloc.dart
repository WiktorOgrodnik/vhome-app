import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vhome_repository/vhome_repository.dart';
import 'package:vhome_web_api/vhome_web_api.dart';

part 'authentication_event.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthState> {
    AuthenticationBloc({
      required VhomeRepository repository
    })  : _repository = repository,
          super(const AuthState.pending()) {
      on<_AuthenticationStateChanged>(_onAuthenticationStateChanged);
      on<AuthenticationGroupSelected>(_onAuthenticationGroupSelected);
      on<AuthenticationGroupUnselectionRequested>(_onAuthenticationGroupUnselectionRequested);
      on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
      on<AuthenticationGroupLeaveRequested>(_onAuthenticationGroupLeaveRequested);
      _authStateSubscription = _repository.authStream.listen(
        (state) => add(_AuthenticationStateChanged(state: state)),
      );
    }

    final VhomeRepository _repository;
    late StreamSubscription<AuthState> _authStateSubscription;

    @override
    Future<void> close() {
      _authStateSubscription.cancel();
      return super.close();
    }

    Future<void> _onAuthenticationStateChanged(
      _AuthenticationStateChanged event,
      Emitter<AuthState> emit
    ) async {
      switch (event.state.status) {
        case AuthStatus.unauthenticated:
          return emit(const AuthState.unauthenticated());
        case AuthStatus.groupUnselected:
          assert(event.state.data != null);
          return emit(AuthState.groupUnselected(event.state.data!));
        case AuthStatus.groupSelected:
          assert(event.state.data != null);
          return emit(AuthState.groupSelected(event.state.data!));
        default:
          return emit(const AuthState.pending());
      }
    }

    void _onAuthenticationGroupSelected(
      AuthenticationGroupSelected event,
      Emitter<AuthState> emit,
    ) {
      unawaited(_repository.selectGroup(event.group.id));
    }

    void _onAuthenticationGroupUnselectionRequested(
      AuthenticationGroupUnselectionRequested event,
      Emitter<AuthState> emit,
    ) {
      unawaited(_repository.unselectGroup());
    }

    void _onAuthenticationLogoutRequested(
      AuthenticationLogoutRequested event,
      Emitter<AuthState> emit,
    ) {
      unawaited(_repository.logout());
    }

    void _onAuthenticationGroupLeaveRequested(
      AuthenticationGroupLeaveRequested event,
      Emitter<AuthState> emit,
    ) {
      unawaited(_repository.leaveGroup());
    }
  }
