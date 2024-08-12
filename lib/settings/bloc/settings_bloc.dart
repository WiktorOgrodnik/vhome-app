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
    on<SettingsPairDisplayCodeRequested>(_onPairDisplayCodeRequested);
    on<SettingsPairDisplayCodeSubmitted>(_onPairDisplayCodeSubmitted);
    on<SettingsPairDisplayQrcodeRequested>(_onPairDisplayQrcodeRequested);
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

  Future<void> _onPairDisplayCodeRequested(
    SettingsPairDisplayCodeRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.pairingCode));
  }
  
  Future<void> _onPairDisplayQrcodeRequested(
    SettingsPairDisplayQrcodeRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.pairingQrcode));
  }

  Future<void> _onPairDisplayCodeSubmitted(
    SettingsPairDisplayCodeSubmitted event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _repository.addDisplay(event.code);
      emit(state.copyWith(status: SettingsStatus.overview));
    } catch (e) {
      print(e);
    }
  }

  void _onReturnClicked(
    SettingsOverviewReturned event,
    Emitter<SettingsState> emit
  ) {
    emit(state.copyWith(status: SettingsStatus.overview));
  }
}
