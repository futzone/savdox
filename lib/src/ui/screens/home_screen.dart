import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:savdox/src/core/providers/home_providers.dart';
import 'package:savdox/src/ui/widgets/order_list_item.dart';
import 'package:savdox/src/ui/widgets/sales_chart.dart';
import 'package:savdox/src/ui/widgets/stat_card.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dashboardStats = ref.watch(dashboardStatsProvider);
    final recentOrders = ref.watch(recentOrdersProvider);
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final isWideScreen = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(dashboardStatsProvider);
              ref.read(recentOrdersProvider.notifier).refresh();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardStatsProvider);
          ref.read(recentOrdersProvider.notifier).refresh();
        },
        child: CustomScrollView(
          slivers: [
            // Statistics Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: dashboardStats.when(
                  data: (stats) {
                    return isWideScreen
                        ? Row(
                            children: [
                              Expanded(
                                child: StatCard(
                                  icon: Icons.attach_money,
                                  title: 'Total Sales',
                                  value: currencyFormat.format(stats.totalSales),
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: StatCard(
                                  icon: Icons.trending_up,
                                  title: 'Total Profit',
                                  value: currencyFormat.format(stats.totalProfit),
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: StatCard(
                                  icon: Icons.today,
                                  title: 'Today\'s Sales',
                                  value: currencyFormat.format(stats.todaySales),
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: StatCard(
                                  icon: Icons.shopping_cart,
                                  title: 'Total Orders',
                                  value: stats.orderCount.toString(),
                                  color: Colors.purple,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: StatCard(
                                      icon: Icons.attach_money,
                                      title: 'Total Sales',
                                      value: currencyFormat.format(stats.totalSales),
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: StatCard(
                                      icon: Icons.trending_up,
                                      title: 'Total Profit',
                                      value: currencyFormat.format(stats.totalProfit),
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: StatCard(
                                      icon: Icons.today,
                                      title: 'Today\'s Sales',
                                      value: currencyFormat.format(stats.todaySales),
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: StatCard(
                                      icon: Icons.shopping_cart,
                                      title: 'Total Orders',
                                      value: stats.orderCount.toString(),
                                      color: Colors.purple,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Error loading statistics',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Sales Chart
            // const SliverToBoxAdapter(
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 16.0),
            //     child: SalesChart(),
            //   ),
            // ),

            // Recent Orders Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Row(
                  children: [
                    Text(
                      'Recent Orders',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Navigate to all orders
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('View All'),
                    ),
                  ],
                ),
              ),
            ),

            // Recent Orders List
            recentOrders.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: theme.colorScheme.onSurfaceVariant
                                .withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No orders yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create your first order to get started',
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant
                                  .withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == orders.length) {
                        // Load more button
                        if (ref
                            .read(recentOrdersProvider.notifier)
                            .hasMore) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  ref
                                      .read(recentOrdersProvider.notifier)
                                      .loadMore();
                                },
                                icon: const Icon(Icons.expand_more),
                                label: const Text('Load More'),
                              ),
                            ),
                          );
                        }
                        return const SizedBox(height: 16);
                      }

                      return OrderListItem(
                        order: orders[index],
                        onTap: () {
                          // TODO: Navigate to order details
                        },
                      );
                    },
                    childCount: orders.length + 1,
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading orders',
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          ref.read(recentOrdersProvider.notifier).refresh();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
