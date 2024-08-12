import 'package:flutter/material.dart';

class PairingPage extends StatelessWidget {
  const PairingPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const PairingPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pair this display with your Vhome app"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 1000,
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.bluetooth),
                    Icon(Icons.phone),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
