import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vtu_app/core/constants/app_colors.dart';
import 'package:vtu_app/core/providers/vtu_provider.dart';
import 'package:vtu_app/core/models/transaction.dart';
import 'package:vtu_app/ui/widgets/transaction_tile.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String? _selectedFilter;
  int _page = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  final List<String> _filters = ["All", "Airtime", "Data", "TV", "Electricity", "Exam"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTransactions());
  }

  Future<void> _loadTransactions({bool refresh = false}) async {
    if (refresh) {
      setState(() { _page = 1; _hasMore = true; });
    }
    
    final vtu = context.read<VTUProvider>();
    String? serviceType;
    if (_selectedFilter != null && _selectedFilter != "All") {
      serviceType = _selectedFilter!.toLowerCase();
    }
    
    await vtu.loadTransactions(page: _page, serviceType: serviceType);
    setState(() { _isLoadingMore = false; });
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() { _isLoadingMore = true; _page++; });
    await _loadTransactions();
  }

  Color _getFilterColor(String filter) {
    switch (filter) {
      case "Airtime": return AppColors.mtn;
      case "Data": return AppColors.airtel;
      case "TV": return AppColors.secondary;
      case "Electricity": return AppColors.warning;
      case "Exam": return AppColors.info;
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction History"),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadTransactions(refresh: true),
          ),
        ],
      ),
      body: Column(children: [
        // Filter chips
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final sel = _selectedFilter == filter || (filter == "All" && _selectedFilter == null);
                final color = _getFilterColor(filter);
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (filter == "All") {
                          _selectedFilter = null;
                        } else {
                          _selectedFilter = filter;
                        }
                      });
                      _loadTransactions(refresh: true);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: sel ? color : color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(filter, style: TextStyle(
                        color: sel ? Colors.white : color,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      )),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Transactions list
        Expanded(
          child: Consumer<VTUProvider>(
            builder: (context, vtu, child) {
              if (vtu.isLoadingTransactions && vtu.transactions.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (vtu.transactions.isEmpty) {
                return Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.receipt_long, size: 64.sp, color: AppColors.textLight),
                    SizedBox(height: 16.h),
                    Text("No transactions found", style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                    SizedBox(height: 4.h),
                    Text("Your transactions will appear here", style: TextStyle(fontSize: 13.sp, color: AppColors.textLight)),
                  ]),
                );
              }

              // Group by date
              final grouped = <String, List<Transaction>>{};
              for (var t in vtu.transactions) {
                final date = DateFormat('dd MMMM yyyy').format(t.createdAt);
                grouped.putIfAbsent(date, () => []).add(t);
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 100) {
                    _loadMore();
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: grouped.length,
                  itemBuilder: (context, index) {
                    final date = grouped.keys.elementAt(index);
                    final transactions = grouped[date]!;
                    
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      // Date header
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.h, top: index > 0 ? 16.h : 0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(date, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.primary)),
                        ),
                      ),
                      // Transactions for this date
                      ...transactions.map((t) => TransactionTile(transaction: t)),
                    ]);
                  },
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
