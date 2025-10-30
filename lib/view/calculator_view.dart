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
    // Kita tidak perlu 'listen: false' di sini lagi,
    // karena tombolnya akan ada di dalam Consumer di Drawer.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        // Kita HAPUS 'actions' (tombol tema) dari sini
      ),
      
      // --- TAMBAHKAN PROPERTI 'drawer' INI ---
      drawer: Drawer(
        child: ListView(
          // Padding: EdgeInsets.zero penting untuk menghapus 
          // spasi kosong di atas (di area status bar)
          padding: EdgeInsets.zero,
          children: [
            // Header untuk drawer
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
            
            // Pindahkan Consumer ke sini untuk tombol ganti tema
            Consumer<CalculatorViewModel>(
              builder: (context, vm, child) {
                return SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: vm.isDarkMode,
                  onChanged: (bool newValue) {
                    // Panggil action di ViewModel
                    vm.toggleTheme();
                  },
                  // Tambahkan ikon agar lebih cantik
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
      // ------------------------------------

      body: Column(
        children: const [
          // Bagian Layar (Display)
          Expanded(
            flex: 2,
            child: CalculatorDisplay(),
          ),
          
          // Garis pemisah
          Divider(height: 1),

          // Bagian Tombol (Keypad)
          Expanded(
            flex: 4,
            child: CalculatorKeypad(),
          ),
        ],
      ),
    );
  }
}