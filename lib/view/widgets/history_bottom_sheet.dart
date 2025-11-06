// view/widgets/history_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator/viewmodel/calculator_viewmodel.dart';

class HistoryBottomSheet extends StatelessWidget {
  const HistoryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CalculatorViewModel>(context, listen: false);

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Riwayat Perhitungan',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Divider(height: 24),

          Consumer<CalculatorViewModel>(
            builder: (context, vm, child) {
              if (vm.history.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text('Belum ada riwayat', style: TextStyle(color: Colors.grey)),
                  ),
                );
              }
              
              return Expanded(
                child: ListView.builder(
                  itemCount: vm.history.length,
                  itemBuilder: (context, index) {
                    final historyEntry = vm.history[index];
                    
                    return ListTile(
                      title: Text(
                        historyEntry,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Text(
                          (vm.history.length - index).toString(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor
                          ),
                        ),
                      ),
                      
                      onTap: () {
                        viewModel.useHistoryValue(historyEntry);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}