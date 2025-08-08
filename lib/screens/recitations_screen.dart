import 'package:com_quranicayah/widget/audio_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recitation_provider.dart';
import '../theme/app_colors.dart';

class Recitation {
  final String id;
  final String name;
  final String imagePath;
  final String sampleUrl;
  Recitation({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.sampleUrl,
  });
}

class RecitationsScreen extends StatelessWidget {
  const RecitationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    final provider = Provider.of<RecitationProvider>(context);
    return ChangeNotifierProvider(
      create: (context) => RecitationProvider(),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: theme.primary,
            iconTheme: IconThemeData(color: theme.textWhite),
            title: Text("Select Reciter", style: TextStyle(color: theme.textWhite)),
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
            child: Column(
              children: [


                // Recitations List
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView.builder(
                      itemCount: provider.recitations.length,
                      itemBuilder: (context, index) {
                        final recitation = provider.recitations[index];
                        final isSelected = recitation.id == provider.selectedReciterId;

                        return _RecitationCard(
                          recitation: recitation,
                          isSelected: isSelected,
                          onSelect: () => provider.selectReciter(recitation.id),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}

class _RecitationCard extends StatelessWidget {
  final Recitation recitation;
  final bool isSelected;
  final VoidCallback onSelect;

  const _RecitationCard({
    required this.recitation,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
          color: isSelected ? theme.secondary : theme.cardBorder,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          // Selected indicator
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Reciter Image
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.primary, width: 2),
                        image: DecorationImage(
                          image: AssetImage(recitation.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Reciter Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recitation.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.textBlack,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Sample Available',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Transform.scale(
                      scale: 1.5,
                      child: AudioPlayButton(audioUrl: recitation.sampleUrl),
                    )

                  ],
                ),

                const SizedBox(height: 16),

                // Select Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onSelect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? theme.primary2
                          : theme.primary.withOpacity(0.1),
                      foregroundColor: isSelected
                          ? theme.textWhite
                          : theme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isSelected ? 'Selected' : 'Select Reciter',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
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
