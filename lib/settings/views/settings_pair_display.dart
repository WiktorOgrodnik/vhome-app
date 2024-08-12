import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vhome_frontend/settings/bloc/settings_bloc.dart';
import 'package:vhome_frontend/widgets/widgets.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class SettingsPairDisplayPage extends StatelessWidget {
  SettingsPairDisplayPage({super.key});
 
  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => SettingsPairDisplayPage(),
    );
  }

  final MobileScannerController controller = MobileScannerController(formats: [BarcodeFormat.qrCode]);
 
  @override    
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 1000,
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SectionTitle(
                    child: Text("Paste pairing code here."),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: MobileScanner(
                        fit: BoxFit.fitWidth,
                        controller: controller,
                        onDetect: (capture) {
                          print("HELLO!");
                          final List<Barcode> barcodes = capture.barcodes;
                          
                          if (barcodes.length > 1) {
                            print("To many qrcodes");
                            return;
                          }

                          context
                            .read<SettingsBloc>()
                            .add(SettingsPairDisplayCodeSubmitted(barcodes[0].rawValue!));
                        },
                      ),
                    ),
                  ), 
                ],
              ),
            ),
          ),
        ),
      ),
    ); 
  }
}
