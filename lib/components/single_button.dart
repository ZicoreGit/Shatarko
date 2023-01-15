import 'package:flutter/material.dart';

class SingleButton extends StatelessWidget {
  final String imagePath;
  final Color btnupColor;
  final Color btndownColor;
  final Color btntopShadow;
  final Color btndownShadow;
  const SingleButton(
      {super.key,
      required this.imagePath,
      required this.btnupColor,
      required this.btndownColor,
      required this.btntopShadow,
      required this.btndownShadow});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 135,
        width: 135,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              // Color(0xFFF6FAFF),
              // Color(0xFFD6E3F6),
              btnupColor,
              btndownColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: btndownShadow,
              blurRadius: 20,
              offset: const Offset(10, 10),
              // changes position of shadow
            ),
            BoxShadow(
              color: btntopShadow,
              blurRadius: 20,
              offset: const Offset(-12, -12),
              // changes position of shadow
            ),
          ],
        ),
        child: Image.asset(
          // 'lib/images/normalpanic.png',
          imagePath, height: 80,
          width: 80,
        ),
      ),
    );
  }
}
