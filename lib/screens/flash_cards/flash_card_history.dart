import 'dart:convert';
import 'package:com_quranicayah/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/font_provider.dart';
import '../../theme/app_colors.dart';

class FlashCardHistoryScreen extends StatefulWidget {
  const FlashCardHistoryScreen({super.key});

  @override
  State<FlashCardHistoryScreen> createState() => _FlashCardHistoryScreenState();
}

class _FlashCardHistoryScreenState extends State<FlashCardHistoryScreen> {
  List<dynamic> _history = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('quiz_history');
    if (historyJson != null) {
      setState(() {
        _history = jsonDecode(historyJson);
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${_getWeekday(date.weekday)} ${date.day}/${date.month}/${date.year}';
  }

  String _getWeekday(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    final fontProvider = Provider.of<FontProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Flash Card History",
          style: TextStyle(
            color: theme.textWhite,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: theme.textWhite),
        backgroundColor: theme.primary,
        elevation: 4,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ), // <-- properly closed AppBar here
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primary.withOpacity(0.05),
              theme.primary.withOpacity(0.15),
            ],
          ),
        ),
        child: _history.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/empty_history.png',
                height: 180,
                color: theme.primary.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
              Text(
                "No Quiz History Yet",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: theme.textBlack,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Your flashcard sessions will appear here",
                style: TextStyle(
                  fontSize: 16,
                  color: theme.textBlack.withOpacity(0.7),
                ),
              ),
            ],
          ),
        )
            : Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _history.length,
            itemBuilder: (context, index) {
              final result = _history[index];
              final date = DateTime.parse(result['date']);
              final correct = result['correct'] as List;
              final wrong = result['wrong'] as List;
              final correctCount = correct.length;
              final wrongCount = wrong.length;
              final total = correctCount + wrongCount;
              final accuracy =
              total > 0 ? (correctCount / total * 100).round() : 0;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ExpansionTile(
                    collapsedBackgroundColor: isDark
                        ? theme.primary.withOpacity(0.15)
                        : theme.primary.withOpacity(0.08),
                    backgroundColor:
                    isDark ? theme.cardBorder : Colors.white,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        accuracy > 70
                            ? Icons.emoji_events
                            : accuracy > 40
                            ? Icons.auto_awesome
                            : Icons.hourglass_bottom,
                        color: theme.primary,
                        size: 28,
                      ),
                    ),
                    title: Text(
                      _formatDate(date),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: theme.textBlack,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          _buildStatChip(
                            icon: Icons.check_circle,
                            color: Colors.green,
                            count: correctCount,
                          ),
                          const SizedBox(width: 12),
                          _buildStatChip(
                            icon: Icons.cancel,
                            color: Colors.red,
                            count: wrongCount,
                          ),
                          const Spacer(),
                          Text(
                            '$accuracy%',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: accuracy > 70
                                  ? Colors.green
                                  : accuracy > 40
                                  ? Colors.orange
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    children: [
                      if (correct.isNotEmpty) ...[
                        _buildSectionHeader(
                          icon: Icons.check_circle,
                          color: Colors.green,
                          title: "Correct Answers ($correctCount)",
                        ),
                        ..._buildAnswerList(
                          items: correct,
                          icon: Icons.check,
                          color: Colors.green,
                          fontProvider: fontProvider,
                          theme: theme,
                        ),
                      ],
                      if (wrong.isNotEmpty) ...[
                        _buildSectionHeader(
                          icon: Icons.cancel,
                          color: Colors.red,
                          title: "Wrong Answers ($wrongCount)",
                        ),
                        ..._buildAnswerList(
                          items: wrong,
                          icon: Icons.close,
                          color: Colors.red,
                          fontProvider: fontProvider,
                          theme: theme,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    }

  Widget _buildStatChip({required IconData icon, required Color color, required int count}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({required IconData icon, required Color color, required String title}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: color.withOpacity(0.08),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAnswerList({
    required List<dynamic> items,
    required IconData icon,
    required Color color,
    required FontProvider fontProvider,
    required AppTheme theme,
  }) {
    return items.map((item) => ListTile(
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: color),
      ),
      title: Text(
        item['arabic'],
        style: TextStyle(
          fontFamily: fontProvider.fontFamily,
          fontSize: 24,
          height: 1.4,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          item['english'],
          style: TextStyle(
            fontFamily: fontProvider.fontFamily,
            fontSize: 18,
            color: theme.textBlack.withOpacity(0.8),
          ),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minVerticalPadding: 12,
    )).toList();
  }
}