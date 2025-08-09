import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> with SingleTickerProviderStateMixin {
  int _counter = 0;
  String _duaText = "اللهم أنت السلام ومنك السلام تباركت يا ذا الجلال والإكرام";
  final TextEditingController _duaController = TextEditingController();

  // Color palette based on user's request
  final Color _primaryGold = const Color(0xFFD4A017);
  final Color _darkGreen = const Color(0xFF0A5E2A);
  final Color _lightGreen = const Color(0xFF1B7942);
  final Color _beadYellow = const Color(0xFFF9D750);
  final Color _beadAccent = const Color(0xFFE9C46A);

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _showDuaDialog() {
    _duaController.text = _duaText;
    final theme = AppColors.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _lightGreen,
          title: Text(
            'Add or Edit Dua',
            style: TextStyle(color: _primaryGold),
          ),
          content: TextField(
            controller: _duaController,
            style: TextStyle(color: theme.textWhite),
            decoration: InputDecoration(
              hintText: "Enter your dua here...",
              hintStyle: TextStyle(color: theme.textWhite),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: theme.textWhite),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: _primaryGold, width: 2),
              ),
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: theme.textWhite)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryGold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Save', style: TextStyle(color: theme.textWhite)),
              onPressed: () {
                setState(() {
                  _duaText = _duaController.text.isNotEmpty
                      ? _duaController.text
                      : "No dua set";
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // The total number of beads for the loop
    const int totalBeads = 80;
    // The number of beads visible on the screen at a time
    const int visibleBeads = 7;
    // Calculate the animated position for the group of beads
    final double beadGroupPosition = (visibleBeads - 1) * 60 - (_counter % totalBeads) * 60.0;
    final theme = AppColors.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primary,
        iconTheme: IconThemeData(
          color: theme.textWhite, // ← Set your desired color here
        ),
        title: Text("Tasbih",
          style: TextStyle(color: theme.textWhite),),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 16),
              // Loop Counter
              Text(
                'Loop ${_counter ~/ totalBeads + 1}',
                style:  TextStyle(
                  color: theme.textWhite,
                  fontSize: 18,
                  fontFamily: 'serif',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Main Counter Display
              Column(
                children: [
                  Text(
                    (_counter % totalBeads).toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 90,
                      fontWeight: FontWeight.bold,
                      color: _darkGreen,
                      fontFamily: 'sans-serif',
                    ),
                  ),
                  Text(
                    '/ $totalBeads',
                    style: TextStyle(
                      fontSize: 24,
                      color: theme.textWhite,
                      fontFamily: 'sans-serif',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Tasbih String Animation Section
              Expanded(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: SizedBox(
                      height: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // The string itself
                          Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: _darkGreen,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          // The animated row of beads
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            left: beadGroupPosition,
                            child: Row(
                              children: List.generate(
                                totalBeads,
                                    (index) => _buildBead(
                                  isCountingBead: (_counter % totalBeads == index),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Dua Display Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _lightGreen,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Current Dhikr',
                      style: TextStyle(
                        color: _primaryGold,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'serif',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _duaText,
                      style: TextStyle(
                        color: theme.textWhite,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'serif',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _showDuaDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _darkGreen,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          'Edit Dua',
                          style: TextStyle(color: theme.textWhite, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Control Buttons Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildActionButton(
                    icon: Icons.add,
                    label: 'Count',
                    onPressed: _incrementCounter,
                    color: _primaryGold,
                    color2: theme.textWhite
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build a single bead
  Widget _buildBead({required bool isCountingBead}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isCountingBead ? [_beadYellow, _beadAccent] : [_beadAccent.withOpacity(0.5), _beadYellow.withOpacity(0.5)],
          ),
          border: Border.all(
            color: _primaryGold.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: isCountingBead
              ? const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ]
              : null,
        ),
      ),
    );
  }

  // Helper widget to build the styled action buttons
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    required Color color2
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: color2,
        backgroundColor: color,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        minimumSize: const Size(120, 60),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
