import 'package:com_quranicayah/screens/flash_cards/flash_card_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/flash_card_provider.dart';
import '../../theme/app_colors.dart';
import 'flash_card_screen.dart';

import 'package:provider/provider.dart';

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);

    return Scaffold(
        appBar: AppBar(
        backgroundColor: theme.primary,
        iconTheme: IconThemeData(color: theme.textWhite),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
        actions: [
        IconButton(
        icon: const Icon(Icons.history),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FlashCardHistoryScreen()),
          );
      },
    ),


      ],
        title: Text(
          'Select Difficulty',
          style: TextStyle(color: theme.textWhite),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primary.withOpacity(0.1),
              theme.background,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10 ,horizontal: 20),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Difficulty cards
                  _DifficultyCard(
                    difficulty: Difficulty.easy,
                    icon: Icons.flag,
                    color: theme.primary,
                    delay: 0,
                  ),
                  _DifficultyCard(
                    difficulty: Difficulty.medium,
                    icon: Icons.terrain,
                    color: theme.primary2,
                    delay: 100,
                  ),
                  _DifficultyCard(
                    difficulty: Difficulty.hard,
                    icon: Icons.landscape,
                    color: theme.secondary,
                    delay: 200,
                  ),
                  _DifficultyCard(
                    difficulty: Difficulty.extreme,
                    icon: Icons.difference_outlined,
                    color: theme.primary,
                    delay: 300,
                  ),
                  _DifficultyCard(
                    difficulty: Difficulty.mix,
                    icon: Icons.shuffle,
                    color: theme.cardBorder,
                    delay: 400,
                  ),

                  // Decorative footer
                  const SizedBox(height: 16),
                  Text(
                    'Learn Arabic with flashcards',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.textBlack.withOpacity(0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Icon(
                    Icons.menu_book,
                    color: theme.primary,
                    size: 36,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  final Difficulty difficulty;
  final IconData icon;
  final Color color;
  final int delay;

  const _DifficultyCard({
    required this.difficulty,
    required this.icon,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => FlashCardProvider(difficulty: difficulty),
                child: FlashCardScreen(appTheme: theme),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.accent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: theme.primary.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: theme.cardBorder,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Icon with decorative background
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),

              const SizedBox(width: 20),

              // Difficulty info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      difficulty.displayName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.textBlack,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getDescription(difficulty),
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textBlack.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                color: theme.primary,
                size: 20,
              ),
            ],
          ),
        ),
      ).animate().slideX(
        begin: 1,
        end: 0,
        duration: 400.ms,
        delay: delay.ms,
        curve: Curves.easeOut,
      ),
    );
  }

  String _getDescription(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return '2 options per card - Perfect for beginners';
      case Difficulty.medium:
        return '3 options per card - Good for practice';
      case Difficulty.hard:
        return '4 options per card - Challenging level';
      case Difficulty.extreme:
        return '5 options per card - Expert difficulty';
      case Difficulty.mix:
        return 'Random options (2-5) - Mixed challenge';
    }
  }
}
