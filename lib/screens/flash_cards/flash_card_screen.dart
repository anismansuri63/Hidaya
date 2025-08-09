import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/flash_card_provider.dart';
import '../../providers/font_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class FlashCardScreen extends StatefulWidget {
  final AppTheme appTheme; // <-- AppTheme variable

  const FlashCardScreen({
    super.key,
    required this.appTheme,
  });

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}


class _FlashCardScreenState extends State<FlashCardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _flipCard() {
    if (_isFront) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
    _isFront = !_isFront;
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.appTheme;
    final provider = Provider.of<FlashCardProvider>(context);
    final fontProvider = Provider.of<FontProvider>(context);
    // ✅ Prevent building UI before data is loaded
    if (provider.cards.isEmpty) {
      return Scaffold(
        backgroundColor: theme.background,
        appBar: AppBar(
          backgroundColor: theme.primary,
          iconTheme: IconThemeData(color: theme.textWhite),
          title: const Text("Flash Cards"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.primary,
        iconTheme: IconThemeData(color: theme.textWhite),
        title: Text(
          "Flash Cards (${provider.difficulty.displayName})",
          style: TextStyle(color: theme.textWhite),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primary.withOpacity(0.15),
                  theme.secondary.withOpacity(0.05),
                  theme.background,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (provider.currentIndex + 1) / provider.cards.length,
                  backgroundColor: theme.primary.withOpacity(0.2),
                  color: theme.secondary,
                ),
                const SizedBox(height: 20),
                Text(
                  "Card ${provider.currentIndex + 1} of ${provider.cards.length}",
                  style: TextStyle(
                    color: theme.textBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),

                // Flash Card with flip effect
                GestureDetector(
                  onTap: _flipCard,
                  child: AnimatedBuilder(
                    animation: _flipController,
                    builder: (context, child) {
                      final angle = _flipController.value * pi;
                      final isFront = angle <= pi / 2;

                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(angle),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [theme.primary, theme.primary2],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              // BoxShadow(
                              //   color: theme.primary.withOpacity(0.3),
                              //   blurRadius: 12,
                              //   offset: const Offset(0, 6),
                              // ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            isFront
                                ? provider.currentCard.arabic
                                : provider.currentCard.english,
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: theme.textWhite,
                              fontFamily: fontProvider.fontFamily,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),

                // Options
                Expanded(
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: provider.currentOptions.map((option) {
                      final isSelected = option == provider.selectedOption;
                      final isCorrect = option == provider.currentCard.english;
                      Color? bgColor, borderColor, textColor;

                      if (provider.showResult) {
                        if (isSelected) {
                          bgColor = provider.isCorrect
                              ? theme.secondary.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2);
                          borderColor =
                          provider.isCorrect ? theme.secondary : Colors.red;
                          textColor =
                          provider.isCorrect ? theme.secondary : Colors.red;
                        } else if (isCorrect) {
                          bgColor = theme.secondary.withOpacity(0.2);
                          borderColor = theme.secondary;
                          textColor = theme.secondary;
                        }
                      } else {
                        bgColor = isSelected
                            ? theme.primary.withOpacity(0.2)
                            : theme.background;
                        borderColor =
                        isSelected ? theme.primary : theme.cardBorder;
                      }

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: borderColor ?? theme.cardBorder,
                            width: 2,
                          ),
                          boxShadow: [
                            if (!provider.showResult)
                              BoxShadow(
                                color: theme.primary.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: provider.showResult
                                ? null
                                : () =>
                                provider.selectOption(option, context, theme),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 24,
                              ),
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: textColor ?? theme.textBlack,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
