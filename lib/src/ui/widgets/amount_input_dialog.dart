import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AmountInputDialog extends HookWidget {
  final double initialAmount;
  final String title;

  const AmountInputDialog({
    super.key,
    required this.initialAmount,
    this.title = 'Enter Amount',
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialAmount.toString());
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          labelText: 'Amount',
          prefixText: '',
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => controller.clear(),
          ),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final value = double.tryParse(controller.text);
            if (value != null && value > 0) {
              Navigator.pop(context, value);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid amount')),
              );
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
