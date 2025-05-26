import 'package:flutter/material.dart';

class ButtonBuilder extends StatelessWidget {
  final String text;
  final Color? color;
  final Function callback;
  const ButtonBuilder({super.key, required this.text, this.color, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ElevatedButton(
          onPressed: ()=> callback(text),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: color ?? Color(0xFF302e3b),
            elevation: 8,
            shadowColor: Colors.black.withValues(alpha: 0.5),
          ),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Text(
              text,
              key: ValueKey<String>(text),
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
