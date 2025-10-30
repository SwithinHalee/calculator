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
    return Consumer<CalculatorViewModel>(
      builder: (context, viewModel, child) {
        return MaterialApp(
          title: 'Calculator',
          debugShowCheckedModeBanner: false,
          
          themeMode: viewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          
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
              surface: AppColors.darkBg,
            )
          ),

          home: const CalculatorView(),
        );
      },
    );
  }
}