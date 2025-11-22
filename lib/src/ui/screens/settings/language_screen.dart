import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/core/providers/settings_providers.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    final languages = [
      {'name': 'English', 'locale': const Locale('en')},
      {'name': 'العربية', 'locale': const Locale('ar')},
      {'name': 'Français', 'locale': const Locale('fr')},
      {'name': 'Español', 'locale': const Locale('es')},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Language')),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          final locale = language['locale'] as Locale;
          final isSelected = currentLocale?.languageCode == locale.languageCode;

          return ListTile(
            title: Text(language['name'] as String),
            trailing: isSelected
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            onTap: () {
              ref.read(localeProvider.notifier).state = locale;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Language changed to ${language['name']}'),
                  duration: const Duration(seconds: 2),
                ),
              );
              // Note: Full localization requires flutter_localizations package
              // and proper l10n setup. This is a placeholder implementation.
            },
          );
        },
      ),
    );
  }
}
