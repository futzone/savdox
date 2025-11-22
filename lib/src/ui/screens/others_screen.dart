import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/ui/screens/others/customers_screen.dart';
import 'package:savdox/src/ui/screens/others/employees_screen.dart';
import 'package:savdox/src/ui/screens/others/suppliers_screen.dart';
import 'package:savdox/src/ui/screens/settings/backup_screen.dart';
import 'package:savdox/src/ui/screens/settings/docs_screen.dart';
import 'package:savdox/src/ui/screens/settings/faq_screen.dart';
import 'package:savdox/src/ui/screens/settings/language_screen.dart';
import 'package:savdox/src/ui/screens/settings/theme_screen.dart';

class OthersScreen extends HookConsumerWidget {
  const OthersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Others')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            title: 'POS',
            items: [
              _MenuItem(
                icon: Icons.people,
                title: 'Customers',
                subtitle: 'Manage customers',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CustomersScreen()),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.badge,
                title: 'Employees',
                subtitle: 'Manage employees',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EmployeesScreen()),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.local_shipping,
                title: 'Suppliers',
                subtitle: 'Manage suppliers',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SuppliersScreen()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: 'Settings',
            items: [
              _MenuItem(
                icon: Icons.description,
                title: 'Documentation',
                subtitle: 'View docs',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DocsScreen()),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.help,
                title: 'FAQ',
                subtitle: 'Frequently asked questions',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FaqScreen()),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'Change language',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LanguageScreen()),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.backup,
                title: 'Backup',
                subtitle: 'Backup and restore data',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BackupScreen()),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.palette,
                title: 'Theme',
                subtitle: 'Change app theme',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ThemeScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<_MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Card(
          child: Column(
            children: items
                .map(
                  (item) => ListTile(
                    leading: Icon(item.icon),
                    title: Text(item.title),
                    subtitle: Text(item.subtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: item.onTap,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
