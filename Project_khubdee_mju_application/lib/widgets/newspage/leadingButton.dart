import 'package:flutter/material.dart';

class LeadingButton extends StatelessWidget {
  final Function()? onTap;
  final IconData iconData;
  const LeadingButton({super.key, this.onTap, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFF006D0D),
      borderRadius: BorderRadius.circular(56),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(56),
        child: InkWell(
          borderRadius: BorderRadius.circular(56),
          onTap: onTap,
          child: SizedBox(
            width: 56,
            height: 56,
            child: Icon(
              iconData,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }
}
