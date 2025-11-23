import 'package:flutter/material.dart';

class LamaPinjamField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const LamaPinjamField({super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Lama Pinjam: ', style: TextStyle(color: Colors.white70)),
        SizedBox(
          width: 60,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Hari',
              hintStyle: TextStyle(color: Colors.white38),
              border: InputBorder.none,
            ),
            onChanged: onChanged,
          ),
        ),
        const Text(' hari', style: TextStyle(color: Colors.white70)),
      ],
    );
  }
}
