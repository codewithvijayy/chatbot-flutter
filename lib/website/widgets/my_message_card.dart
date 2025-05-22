import 'package:flutter/material.dart';

class MyMessageCard extends StatelessWidget {
  const MyMessageCard({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(21, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(message, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
