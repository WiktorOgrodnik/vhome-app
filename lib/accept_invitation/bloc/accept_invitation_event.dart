part of 'accept_invitation_bloc.dart';

sealed class AcceptInvitationEvent extends Equatable {
  const AcceptInvitationEvent();

  @override
  List<Object> get props => [];
}


final class InvitationCodeChanged extends AcceptInvitationEvent {
  const InvitationCodeChanged({required this.invitationCode});

  final String invitationCode;

  @override
  List<Object> get props => [invitationCode];
}

final class AcceptInvitationSubmitted extends AcceptInvitationEvent {
  const AcceptInvitationSubmitted();
}
