import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../service/navigation_service.dart';
import 'app_theme.dart';
extension AppColorsExtension on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
class AppColors {
  static AppTheme of(BuildContext context) =>
      Provider.of<ThemeProvider>(context, listen: true).theme;


  // static AppTheme get current {
  //   final context = NavigationService.navigatorKey.currentContext;
  //   if (context == null) {
  //     throw Exception('No context available!');
  //   }
  //   return of(context);
  // }

  //Primary Colors
  // static const Color primary = Color(0xFF0A5E2A);
  // static const Color primary2 = Color(0xFF1B7942);
  // static const Color secondary = Color(0xFFD4A017);
  // static const Color accent = Color(0xFFF8F5F0);
  //
  // // Backgrounds & Surfaces
  // static const Color background = Color(0xFFE8E3D7);
  // static const Color cardBorder = theme.secondary;
  //
  // // Text Colors
  // static const Color textDark = AppColors.primary;
  // static const Color textWhite = Colors.white;
  // static const Color textBlack = Colors.black;

  // Status Colors
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.orange;

  // Disabled
  static const Color grey = Colors.grey;

}
