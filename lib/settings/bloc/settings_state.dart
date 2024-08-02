part of 'settings_bloc.dart';

enum SettingsStatus { overview, invitation, error }

final class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.overview,
    this.invitation = '',
  });

  final SettingsStatus status;
  final String invitation;

  SettingsState copyWith({
    SettingsStatus? status,
    String? invitation,
  }) {
    return SettingsState(
      status: status ?? this.status,
      invitation: invitation ?? this.invitation,
    );
  }

  @override
  List<Object> get props => [status, invitation];
}
