import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator/viewmodel/calculator_viewmodel.dart';

class CalculatorDisplay extends StatelessWidget {
  const CalculatorDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          alignment: Alignment.bottomRight,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                viewModel.expression,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600]
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 16),
              Text(
                viewModel.display,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 56,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}