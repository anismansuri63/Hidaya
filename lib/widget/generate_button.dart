import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GenerateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GenerateButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.accent,
          foregroundColor:  theme.primary,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side:  BorderSide(
              color: theme.secondary,
              width: 3,
            ),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Get New Ayah', style: TextStyle(fontSize: 22)),
          ],
        ),
      ),
    );
  }
}