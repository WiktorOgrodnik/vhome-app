import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vhome_frontend/qrcode_page/bloc/qrcode_bloc.dart';
import 'package:vhome_frontend/widgets/section_title.dart';
import 'package:vhome_repository/vhome_repository.dart';

class QrcodePage extends StatelessWidget {
  const QrcodePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const QrcodePage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrcodeBloc(repository: context.read<VhomeRepository>())
        ..add(const QrcodeSubscription())
        ..add(const QrcodeTokenWaiting()),
      child: const QrcodeView(),
    );
  }
}

class QrcodeView extends StatelessWidget {
  const QrcodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pair this display with your Vhome app"),
      ),
      body: SafeArea(
        child: BlocBuilder<QrcodeBloc, QrcodeState>(
          builder: (context, state) {
            switch (state.status) {
              case QrcodeStatus.loaded:
                return SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 1000,
                      child: Center(
                        child: Column(
                          children: [
                            const SectionTitle(child: Text("Scan this code with your app to pair the display")),
                            const SizedBox(height: 25),
                            QrImageView(
                              data: state.code,
                              version: QrVersions.auto,
                              size: 200.0,
                            ),
                            const SizedBox(height: 25),
                            const SectionTitle(child: Text("...or rewrite this code:")),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 100.0),
                              child: _CodeField(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              case QrcodeStatus.failure:
                return const Center(child: Text("failed to get pairing code."));
              default:
                return const Center(child: CircularProgressIndicator());
            }
          }
        ),
      ),
    );
  }
}

class _CodeField extends StatelessWidget {
  const _CodeField();

  @override
  Widget build(BuildContext context) {
    final state = context.select((QrcodeBloc bloc) => bloc.state);
    final controller = TextEditingController(text: state.code);

    return TextField(
      textAlign: TextAlign.center,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
      ),
      readOnly: true,
    );
  }
}
