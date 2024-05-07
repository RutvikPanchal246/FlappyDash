import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onTap;

  const RoundedButton({super.key, required this.iconData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white10,
          border: Border.all(color: Colors.white),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              50,
            ),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Icon(
          iconData,
          color: Colors.white,
        ),
      ),
    );
  }
}
