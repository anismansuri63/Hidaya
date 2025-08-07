import 'package:com_quranicayah/providers/font_provider.dart';
import 'package:com_quranicayah/providers/settings_provider.dart';
import 'package:com_quranicayah/providers/theme_provider.dart';
import 'package:com_quranicayah/screens/splash_screen.dart';
import 'package:com_quranicayah/service/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/ayah_provider.dart';
import 'screens/ayah_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Important before using async in main

  final fontProvider = FontProvider();
  await fontProvider.loadFont();

  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: AppColors.primary,
  //   ),
  // );

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
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Add this

      ],
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
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
