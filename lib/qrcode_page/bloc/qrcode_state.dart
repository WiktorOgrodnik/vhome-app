part of 'qrcode_bloc.dart';

enum QrcodeStatus { initial, loading, failure, loaded, paired }

final class QrcodeState extends Equatable {
  const QrcodeState({
    this.status = QrcodeStatus.initial,
    this.code = '',
  });
  
  final QrcodeStatus status;
  final String code;

  QrcodeState copyWith({
    QrcodeStatus? status,
    String? code,
  }) {
    return QrcodeState(
      status: status ?? this.status,
      code: code ?? this.code,
    );
  }

  @override
  List<Object> get props => [status, code];
}
