import 'package:flutter/material.dart';

class DatePickerRow extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onSelect;

  const DatePickerRow({
    super.key,
    required this.selectedDate,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Tanggal: ${selectedDate.toLocal()}'.split(' ')[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(onPressed: onSelect, child: const Text('Pilih Tanggal')),
      ],
    );
  }
}
