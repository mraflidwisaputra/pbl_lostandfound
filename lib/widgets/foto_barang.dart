import 'dart:convert';
import 'package:flutter/material.dart';

/// Menampilkan foto dari asset (mis. "assets/images/jam.png")
/// ATAU dari teks base64 yang disimpan di Firestore.
class FotoBarang extends StatelessWidget {
  final String sumber;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final ImageErrorWidgetBuilder? errorBuilder;

  const FotoBarang(
    this.sumber, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    Widget kosong() => Container(
        width: width,
        height: height,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image_outlined));

    if (sumber.isEmpty) return kosong();
    if (sumber.startsWith('assets/')) {
      return Image.asset(sumber,
          width: width, height: height, fit: fit, errorBuilder: errorBuilder);
    }
    try {
      return Image.memory(base64Decode(sumber),
          width: width,
          height: height,
          fit: fit,
          gaplessPlayback: true,
          errorBuilder: errorBuilder);
    } catch (_) {
      return kosong();
    }
  }
}