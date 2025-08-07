import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/font_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

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
    final theme = AppColors.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primary,
        iconTheme: IconThemeData(
          color: theme.textWhite, // ← Set your desired color here
        ),
        title: Text("Settings",
          style: TextStyle(color: theme.textWhite),),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('App Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SwitchListTile(
            activeColor: theme.primary,
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
                activeColor:  theme.primary,
                label: "${settings.playbackSpeed.toStringAsFixed(1)}x",
                onChanged: (val) => settings.setPlaybackSpeed(val),
              ),
              Text("Speed: ${settings.playbackSpeed.toStringAsFixed(1)}x",
                  style: TextStyle(color: theme.grey))
            ],
          ),
          const SizedBox(height: 24),

          /// PLACEHOLDER FOR FUTURE FEATURES
          const ListTile(
            title: Text('Language (Coming Soon)'),
            trailing: Icon(Icons.arrow_forward),
          ),
          const Divider(),
          /// THEME COLOR SELECTION
        const Text("Theme Color", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return DropdownButtonFormField<AppTheme>(
              value: themeProvider.theme,
              items: appThemes.map((theme) {
                return DropdownMenuItem<AppTheme>(
                  value: theme,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: theme.primary,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(theme.themeName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (theme) {
                if (theme != null) {
                  themeProvider.setTheme(theme);
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select Theme',
              ),
            );
          },
        ),
          const SizedBox(height: 24),

          /// NOTIFICATIONS
          const Text('Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title:  Text('Daily Reminder'),
            activeColor: theme.primary,
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
