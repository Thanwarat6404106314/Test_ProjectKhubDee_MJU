import 'dart:ui';

import 'package:flutter/material.dart';

class LeadingButtonBlur extends StatelessWidget {
  final Function()? onTap;
  final IconData iconData;
  const LeadingButtonBlur({super.key, this.onTap, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0x44FFFFFF),
      borderRadius: BorderRadius.circular(56),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(56),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5,
            sigmaY: 5,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(56),
            onTap: onTap,
            child: SizedBox(
              width: 56,
              height: 56,
              child: Icon(
                iconData,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
