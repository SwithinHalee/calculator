// view/widgets/calculator_keypad.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator/viewmodel/calculator_viewmodel.dart';
import 'package:calculator/view/widgets/calculator_button.dart';
import 'package:calculator/utils/app_colors.dart';

class CalculatorKeypad extends StatelessWidget {
  const CalculatorKeypad({super.key});

  static const List<String> buttons = [
    'C', '()', '%', '÷',
    '1', '2', '3', '×',
    '4', '5', '6', '+',
    '7', '8', '9', '-',
    '.', '0', '000', '=',
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CalculatorViewModel>(context, listen: false);

    return Container(
      // padding: const EdgeInsets.all(16), // HAPUS BARIS INI
      color: Theme.of(context).brightness == Brightness.light 
            ? AppColors.lightDisplayBg 
            : null,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
        ),
        itemCount: buttons.length,
        itemBuilder: (context, index) {
          final buttonText = buttons[index];
          return CalculatorButton(
            text: buttonText,
            onPressed: () {
              viewModel.onButtonPressed(buttonText);
            },
          );
        },
      ),
    );
  }
} 