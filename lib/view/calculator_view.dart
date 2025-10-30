// view/calculator_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator/viewmodel/calculator_viewmodel.dart';
import 'package:calculator/view/widgets/calculator_display.dart';
import 'package:calculator/view/widgets/calculator_keypad.dart';

class CalculatorView extends StatelessWidget {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            
            Consumer<CalculatorViewModel>(
              builder: (context, vm, child) {
                return SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: vm.isDarkMode,
                  onChanged: (bool newValue) {
                    vm.toggleTheme();
                  },
                  secondary: Icon(
                    vm.isDarkMode 
                      ? Icons.nightlight_round_outlined 
                      : Icons.wb_sunny_outlined,
                  ),
                );
              },
            ),
          ],
        ),
      ),

      body: Column(
        children: const [
          Expanded(
            flex: 2,
            child: CalculatorDisplay(),
          ),
          
          Divider(height: 1),

          Expanded(
            flex: 4,
            child: CalculatorKeypad(),
          ),
        ],
      ),
    );
  }
}