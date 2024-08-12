part of 'qrcode_bloc.dart';

sealed class QrcodeEvent extends Equatable {
  const QrcodeEvent();

  @override
  List<Object> get props => [];
}

final class QrcodeSubscription extends QrcodeEvent {
  const QrcodeSubscription();
}

final class QrcodeTokenWaiting extends QrcodeEvent {
  const QrcodeTokenWaiting();
}
