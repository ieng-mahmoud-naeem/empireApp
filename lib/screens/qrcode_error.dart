import 'package:flutter/material.dart';

class QrcodeError extends StatelessWidget {
  const QrcodeError({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'لقد تجاوزت الحد الاقصي لعدد مرات الحضور يرجي مراجعة مدير السنتر',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width / 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
