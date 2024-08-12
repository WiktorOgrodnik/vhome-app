import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vhome_repository/vhome_repository.dart';

part 'qrcode_event.dart';
part 'qrcode_state.dart';

class QrcodeBloc extends Bloc<QrcodeEvent, QrcodeState> {
  QrcodeBloc({
    required VhomeRepository repository,
  }) : _repository = repository, super(QrcodeState()) {
    on<QrcodeSubscription>(_onQrcodeSubscription);
    on<QrcodeTokenWaiting>(_onQrcodeTokenWaiting);
  }

  final VhomeRepository _repository;

  Future<void> _onQrcodeTokenWaiting(
    QrcodeTokenWaiting event,
    Emitter<QrcodeState> emit,
  ) async {
    await emit.forEach<UserLogin?>(
      _repository.pairingStream,
      onData: (data) {
        if (data != null) {
          _repository.loginDisplay(data);
          return state.copyWith(status: QrcodeStatus.loaded);
        } else {
          return state;
        }
      },
      onError: (_, __) => state.copyWith(
        status: QrcodeStatus.failure,
      ),
    );
  }

  Future<void> _onQrcodeSubscription(
    QrcodeSubscription event,
    Emitter<QrcodeState> emit,
  ) async {
    emit(state.copyWith(status: QrcodeStatus.loading));

    try {
      final code = await _repository.getPairingCode();
      emit(state.copyWith(status: QrcodeStatus.loaded, code: code));
    } catch (error) {
      emit(state.copyWith(status: QrcodeStatus.failure));
    }
  }
}
