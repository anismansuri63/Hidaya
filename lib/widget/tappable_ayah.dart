import 'package:flutter/material.dart';

import '../service/wudu_manager.dart';


class TappableAyahWord extends StatefulWidget {
  final Widget wordWidget;
  final VoidCallback onTapConfirmed;

  const TappableAyahWord({
    Key? key,
    required this.wordWidget,
    required this.onTapConfirmed,
  }) : super(key: key);

  @override
  State<TappableAyahWord> createState() => _TappableAyahWordState();
}

class _TappableAyahWordState extends State<TappableAyahWord> {
  final WuduManager _wuduManager = WuduManager();

  Future<void> _handleTap() async {
    if (!_wuduManager.hasConfirmedWudu) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Respect the Quran"),
          content: const Text(
              "Only touch Quran Ayah if you have Wudu. Do you have Wudu?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Yes"),
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

    // ✅ Proceed with tap action
    widget.onTapConfirmed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: widget.wordWidget,
    );
  }
}
