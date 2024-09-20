import 'package:empire_app/model/card_model.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {super.key,
      required this.colors,
      required this.text,
      required this.onTap});
  final Cardmodel colors;
  final Cardmodel text;
  final Cardmodel onTap;
  @override
  Widget build(BuildContext context) {
    double hight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return onTap.onTap;
            },
          ));
        },
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors.colors,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  text.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: hight / 60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
