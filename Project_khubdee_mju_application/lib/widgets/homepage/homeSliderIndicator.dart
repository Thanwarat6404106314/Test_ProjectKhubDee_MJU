import 'package:flutter/material.dart';

class HomeSliderIndicator extends StatelessWidget {
  final bool isActive;
  final double activeWidth;
  final double width;
  final EdgeInsets magin;

  const HomeSliderIndicator(
      {super.key,
      required this.isActive,
      required this.activeWidth,
      required this.width,
      required this.magin});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: magin,
      width: isActive ? activeWidth : width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width),
        color: isActive ? Theme.of(context).primaryColor : Colors.grey[300]
      ),
    );
  }
}
