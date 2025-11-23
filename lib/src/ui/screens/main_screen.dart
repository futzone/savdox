import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/ui/screens/home_screen.dart';
import 'package:savdox/src/ui/screens/products_screen.dart';
import 'package:savdox/src/ui/screens/billing_screen.dart';
import 'package:savdox/src/ui/screens/others_screen.dart';
import 'package:savdox/src/ui/screens/order_form_screen.dart';

// Provider for current navigation index
final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  // Helper method to map navigation index to screen index
  int _getScreenIndex(int navIndex, bool isWideScreen) {
    if (isWideScreen) {
      // Wide screen: indices 0,1 -> screens 0,1; index 2 is action; indices 3,4 -> screens 2,3
      if (navIndex <= 1) return navIndex;
      if (navIndex == 2) return 0; // Should not happen, but fallback to home
      return navIndex - 1; // 3 -> 2, 4 -> 3
    } else {
      // Mobile: indices 0,1,2,3 map directly to screens 0,1,2,3
      return navIndex;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final isWideScreen = MediaQuery.of(context).size.width >= 600;

    final screens = const [
      HomeScreen(),
      ProductsScreen(),
      BillingScreen(),
      OthersScreen(),
    ];

    return Scaffold(
      body: Row(
        children: [
          if (isWideScreen)
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                if (index == 2) {
                  // Add Order selected - open form instead of changing screen
                  _showAddOrderScreen(context);
                } else {
                  ref.read(navigationIndexProvider.notifier).state = index;
                }
              },
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2),
                  label: Text('Products'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.add_circle_outline),
                  selectedIcon: Icon(Icons.add_circle),
                  label: Text('Add Order'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: Text('Billing'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.more_horiz),
                  selectedIcon: Icon(Icons.more_horiz),
                  label: Text('Others'),
                ),
              ],
            ),
          Expanded(child: screens[_getScreenIndex(currentIndex, isWideScreen)]),
        ],
      ),
      bottomNavigationBar: isWideScreen
          ? null
          : BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavBarItem(
                    context,
                    ref,
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home,
                    label: 'Home',
                    index: 0,
                    currentIndex: currentIndex,
                  ),
                  _buildNavBarItem(
                    context,
                    ref,
                    icon: Icons.inventory_2_outlined,
                    selectedIcon: Icons.inventory_2,
                    label: 'Products',
                    index: 1,
                    currentIndex: currentIndex,
                  ),
                  const SizedBox(width: 48), // Space for FAB
                  _buildNavBarItem(
                    context,
                    ref,
                    icon: Icons.receipt_long_outlined,
                    selectedIcon: Icons.receipt_long,
                    label: 'Billing',
                    index: 2,
                    currentIndex: currentIndex,
                  ),
                  _buildNavBarItem(
                    context,
                    ref,
                    icon: Icons.more_horiz,
                    selectedIcon: Icons.more_horiz,
                    label: 'Others',
                    index: 3,
                    currentIndex: currentIndex,
                  ),
                ],
              ),
            ),
      floatingActionButton: isWideScreen
          ? null
          : FloatingActionButton(
              onPressed: () => _showAddOrderScreen(context),
              child: const Icon(Icons.add),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavBarItem(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    required int currentIndex,
  }) {
    final isSelected = currentIndex == index;
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => ref.read(navigationIndexProvider.notifier).state = index,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddOrderScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const OrderFormScreen()));
  }
}
