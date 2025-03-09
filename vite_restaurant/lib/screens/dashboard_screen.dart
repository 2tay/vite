import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../providers/order_provider.dart';
import '../providers/table_provider.dart';
import '../theme/colors.dart';
import '../widgets/stat_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh dashboard data when screen loads
    Future.microtask(() {
      Provider.of<DashboardProvider>(context, listen: false).refreshDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Provider.of<DashboardProvider>(context, listen: false)
            .refreshDashboard(),
        child: Consumer3<DashboardProvider, OrderProvider, TableProvider>(
          builder:
              (context, dashboardProvider, orderProvider, tableProvider, _) {
            if (dashboardProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeHeader(),
                  const SizedBox(height: 24),
                  _buildStatisticsSection(
                      dashboardProvider, orderProvider, tableProvider),
                  const SizedBox(height: 24),
                  _buildActiveOrdersSection(orderProvider),
                  const SizedBox(height: 24),
                  _buildPopularItemsSection(dashboardProvider),
                  const SizedBox(height: 24),
                  _buildQuickActionsSection(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Card(
      elevation: 2,
      color: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Last updated: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(
    DashboardProvider dashboardProvider,
    OrderProvider orderProvider,
    TableProvider tableProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Statistics',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            StatCard(
              title: 'Orders',
              value: dashboardProvider.todayOrdersCount.toString(),
              icon: Icons.receipt_long,
              color: AppColors.primary,
              onTap: () {
                // Navigate to Orders tab
              },
            ),
            StatCard(
              title: 'Revenue',
              value: '\$${dashboardProvider.todayRevenue.toStringAsFixed(2)}',
              icon: Icons.attach_money,
              color: AppColors.success,
              onTap: () {
                // Show revenue details
              },
            ),
            StatCard(
              title: 'Active Tables',
              value: tableProvider.occupiedTablesCount.toString(),
              icon: Icons.table_bar,
              color: AppColors.warning,
              onTap: () {
                // Navigate to Tables tab
              },
            ),
            StatCard(
              title: 'Orders Preparing',
              value: /*orderProvider.preparingOrdersCount.toString()*/ '10',
              icon: Icons.restaurant,
              color: AppColors.orderPreparing,
              onTap: () {
                // Navigate to active orders
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveOrdersSection(OrderProvider orderProvider) {
    final activeOrders = orderProvider.activeOrders.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Active Orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to Orders tab
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (activeOrders.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No active orders at the moment',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activeOrders.length,
            itemBuilder: (context, index) {
              final order = activeOrders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getOrderStatusColor(order.status),
                    child: Text(
                      'T${order.tableId}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text('Order #${order.id}'),
                  subtitle: Text(
                      '${order.items.length} items • \$${order.totalAmount.toStringAsFixed(2)}'),
                  trailing: Chip(
                    label: Text(
                      order.status.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: _getOrderStatusColor(order.status),
                  ),
                  onTap: () {
                    // Navigate to order details
                  },
                ),
              );
            },
          ),
      ],
    );
  }

  Color _getOrderStatusColor(var status) {
    switch (status) {
      case 'received':
        return AppColors.orderReceived;
      case 'preparing':
        return AppColors.orderPreparing;
      case 'ready':
        return AppColors.orderReady;
      case 'delivered':
        return AppColors.orderDelivered;
      case 'cancelled':
        return AppColors.orderCancelled;
      default:
        return AppColors.gray500;
    }
  }

  Widget _buildPopularItemsSection(DashboardProvider dashboardProvider) {
    final popularItems = dashboardProvider.popularItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Items',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: popularItems.length,
            itemBuilder: (context, index) {
              final item = popularItems[index];
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 16),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.gray300,
                          image: item.imageUrl != null
                              ? DecorationImage(
                                  image: AssetImage(item.imageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: item.imageUrl == null
                            ? const Center(
                                child:
                                    Icon(Icons.restaurant, color: Colors.white),
                              )
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionButton(
              icon: Icons.add_shopping_cart,
              label: 'New Order',
              color: AppColors.primary,
              onTap: () {
                // Navigate to create order
              },
            ),
            _buildActionButton(
              icon: Icons.qr_code,
              label: 'Scan QR',
              color: AppColors.info,
              onTap: () {
                // Open QR scanner
              },
            ),
            _buildActionButton(
              icon: Icons.restaurant_menu,
              label: 'Menu',
              color: AppColors.secondary,
              onTap: () {
                // Navigate to menu
              },
            ),
            _buildActionButton(
              icon: Icons.table_bar,
              label: 'Tables',
              color: AppColors.tableAvailable,
              onTap: () {
                // Navigate to tables
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
