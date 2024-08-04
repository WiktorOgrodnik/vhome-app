part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

final class SettingsInvitationCodeRequested extends SettingsEvent {
  const SettingsInvitationCodeRequested();
}

final class SettingsOverviewReturned extends SettingsEvent {
  const SettingsOverviewReturned();
}
