import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadigScreen extends StatelessWidget {
  const LoadigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SpinKitPulse(
        size: MediaQuery.of(context).size.width,
        itemBuilder: (context, index) {
          return Image.asset(
            'assets/image/lodingLogo.png',
          );
        },
      ),
    );
  }
}
