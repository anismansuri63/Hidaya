import 'package:flutter/material.dart';

import '../service/wudu_manager.dart';
import '../theme/app_colors.dart';


class TappableAyahWord extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTapConfirmed;

  const TappableAyahWord({
    Key? key,
    required this.child,
    required this.onTapConfirmed,
  }) : super(key: key);

  @override
  State<TappableAyahWord> createState() => _TappableAyahWordState();
}

class _TappableAyahWordState extends State<TappableAyahWord> {
  final WuduManager _wuduManager = WuduManager();

  Future<void> _handleTap() async {
    if (!_wuduManager.hasConfirmedWudu) {
      final theme = AppColors.of(context);
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Respect the Quran"),
          content: const Text(
              "Only touch Quran Ayah if you have Wudu. Do you have Wudu?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("No", style: TextStyle(color: theme.primary),),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Yes", style: TextStyle(color: theme.primary),),
            ),
          ],
        ),
      );

      if (result == true) {
        _wuduManager.hasConfirmedWudu = true;
      } else {
        return; // Do nothing if user says "No"
      }
    }

    if (widget.onTapConfirmed != null) {
      widget.onTapConfirmed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: widget.child,
    );
  }
}
