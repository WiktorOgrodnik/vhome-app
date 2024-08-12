part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

final class SettingsInvitationCodeRequested extends SettingsEvent {
  const SettingsInvitationCodeRequested();
}

final class SettingsPairDisplayCodeRequested extends SettingsEvent {
  const SettingsPairDisplayCodeRequested();
}

final class SettingsPairDisplayQrcodeRequested extends SettingsEvent {
  const SettingsPairDisplayQrcodeRequested();
}

final class SettingsOverviewReturned extends SettingsEvent {
  const SettingsOverviewReturned();
}

final class SettingsPairDisplayCodeSubmitted extends SettingsEvent {
  const SettingsPairDisplayCodeSubmitted(this.code);

  final String code;

  @override
  List<Object> get props => [code];
}
