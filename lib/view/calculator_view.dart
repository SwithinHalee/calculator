// lib/view/calculator_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator/viewmodel/calculator_viewmodel.dart';
import 'package:calculator/view/widgets/calculator_display.dart';
import 'package:calculator/view/widgets/calculator_keypad.dart';
import 'package:calculator/view/widgets/history_bottom_sheet.dart';

class CalculatorView extends StatelessWidget {
  const CalculatorView({super.key});

  void _showHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return const HistoryBottomSheet();
      },
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    final viewModel = Provider.of<CalculatorViewModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menghapus semua riwayat? Tindakan ini tidak dapat dibatalkan.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                viewModel.clearHistory();
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_outlined),
            onPressed: () {
              _showHistory(context);
            },
          ),
          const SizedBox(width: 10),
        ],
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

            const Divider(),
            
            ListTile(
              leading: const Icon(Icons.delete_forever_outlined),
              title: const Text('Hapus Riwayat'),
              onTap: () {
                Navigator.of(context).pop();
                _showClearHistoryDialog(context);
              },
            ),
          ],
        ),
      ),
      
      body: SafeArea(
        bottom: false, // Ini adalah baris kuncinya
        child: Column(
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
      ),
    );
  }
}