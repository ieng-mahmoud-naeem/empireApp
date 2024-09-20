import 'package:empire_app/constants.dart';
import 'package:flutter/material.dart';

class CustomClickButom extends StatelessWidget {
  const CustomClickButom({super.key, this.onTap, required this.lable});
  final void Function()? onTap;
  final String lable;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(lable, textDirection: kText),
            const SizedBox(
              width: 10,
            ),
            const Icon(Icons.error)
          ],
        ),
      ),
    );
  }
}
