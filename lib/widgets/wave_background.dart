import 'package:flutter/material.dart';

/// Latar bergelombang biru muda untuk halaman status (loading / berhasil).
class WaveBackground extends StatelessWidget {
  final Widget child;
  const WaveBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    const soft = Color(0xFFDCE9F8);
    return Container(
      color: const Color(0xFFEFF6FD),
      child: Stack(
        children: [
          Positioned(
            top: -70,
            right: -50,
            child: Container(
              width: 240,
              height: 170,
              decoration:
                  const BoxDecoration(color: soft, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            top: 30,
            left: -90,
            child: Transform.rotate(
              angle: 0.25,
              child: Container(
                width: 260,
                height: 36,
                decoration: BoxDecoration(
                    color: soft, borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: -110,
            child: Transform.rotate(
              angle: 0.25,
              child: Container(
                width: 260,
                height: 30,
                decoration: BoxDecoration(
                    color: soft, borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: -40,
            right: -40,
            child: Container(
              height: 230,
              decoration: const BoxDecoration(
                color: soft,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(400, 120),
                  topRight: Radius.elliptical(400, 120),
                ),
              ),
            ),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}