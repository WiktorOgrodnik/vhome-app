import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:vhome_frontend/accept_invitation/accept_invitation.dart';
import 'package:vhome_repository/vhome_repository.dart';

part 'accept_invitation_event.dart';
part 'accept_invitation_state.dart';

class AcceptInvitationBloc extends Bloc<AcceptInvitationEvent, AcceptInvitationState> {
  AcceptInvitationBloc({
    required VhomeRepository repository,
  }) : _repository = repository, super(AcceptInvitationState()) {
    on<AcceptInvitationSubmitted>(_onSubmitted);
    on<InvitationCodeChanged>(_onCodeChanged);
  }

  final VhomeRepository _repository;

  void _onCodeChanged(
    InvitationCodeChanged event,
    Emitter<AcceptInvitationState> emit
  ) {
    final invitationCode = InvitationCode.dirty(event.invitationCode);
    emit(
      state.copyWith(
        invitationCode: invitationCode,
        isValid: Formz.validate([invitationCode]),
      )
    );
  }

  Future<void> _onSubmitted(
    AcceptInvitationSubmitted event,
    Emitter<AcceptInvitationState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _repository.acceptInvitation(state.invitationCode.value);
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
