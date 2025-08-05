import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/font_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool dailyReminder = true;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF0A5E2A),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('App Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
              // TODO: Apply dark mode to app
            },
          ),
          const SizedBox(height: 16),

          /// FONT SELECTION SECTION
          const Text("Font Selection", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
        Consumer<FontProvider>(
          builder: (context, fontProvider, _) {
            return DropdownButtonFormField<String>(
              value: fontProvider.fontFamily,
              items: fontProvider.fontOptions.map((font) {
                return DropdownMenuItem(
                  value: font,
                  child: Text(
                    '$font - يَسْمَعُونَ',
                    style: TextStyle(
                        fontFamily: font,
                      fontSize: 20

                    ),
                  ),
                );
              }).toList(),
              onChanged: (selectedFont) {
                if (selectedFont != null) {
                  fontProvider.setFont(selectedFont);
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select Arabic Font',
              ),
            );
          },
        ),


          const SizedBox(height: 24),

          /// PLAYBACK SPEED SECTION
          const Text("Playback Speed", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Slider(
                value: settings.playbackSpeed,
                min: 1.0,
                max: 2.0,
                divisions: 10,
                activeColor: const Color(0xFF0A5E2A),
                label: "${settings.playbackSpeed.toStringAsFixed(1)}x",
                onChanged: (val) => settings.setPlaybackSpeed(val),
              ),
              Text("Speed: ${settings.playbackSpeed.toStringAsFixed(1)}x",
                  style: const TextStyle(color: Colors.grey))
            ],
          ),
          const SizedBox(height: 24),

          /// PLACEHOLDER FOR FUTURE FEATURES
          const ListTile(
            title: Text('Language (Coming Soon)'),
            trailing: Icon(Icons.arrow_forward),
          ),
          const Divider(),

          /// NOTIFICATIONS
          const Text('Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title:  Text('Daily Reminder'),
            activeColor: Color(0xFF0A5E2A),
            value: dailyReminder,
            onChanged: (value)  {
              setState(() {
                dailyReminder = value;
              });
              // if (value) {
              //   await NotificationService.scheduleDailyReminder();
              // } else {
              //   await FlutterLocalNotificationsPlugin().cancel(0);
              // }
              // TODO: Implement daily reminder toggle
            },
          ),
          const Divider(),

          /// ABOUT SECTION
          const Text('About', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const ListTile(
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),
          const ListTile(
            title: Text('Privacy Policy'),
            trailing: Icon(Icons.arrow_forward),
          ),
          const ListTile(
            title: Text('Rate App'),
            trailing: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
  // Add to settings screen

}
