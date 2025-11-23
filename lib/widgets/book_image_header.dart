import 'package:flutter/material.dart';
import '../data/model/infobuku.dart';

class BookImageHeader extends StatelessWidget {
  final InfoBuku buku;
  final double height;

  const BookImageHeader({super.key, required this.buku, this.height = 150});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(buku.imagePath, height: height, fit: BoxFit.cover),
      ),
    );
  }
}
