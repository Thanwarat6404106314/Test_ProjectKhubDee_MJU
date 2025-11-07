import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String errorText;
  final bool enabled;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.errorText,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: TextStyle(fontFamily: 'Mitr')),
        SizedBox(height: 6),
        Container(
          child: TextFormField(
            controller: controller,
            enabled: enabled,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return errorText;
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: hintText,
              contentPadding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 14,
              ),
            ),
            style: TextStyle(
                color: enabled ? Color(0xFF363636) : Colors.grey,
                fontSize: 14,
                fontFamily: 'Mitr'),
          ),
        ),
      ],
    );
  }
}
