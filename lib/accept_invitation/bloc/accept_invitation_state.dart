part of 'accept_invitation_bloc.dart';

final class AcceptInvitationState extends Equatable {
  const AcceptInvitationState({
    this.status = FormzSubmissionStatus.initial,
    this.invitationCode = const InvitationCode.pure(),
    this.isValid = false,
  });

  final FormzSubmissionStatus status;
  final InvitationCode invitationCode;
  final bool isValid;

  AcceptInvitationState copyWith({
    FormzSubmissionStatus? status,
    InvitationCode? invitationCode,
    bool? isValid,
  }) {
    return AcceptInvitationState(
      status: status ?? this.status,
      invitationCode: invitationCode ?? this.invitationCode,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [status, invitationCode, isValid];
}
