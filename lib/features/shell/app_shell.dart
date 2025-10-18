import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/controllers/auth_controller.dart';
import '../../theme/colors.dart';
import '../../main.dart';
import '../../shared/controllers/navigation_controller.dart';
import 'screens/dashboardScreen.dart';
import '../transfer/view/transferScreen.dart';
import '../exchange/views/exchangeView.dart';
import '../settings/views/settingsView.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationControllerProvider);
    final navigationController = ref.read(navigationControllerProvider.notifier);
    
    final pages = [
      const DashboardScreen(),
      const SendScreen(),
      const ExchangeScreen(),
      const SettingsView(),
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remittance App'),
        actions: [
          IconButton(
            onPressed: () {
              final mode = ref.read(themeModeProvider);
              ref.read(themeModeProvider.notifier).state =
                  mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
            },
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            onPressed: () async => await ref.read(authControllerProvider.notifier).logout(),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          )
        ],
      ),
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => navigationController.changeTab(i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.bottomNavSelected,
        unselectedItemColor: AppColors.bottomNavUnselected,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: 'Send',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Exchange',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}











