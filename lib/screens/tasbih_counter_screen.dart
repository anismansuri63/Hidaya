import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
    with TickerProviderStateMixin {
  int _counter = 0;
  int _targetCount = 33;
  int _totalCount = 0; // Lifetime counter
  String _duaText = "سُبْحَانَ اللهِ";
  final TextEditingController _duaController = TextEditingController();

  // Preset dhikr options
  final List<Map<String, dynamic>> _presetDhikr = [
    {'arabic': 'سُبْحَانَ اللهِ', 'transliteration': 'SubhanAllah', 'meaning': 'Glory be to Allah', 'recommended': 33},
    {'arabic': 'الْحَمْدُ لِلَّهِ', 'transliteration': 'Alhamdulillah', 'meaning': 'Praise be to Allah', 'recommended': 33},
    {'arabic': 'اللهُ أَكْبَرُ', 'transliteration': 'Allahu Akbar', 'meaning': 'Allah is the Greatest', 'recommended': 34},
    {'arabic': 'لَا إِلَٰهَ إِلَّا اللهُ', 'transliteration': 'La ilaha illallah', 'meaning': 'There is no god but Allah', 'recommended': 100},
    {'arabic': 'أَسْتَغْفِرُ اللهَ', 'transliteration': 'Astaghfirullah', 'meaning': 'I seek forgiveness from Allah', 'recommended': 100},
    {'arabic': 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ', 'transliteration': 'La hawla wa la quwwata illa billah', 'meaning': 'There is no power except with Allah', 'recommended': 100},
  ];

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _beadSlideController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _beadSlideAnimation;

  // Color palette
  var _primaryGold = Color(0xFFD4AF37);
  var _darkGreen = Color(0xFF0D4D2B);
  var _lightGreen = Color(0xFF1A6B3C);
  var _accentGreen = Color(0xFF2E8B57);
  var _beadGold = Color(0xFFFFD700);
  var _beadShadow = Color(0xFFB8860B);
  var _cream = Color(0xFFFFF8E7);

  bool _vibrationEnabled = true;
  bool _soundEnabled = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _beadSlideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _beadSlideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _beadSlideController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _beadSlideController.dispose();
    _duaController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    if (_vibrationEnabled) {
      HapticFeedback.lightImpact();
    }

    _pulseController.forward().then((_) => _pulseController.reverse());
    _beadSlideController.forward(from: 0);

    setState(() {
      _counter++;
      _totalCount++;

      // Check if target reached
      if (_counter == _targetCount) {
        _showTargetReachedDialog();
        if (_vibrationEnabled) {
          HapticFeedback.heavyImpact();
        }
      }
    });
  }

  void _decrementCounter() {
    if (_counter > 0) {
      if (_vibrationEnabled) {
        HapticFeedback.selectionClick();
      }
      setState(() {
        _counter--;
        if (_totalCount > 0) _totalCount--;
      });
    }
  }

  void _resetCounter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _darkGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Reset Counter?', style: TextStyle(color: _primaryGold)),
        content: Text(
          'This will reset your current count to 0.',
          style: TextStyle(color: _cream),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: _cream)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _counter = 0);
              Navigator.pop(context);
              if (_vibrationEnabled) HapticFeedback.mediumImpact();
            },
            style: ElevatedButton.styleFrom(backgroundColor: _primaryGold),
            child: Text('Reset', style: TextStyle(color: _darkGreen)),
          ),
        ],
      ),
    );
  }

  void _showTargetReachedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _darkGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.celebration, color: _primaryGold),
            const SizedBox(width: 8),
            Text('Target Reached!', style: TextStyle(color: _primaryGold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ما شاء الله',
              style: TextStyle(color: _cream, fontSize: 28, fontFamily: 'Arial'),
            ),
            const SizedBox(height: 8),
            Text(
              'You have completed $_targetCount counts',
              style: TextStyle(color: _cream),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _counter = 0);
              Navigator.pop(context);
            },
            child: Text('Start New', style: TextStyle(color: _cream)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: _primaryGold),
            child: Text('Continue', style: TextStyle(color: _darkGreen)),
          ),
        ],
      ),
    );
  }

  void _showDhikrSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: _darkGreen,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _cream.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Dhikr',
                    style: TextStyle(
                      color: _primaryGold,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showCustomDuaDialog(),
                    icon: Icon(Icons.edit, color: _primaryGold),
                    tooltip: 'Custom Dhikr',
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _presetDhikr.length,
                itemBuilder: (context, index) {
                  final dhikr = _presetDhikr[index];
                  final isSelected = _duaText == dhikr['arabic'];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? _lightGreen : _lightGreen.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: isSelected
                          ? Border.all(color: _primaryGold, width: 2)
                          : null,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        dhikr['arabic'],
                        style: TextStyle(
                          color: _cream,
                          fontSize: 24,
                          fontFamily: 'Arial',
                        ),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          Text(
                            dhikr['transliteration'],
                            style: TextStyle(color: _cream, fontSize: 14),
                          ),
                          Text(
                            dhikr['meaning'],
                            style: TextStyle(color: _cream, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.repeat, size: 14, color: _cream.withOpacity(0.5)),
                              const SizedBox(width: 4),
                              Text(
                                'Recommended: ${dhikr['recommended']}x',
                                style: TextStyle(color: _cream.withOpacity(0.5), fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle, color: _primaryGold)
                          : null,
                      onTap: () {
                        setState(() {
                          _duaText = dhikr['arabic'];
                          _targetCount = dhikr['recommended'];
                          _counter = 0;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomDuaDialog() {
    Navigator.pop(context); // Close bottom sheet first
    _duaController.text = _duaText;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _darkGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Custom Dhikr', style: TextStyle(color: _primaryGold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _duaController,
              style: TextStyle(color: _cream, fontSize: 18),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Enter your dhikr...',
                hintStyle: TextStyle(color: _cream.withOpacity(0.5)),
                filled: true,
                fillColor: _lightGreen,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _primaryGold, width: 2),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Target: ', style: TextStyle(color: _cream)),
                Expanded(
                  child: Slider(
                    value: _targetCount.toDouble(),
                    min: 10,
                    max: 1000,
                    divisions: 99,
                    activeColor: _primaryGold,
                    inactiveColor: _lightGreen,
                    label: _targetCount.toString(),
                    onChanged: (value) {
                      setState(() => _targetCount = value.toInt());
                    },
                  ),
                ),
                Text('$_targetCount', style: TextStyle(color: _primaryGold)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: _cream)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _duaText = _duaController.text.isNotEmpty
                    ? _duaController.text
                    : 'سُبْحَانَ اللهِ';
                _counter = 0;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: _primaryGold),
            child: Text('Save', style: TextStyle(color: _darkGreen)),
          ),
        ],
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _darkGreen,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _cream.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Settings', style: TextStyle(color: _primaryGold, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildSettingTile(
                'Vibration',
                Icons.vibration,
                _vibrationEnabled,
                    (value) {
                  setModalState(() => _vibrationEnabled = value);
                  setState(() {});
                },
              ),
              _buildSettingTile(
                'Sound',
                Icons.volume_up,
                _soundEnabled,
                    (value) {
                  setModalState(() => _soundEnabled = value);
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _lightGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Lifetime Count', style: TextStyle(color: _cream)),
                    Text(
                      _totalCount.toString(),
                      style: TextStyle(color: _cream, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(String title, IconData icon, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _lightGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: _cream),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: TextStyle(color: _cream, fontSize: 16))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: _cream,
            activeTrackColor: _beadGold,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _counter / _targetCount;
    final theme = AppColors.of(context);
    _primaryGold = theme.primary;
    _darkGreen = theme.primary2;
    _lightGreen = theme.primary;
    _accentGreen = theme.primary2;
    _beadGold = theme.cardBorder;

    _cream = theme.background;
    return Scaffold(
      backgroundColor: _darkGreen,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: _cream),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Tasbih', style: TextStyle(color: _cream, fontWeight: FontWeight.w300)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: _cream),
            onPressed: _showSettings,
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: _incrementCounter,
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_darkGreen, _lightGreen.withOpacity(0.3), _darkGreen],
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Dhikr Display Card
                GestureDetector(
                  onTap: _showDhikrSelector,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_lightGreen, _accentGreen],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.edit, color: _cream.withOpacity(0.5), size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Tap to change',
                              style: TextStyle(color: _cream.withOpacity(0.5), fontSize: 11),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _duaText,
                          style: TextStyle(
                            color: _cream,
                            fontSize: 28,
                            fontFamily: 'Arial',
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Main Counter with Circular Progress
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer glow
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _primaryGold.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                      // Progress ring
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          strokeWidth: 8,
                          backgroundColor: _lightGreen,
                          valueColor: AlwaysStoppedAnimation<Color>(_primaryGold),
                        ),
                      ),
                      // Inner circle with count
                      Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [_lightGreen, _darkGreen],
                          ),
                          border: Border.all(color: _primaryGold.withOpacity(0.3), width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _counter.toString(),
                              style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                color: _cream,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: _primaryGold.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'of $_targetCount',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _cream,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Loop indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: _lightGreen.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Loop ${(_counter ~/ _targetCount) + 1}',
                    style: TextStyle(color: _cream.withOpacity(0.8), fontSize: 14),
                  ),
                ),

                const Spacer(),

                // Bead Animation Row
                //_buildBeadRow(),

                const SizedBox(height: 30),

                // Control Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildControlButton(
                        icon: Icons.remove,
                        onPressed: _decrementCounter,
                        size: 50,
                        color: _lightGreen,
                      ),
                      _buildControlButton(
                        icon: Icons.add,
                        onPressed: _incrementCounter,
                        size: 70,
                        color: _lightGreen,
                        //isMain: true,
                      ),
                      _buildControlButton(
                        icon: Icons.refresh,
                        onPressed: _resetCounter,
                        size: 50,
                        color: _lightGreen,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Tap anywhere hint
                Text(
                  'Tap anywhere to count',
                  style: TextStyle(color: _cream.withOpacity(0.4), fontSize: 12),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBeadRow() {
    const int visibleBeads = 9;
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // String
          Container(
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_beadShadow, _beadGold, _beadShadow],
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          // Beads
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(visibleBeads, (index) {
              final centerIndex = visibleBeads ~/ 2;
              final isCurrent = index == centerIndex;
              final distance = (index - centerIndex).abs();
              final scale = 1.0 - (distance * 0.1);
              final opacity = 1.0 - (distance * 0.15);

              return AnimatedBuilder(
                animation: _beadSlideAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isCurrent ? scale + (_beadSlideAnimation.value * 0.1) : scale,
                    child: Opacity(
                      opacity: opacity.clamp(0.3, 1.0),
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            center: const Alignment(-0.3, -0.3),
                            colors: isCurrent
                                ? [_beadGold, _beadShadow]
                                : [_beadGold.withOpacity(0.6), _beadShadow.withOpacity(0.6)],
                          ),
                          boxShadow: isCurrent
                              ? [
                            BoxShadow(
                              color: _primaryGold.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ]
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required double size,
    required Color color,
    bool isMain = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: isMain ? _primaryGold.withOpacity(0.4) : Colors.black26,
              blurRadius: isMain ? 15 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isMain ? _darkGreen : _cream,
          size: isMain ? 32 : 24,
        ),
      ),
    );
  }
}
