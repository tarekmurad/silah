import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  final double size;

  const LoaderWidget({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      // child: const Center(
      //   child: RiveAnimation.asset(
      //     AppAnimations.spinnerAnimation,
      //   ),
      // ),
    );
  }
}
