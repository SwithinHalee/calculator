// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator/viewmodel/calculator_viewmodel.dart';
import 'package:calculator/view/calculator_view.dart';
import 'package:calculator/utils/app_colors.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CalculatorViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer di sini agar MaterialApp bisa ikut-ikutan berganti tema
    return Consumer<CalculatorViewModel>(
      builder: (context, viewModel, child) {
        return MaterialApp(
          title: 'Calculator',
          debugShowCheckedModeBanner: false,
          
          // --- Definisi Tema ---
          themeMode: viewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          
          // Tema Terang
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColors.lightBg,
            primaryColor: AppColors.lightPrimary,
            textTheme: const TextTheme(
              headlineMedium: TextStyle(color: AppColors.lightText, fontWeight: FontWeight.bold),
              headlineSmall: TextStyle(color: AppColors.lightText),
              bodyMedium: TextStyle(color: AppColors.lightText, fontSize: 24),
            ),
            colorScheme: const ColorScheme.light(
              primary: AppColors.lightPrimary,
              secondary: AppColors.lightOperator,
              onSurface: AppColors.lightText,
              surface: AppColors.lightButtonBg,
            )
          ),

          // Tema Gelap
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.darkBg,
            primaryColor: AppColors.darkPrimary,
            textTheme: const TextTheme(
              headlineMedium: TextStyle(color: AppColors.darkText, fontWeight: FontWeight.bold),
              headlineSmall: TextStyle(color: AppColors.darkText),
              bodyMedium: TextStyle(color: AppColors.darkText, fontSize: 24),
            ),
            colorScheme: const ColorScheme.dark(
              primary: AppColors.darkPrimary,
              secondary: AppColors.darkOperator,
              onSurface: AppColors.darkText,
              surface: AppColors.darkBg, // Tombol angka akan sama dengan bg
            )
          ),

          home: const CalculatorView(),
        );
      },
    );
  }
}