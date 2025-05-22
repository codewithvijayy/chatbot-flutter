// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    Key? key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.onTap,
    this.suffixIcon,
  }) : super(key: key);
  final String hintText;
  final TextEditingController controller;
  final bool? obscureText;
  final VoidCallback? onTap;
  final IconData? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          TextField(
            obscureText: obscureText ?? false,
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: onTap,
                child: Icon(suffixIcon),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 55, 51, 70),
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.white54),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.pink.shade300, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.white60),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
