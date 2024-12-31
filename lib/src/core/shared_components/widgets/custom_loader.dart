import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  final Color color;
  final double size;

  const CustomLoader({
    Key? key,
    this.color = Colors.blue, // Default color
    this.size = 50.0, // Default size
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 4.0,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
