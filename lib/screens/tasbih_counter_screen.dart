import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

// class AnimatedBeadRow extends StatelessWidget {
//   final int count;
//   final int total;
//   final double beadSize;
//   final Color beadColor;
//
//   const AnimatedBeadRow({
//     super.key,
//     required this.count,
//     this.total = 33,
//     this.beadSize = 28,
//     required this.beadColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final visibleBeads = 9; // visible beads at once
//     final offset = (count % total) * (beadSize + 12);
//
//     return SizedBox(
//       height: beadSize + 16,
//       child: Stack(
//         children: [
//           Positioned.fill(
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 transform: Matrix4.translationValues(-offset.toDouble(), 0, 0),
//                 child: Row(
//                   children: List.generate(total, (index) {
//                     return Container(
//                       width: beadSize,
//                       height: beadSize,
//                       margin: const EdgeInsets.symmetric(horizontal: 6),
//                       decoration: BoxDecoration(
//                         color: beadColor,
//                         shape: BoxShape.circle,
//                         boxShadow: const [
//                           BoxShadow(color: Colors.black26, blurRadius: 4)
//                         ],
//                         gradient: const LinearGradient(
//                           colors: [Colors.white38, Colors.transparent],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// class RealTasbihUI extends StatefulWidget {
//   const RealTasbihUI({super.key});
//
//   @override
//   State<RealTasbihUI> createState() => _RealTasbihUIState();
// }
//
// class _RealTasbihUIState extends State<RealTasbihUI> {
//   int count = 0;
//   int target = 80;
//   int loop = 1;
//
//   void _increment() {
//     setState(() {
//       count++;
//       if (count >= target) {
//         count = 0;
//         loop++;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const beadColor = Color(0xFFFFD700); // yellow glass-like
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Tasbih", style: TextStyle(color: Colors.black)),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         actions: const [
//           Icon(Icons.refresh, color: Colors.green),
//           SizedBox(width: 10),
//           Icon(Icons.notifications_off, color: Colors.green),
//           SizedBox(width: 16),
//         ],
//         leading: const Icon(Icons.arrow_back, color: Colors.green),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Text("Loop $loop", style: const TextStyle(fontSize: 16, color: Colors.black87)),
//             GestureDetector(
//               onTap: _increment,
//               child: Text(
//                 count.toString().padLeft(2, '0'),
//                 style: const TextStyle(fontSize: 80, color: Colors.green, fontWeight: FontWeight.bold),
//               ),
//             ),
//             Text("/ $target", style: const TextStyle(fontSize: 18, color: Colors.grey)),
//
//             const SizedBox(height: 30),
//
//             // Beads Moving Horizontally
//             AnimatedBeadRow(count: count, total: target, beadColor: beadColor),
//
//             const SizedBox(height: 30),
//
//             // Dhikr Area
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.green.shade50,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 children: const [
//                   Text(
//                     'حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ...',
//                     style: TextStyle(fontSize: 22, fontFamily: 'Scheherazade', color: Colors.black87),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Ya hayyu ya qayyum bi rahmatika astaghiitsu...',
//                     style: TextStyle(fontSize: 16, color: Colors.green),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


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
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter your dua here...",
              hintStyle: const TextStyle(color: Colors.white54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white),
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
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
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
              child: const Text('Save', style: TextStyle(color: Colors.white)),
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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Top Bar with Tasbih and Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back_ios, color: _darkGreen),
                  Text(
                    'Tasbih',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'serif',
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.refresh, color: _darkGreen),
                      SizedBox(width: 16),
                      Icon(Icons.notifications_none, color: _darkGreen),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Loop Counter
              Text(
                'Loop ${_counter ~/ totalBeads + 1}',
                style: const TextStyle(
                  color: Colors.white70,
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
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white70,
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
                      style: const TextStyle(
                        color: Colors.white,
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
                        child: const Text(
                          'Edit Dua',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
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
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
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
