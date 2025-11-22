import 'package:isar/isar.dart';
import 'package:savdox/src/core/database/isar_database.dart';
import 'package:savdox/src/core/models/order_model/order.dart';

class OrderRepository {
  final Isar _isar = IsarDatabase.instance.isar;

  /// Fetch recent orders with pagination
  Future<List<Order>> getRecentOrders({
    int offset = 0,
    int limit = 20,
  }) async {
    return await _isar.orders
        .where()
        .filter()
        .statusEqualTo(Order.activeStatus)
        .sortByCreatedDesc()
        .offset(offset)
        .limit(limit)
        .findAll();
  }

  /// Get total count of active orders
  Future<int> getActiveOrdersCount() async {
    return await _isar.orders
        .where()
        .filter()
        .statusEqualTo(Order.activeStatus)
        .count();
  }

  /// Calculate total sales (sum of finalSum for active orders)
  Future<double> getTotalSales() async {
    final orders = await _isar.orders
        .where()
        .filter()
        .statusEqualTo(Order.activeStatus)
        .findAll();

    return orders.fold<double>(0.0, (sum, order) => sum + order.finalSum);
  }

  /// Calculate total profit (difference between finalSum and cost)
  /// Note: This is a simplified calculation. Adjust based on your business logic.
  Future<double> getTotalProfit() async {
    final orders = await _isar.orders
        .where()
        .filter()
        .statusEqualTo(Order.activeStatus)
        .findAll();

    // For now, assuming 30% profit margin
    // You can adjust this based on actual product costs
    return orders.fold<double>(0.0, (sum, order) => sum + (order.finalSum * 0.3));
  }

  /// Get orders grouped by date for charts
  Future<Map<DateTime, double>> getSalesByDate({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final orders = await _isar.orders
        .where()
        .filter()
        .statusEqualTo(Order.activeStatus)
        .createdBetween(startDate, endDate)
        .findAll();

    final Map<DateTime, double> salesByDate = {};

    for (final order in orders) {
      final date = DateTime(
        order.created.year,
        order.created.month,
        order.created.day,
      );

      salesByDate[date] = (salesByDate[date] ?? 0.0) + order.finalSum;
    }

    return salesByDate;
  }

  /// Get today's sales
  Future<double> getTodaySales() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final orders = await _isar.orders
        .where()
        .filter()
        .statusEqualTo(Order.activeStatus)
        .createdBetween(startOfDay, endOfDay)
        .findAll();

    return orders.fold<double>(0.0, (sum, order) => sum + order.finalSum);
  }

  /// Get order by ID
  Future<Order?> getOrderById(int id) async {
    return await _isar.orders.get(id);
  }

  /// Create a new order
  Future<int> createOrder(Order order) async {
    return await _isar.writeTxn(() async {
      return await _isar.orders.put(order);
    });
  }

  /// Update an existing order
  Future<void> updateOrder(Order order) async {
    await _isar.writeTxn(() async {
      await _isar.orders.put(order);
    });
  }

  /// Delete an order (soft delete by changing status)
  Future<void> deleteOrder(int id) async {
    final order = await getOrderById(id);
    if (order != null) {
      order.status = Order.deletedStatus;
      order.deleted = DateTime.now();
      await updateOrder(order);
    }
  }
}
