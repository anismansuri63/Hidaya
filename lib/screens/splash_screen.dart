
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
class QuranSplashScreen extends StatelessWidget {
  const QuranSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.primary, theme.primary2],
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
                      color:  theme.primary.withOpacity(0.8),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:  theme.secondary,
                        width: 5,
                      ),
                    ),
                    child: Icon(
                      Icons.menu_book,
                      size: 120,
                      color: theme.secondary,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Arabic text
                  Text(
                    "بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ",
                    style: TextStyle(
                      fontFamily: 'Kitab',
                      fontSize: 36,
                      color: theme.secondary,
                      height: 1.8,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // English text
                  Text(
                    "In the name of Allah, the Most Gracious, the Most Merciful",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: theme.textWhite,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Loading indicator
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(theme.secondary),
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
      ..color =  Colors.red
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