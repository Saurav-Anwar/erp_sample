import 'package:erp_sample/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_root.dart';
import 'providers/app_data_providers.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppDataProvider()..loadData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ERP Sample',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          elevation: 8,
          backgroundColor: AppTheme.primaryBgColor,
          foregroundColor: Colors.white,
          actionsIconTheme: const IconThemeData(color: Colors.white),
          actionsPadding: EdgeInsets.symmetric(horizontal: 15),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 15,
          backgroundColor: AppTheme.primaryBgColor,
          unselectedItemColor: Colors.grey.shade700,
          selectedItemColor: AppTheme.primaryFgColor,
          type: BottomNavigationBarType.shifting
        ),
        textTheme: TextTheme(
          titleLarge: AppTheme.textStyle(fontSize: 22),
          bodyLarge: AppTheme.textStyle(fontSize: 16),
          bodyMedium: AppTheme.textStyle(fontSize: 14),
          bodySmall: AppTheme.textStyle(fontSize: 12),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: AppTheme.primaryFgColor,
          linearTrackColor: AppTheme.primaryBgColor,
          circularTrackColor: AppTheme.primaryBgColor,
          borderRadius: BorderRadius.circular(50),
        ),
        scaffoldBackgroundColor: AppTheme.primaryBgColor,
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primaryBgColor),
      ),
      debugShowCheckedModeBanner: false,
      home: const AppRoot(),
    );
  }
}
