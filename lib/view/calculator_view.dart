import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator/viewmodel/calculator_viewmodel.dart';
import 'package:calculator/view/widgets/calculator_display.dart';
import 'package:calculator/view/widgets/calculator_keypad.dart';
import 'package:calculator/view/widgets/history_bottom_sheet.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDrawer() {
    _animationController.isCompleted
        ? _animationController.reverse()
        : _animationController.forward();
  }

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

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CalculatorViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _toggleDrawer,
        ),
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
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: const [
                Expanded(
                  flex: 2,
                  child: CalculatorDisplay(),
                ),
                Expanded(
                  flex: 4,
                  child: CalculatorKeypad(),
                ),
              ],
            ),
          ),
          
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              if (_animationController.value == 0.0) {
                return const SizedBox.shrink();
              }
              return FadeTransition(
                opacity: _fadeAnimation,
                child: GestureDetector(
                  onTap: _toggleDrawer,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              );
            },
          ),

          SlideTransition(
            position: _slideAnimation,
            child: _buildDrawer(viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(CalculatorViewModel viewModel) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        color: Theme.of(context).scaffoldBackgroundColor,
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
                viewModel.clearHistory();
                _toggleDrawer();
              },
            ),
          ],
        ),
      ),
    );
  }
}