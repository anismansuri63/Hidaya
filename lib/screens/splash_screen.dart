
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuranSplashScreen extends StatelessWidget {
  const QuranSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A5E2A), Color(0xFF1B7942)],
          ),
        ),
        child: Stack(
          children: [
            // Islamic pattern background
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: CustomPaint(painter: _IslamicPatternPainter()),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App icon
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A5E2A).withOpacity(0.8),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD4A017),
                        width: 5,
                      ),
                    ),
                    child: const Icon(
                      Icons.menu_book,
                      size: 120,
                      color: Color(0xFFD4A017),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Arabic text
                  const Text(
                    "بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ",
                    style: TextStyle(
                      fontFamily: 'Kitab',
                      fontSize: 36,
                      color: Color(0xFFD4A017),
                      height: 1.8,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // English text
                  const Text(
                    "In the name of Allah, the Most Gracious, the Most Merciful",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Loading indicator
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4A017)),
                    strokeWidth: 6,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IslamicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4A017)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const tileSize = 50.0;
    final rows = (size.height / tileSize).ceil();
    final cols = (size.width / tileSize).ceil();

    for (int row = 0; row <= rows; row++) {
      for (int col = 0; col <= cols; col++) {
        final x = col * tileSize;
        final y = row * tileSize;

        // Draw geometric star pattern
        final path = Path()
          ..moveTo(x + tileSize / 2, y)
          ..lineTo(x + tileSize * 0.6, y + tileSize * 0.4)
          ..lineTo(x + tileSize, y + tileSize / 2)
          ..lineTo(x + tileSize * 0.6, y + tileSize * 0.6)
          ..lineTo(x + tileSize * 0.7, y + tileSize)
          ..lineTo(x + tileSize / 2, y + tileSize * 0.7)
          ..lineTo(x + tileSize * 0.3, y + tileSize)
          ..lineTo(x + tileSize * 0.4, y + tileSize * 0.6)
          ..lineTo(x, y + tileSize / 2)
          ..lineTo(x + tileSize * 0.4, y + tileSize * 0.4)
          ..close();

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}