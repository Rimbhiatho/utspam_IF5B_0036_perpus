import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? iconColor;

  const PageHeader({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 100,
          color: iconColor ?? const Color.fromARGB(255, 171, 185, 223),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
