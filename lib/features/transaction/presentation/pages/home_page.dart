import 'package:expense_manager/features/transaction/presentation/pages/add_category_page.dart';
import 'package:expense_manager/features/transaction/presentation/pages/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/currency_formatter.dart';
import '../../../../core/themes/app_theme.dart';
import '../../../../core/utils/session_service.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/shimmer.dart';
import '../widgets/sync_fab.dart';
import '../widgets/transaction_card.dart';
import 'add_transaction_page.dart';
import 'category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final _pages = const [_DashboardTab(), TransactionsPage(), CategoryPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _pages[_currentIndex],
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'add',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddTransactionPage(),
                    ),
                  ),
                  backgroundColor: AppTheme.primary,
                  child: const Icon(Icons.add, color: Colors.white),
                ),

                FloatingActionButton(
                  heroTag: 'Cat',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddCategoryPage()),
                  ),
                  backgroundColor: AppTheme.primary,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
                const SizedBox(height: 12),
                const SyncFab(),
              ],
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor: Colors.white,
        elevation: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Categories',
          ),
        ],
      ),
    );
  }
}

class _DashboardTab extends StatefulWidget {
  const _DashboardTab();

  @override
  State<_DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<_DashboardTab> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadUser();
  }

  String nickname = '';

  Future<void> loadUser() async {
    final name = await SessionService.getNickname();

    setState(() {
      nickname = name;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<DashboardBloc>().add(const LoadDashboard());
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '👋 Welcome, $nickname',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSummaryCard(context),
                    const SizedBox(height: 24),
                    _buildRecentHeader(context),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            _buildRecentList(),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  // Widget _buildHeader(BuildContext context, String nickname) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'Good ${_greeting()},',
  //             style: TextStyle(
  //                 color: AppTheme.textSecondary, fontSize: 14),
  //           ),
  //           const SizedBox(height: 2),
  //           Text(
  //             now,
  //             style: const TextStyle(
  //               color: AppTheme.textPrimary,
  //               fontSize: 20,
  //               fontWeight: FontWeight.w700,
  //             ),
  //           ),
  //         ],
  //       ),
  //       Container(
  //         width: 44,
  //         height: 44,
  //         decoration: BoxDecoration(
  //           color: AppTheme.primary.withOpacity(0.1),
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         child: const Icon(Icons.notifications_outlined,
  //             color: AppTheme.primary),
  //       ),
  //     ],
  //   );
  // }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  Widget _buildSummaryCard(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading || state is DashboardInitial) {
          return const ShimmerSummaryCard();
        }

        if (state is DashboardError) {
          return Text(state.message);
        }

        final stats = (state as DashboardLoaded).stats;

        const monthlyLimit = 10000.0;

        final spent = stats.totalExpense;

        final remaining = monthlyLimit - spent;

        final progress = (spent / monthlyLimit).clamp(0.0, 1.0);

        return Column(
          children: [
            /// INCOME + EXPENSE
            Row(
              children: [
                /// INCOME
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0B7A00), Color(0xFF00A000)],
                      ),

                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          'Total Income',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),

                        const SizedBox(height: 18),

                        Row(
                          children: [
                            const Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: Text(
                                CurrencyFormatter.format(stats.totalIncome),

                                overflow: TextOverflow.ellipsis,

                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                /// EXPENSE
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF870000), Color(0xFFD50000)],
                      ),

                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          'Total Expense',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),

                        const SizedBox(height: 18),

                        Row(
                          children: [
                            const Icon(Icons.arrow_upward, color: Colors.white),

                            const SizedBox(width: 8),

                            Expanded(
                              child: Text(
                                CurrencyFormatter.format(stats.totalExpense),

                                overflow: TextOverflow.ellipsis,

                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// MONTHLY LIMIT CARD
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.black26,

                borderRadius: BorderRadius.circular(18),

                border: Border.all(color: Colors.white70),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    'MONTHLY LIMIT',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Text(
                        CurrencyFormatter.format(spent),

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        '/ ${CurrencyFormatter.format(monthlyLimit)}',

                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),

                    child: LinearProgressIndicator(
                      value: progress,

                      minHeight: 8,

                      backgroundColor: Colors.white24,

                      valueColor: const AlwaysStoppedAnimation(Colors.green),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    '${((remaining / monthlyLimit) * 100).clamp(0, 100).toInt()}% Remaining',

                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecentHeader(BuildContext context) {
    return const Text(
      'Recent Transactions',
      style: TextStyle(
        color: AppTheme.surface,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildRecentList() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading || state is DashboardInitial) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ShimmerList(itemCount: 5),
            ),
          );
        }
        if (state is DashboardLoaded) {
          final txns = state.stats.recentTransactions;
          if (txns.isEmpty) {
            return const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    'No transactions yet',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
              ),
            );
          }
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList.separated(
              itemCount: txns.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => TransactionCard(txn: txns[i]),
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color iconColor;

  const _SummaryTile({
    required this.label,
    required this.amount,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              CurrencyFormatter.formatCompact(amount),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
