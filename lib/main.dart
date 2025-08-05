import 'package:com_quranicayah/providers/font_provider.dart';
import 'package:com_quranicayah/providers/settings_provider.dart';
import 'package:com_quranicayah/screens/splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/ayah_provider.dart';
import 'screens/ayah_screen.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Important before using async in main

  final fontProvider = FontProvider();
  await fontProvider.loadFont();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF0A5E2A),
    ),
  );

  runApp(MyApp(fontProvider: fontProvider));
}

class MyApp extends StatelessWidget {
  final FontProvider fontProvider;

  const MyApp({super.key, required this.fontProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: fontProvider), // Use the loaded instance
        ChangeNotifierProvider(create: (_) => AyahProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MaterialApp(
        title: 'Quranic Ayah',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}


void main1() => runApp(const MaterialApp(home: QuranSplashScreen()));
