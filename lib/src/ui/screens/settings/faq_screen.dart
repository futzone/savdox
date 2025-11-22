import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFaqItem(
            'How do I add a new product?',
            'Go to the Products screen and tap the + button in the top right corner. Fill in the product details and tap Save.',
          ),
          _buildFaqItem(
            'How do I create an order?',
            'From the Home screen, tap the + button to start a new order. Select products, adjust quantities, and complete the order.',
          ),
          _buildFaqItem(
            'How do I backup my data?',
            'Go to Settings > Backup to export your database. You can also import a previously exported backup from this screen.',
          ),
          _buildFaqItem(
            'How do I change the app theme?',
            'Go to Settings > Theme and select your preferred theme (Light, Dark, or System).',
          ),
          _buildFaqItem(
            'How do I manage customers?',
            'Navigate to Others > Customers to view, add, or edit customer information.',
          ),
          _buildFaqItem(
            'Can I search for products?',
            'Yes! Use the search bar at the top of the Products screen to quickly find products by name or barcode.',
          ),
          _buildFaqItem(
            'How do I view sales statistics?',
            'The Home screen displays your sales statistics, including charts and recent orders.',
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(padding: const EdgeInsets.all(16.0), child: Text(answer)),
        ],
      ),
    );
  }
}
