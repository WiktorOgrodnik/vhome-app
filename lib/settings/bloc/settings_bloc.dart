import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_repository/vhome_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required VhomeRepository repository,
  }) : _repository = repository, super(SettingsState()) {
    on<SettingsInvitationCodeRequested>(_onSubmitted);
    on<SettingsOverviewReturned>(_onReturnClicked);
  }

  final VhomeRepository _repository;

  Future<void> _onSubmitted(
    SettingsInvitationCodeRequested event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final invitationCode = await _repository.generateInvitationCode();
      emit(state.copyWith(
        status: SettingsStatus.invitation,
        invitation: invitationCode,
      ));
    } catch (_) {
      emit(state.copyWith(status: SettingsStatus.error));
    }
  }

  void _onReturnClicked(
    SettingsOverviewReturned event,
    Emitter<SettingsState> emit
  ) {
    emit(state.copyWith(status: SettingsStatus.overview));
  }
}
