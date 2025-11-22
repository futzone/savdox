import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:savdox/src/core/models/order_model/order.dart';
import 'package:savdox/src/core/repositories/order_repository.dart';

// Repository provider
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});

// Dashboard statistics model
class DashboardStats {
  final double totalSales;
  final double totalProfit;
  final double todaySales;
  final int orderCount;

  DashboardStats({
    required this.totalSales,
    required this.totalProfit,
    required this.todaySales,
    required this.orderCount,
  });
}

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final repository = ref.watch(orderRepositoryProvider);

  final totalSales = await repository.getTotalSales();
  final totalProfit = await repository.getTotalProfit();
  final todaySales = await repository.getTodaySales();
  final orderCount = await repository.getActiveOrdersCount();

  return DashboardStats(
    totalSales: totalSales,
    totalProfit: totalProfit,
    todaySales: todaySales,
    orderCount: orderCount,
  );
});

class RecentOrdersNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  final OrderRepository _repository;
  int _currentPage = 0;
  final int _pageSize = 20;
  bool _hasMore = true;

  RecentOrdersNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    if (!_hasMore) return;

    state = const AsyncValue.loading();

    try {
      final orders = await _repository.getRecentOrders(
        offset: _currentPage * _pageSize,
        limit: _pageSize,
      );

      if (orders.length < _pageSize) {
        _hasMore = false;
      }

      state = AsyncValue.data(orders);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;

    final currentOrders = state.value ?? [];

    try {
      _currentPage++;
      final newOrders = await _repository.getRecentOrders(
        offset: _currentPage * _pageSize,
        limit: _pageSize,
      );

      if (newOrders.length < _pageSize) {
        _hasMore = false;
      }

      state = AsyncValue.data([...currentOrders, ...newOrders]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void refresh() {
    _currentPage = 0;
    _hasMore = true;
    loadOrders();
  }

  bool get hasMore => _hasMore;
}

final recentOrdersProvider =
    StateNotifierProvider<RecentOrdersNotifier, AsyncValue<List<Order>>>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return RecentOrdersNotifier(repository);
});

// Sales chart data model
class SalesChartData {
  final DateTime date;
  final double amount;

  SalesChartData({required this.date, required this.amount});
}

// Time period for chart
enum ChartPeriod { week, month, year }

// Provider for sales chart data
final chartPeriodProvider = StateProvider<ChartPeriod>((ref) => ChartPeriod.week);

final salesChartDataProvider = FutureProvider<List<SalesChartData>>((ref) async {
  final repository = ref.watch(orderRepositoryProvider);
  final period = ref.watch(chartPeriodProvider);

  final now = DateTime.now();
  DateTime startDate;

  switch (period) {
    case ChartPeriod.week:
      startDate = now.subtract(const Duration(days: 7));
      break;
    case ChartPeriod.month:
      startDate = now.subtract(const Duration(days: 30));
      break;
    case ChartPeriod.year:
      startDate = now.subtract(const Duration(days: 365));
      break;
  }

  final salesByDate = await repository.getSalesByDate(
    startDate: startDate,
    endDate: now,
  );

  return salesByDate.entries
      .map((e) => SalesChartData(date: e.key, amount: e.value))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));
});
