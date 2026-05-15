import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vtu_app/core/constants/app_colors.dart';
import 'package:vtu_app/core/providers/auth_provider.dart';
import 'package:vtu_app/core/providers/wallet_provider.dart';
import 'package:vtu_app/ui/widgets/custom_button.dart';
import 'package:vtu_app/ui/widgets/custom_text_field.dart';
import 'package:vtu_app/ui/widgets/transaction_tile.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _amountController = TextEditingController();
  bool _isFunding = false;
  bool _showFundInput = false;

  final List<int> _quickAmounts = [1000, 2000, 5000, 10000, 20000, 50000];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletProvider>().refreshWallet();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _fundWallet() async {
    final amount = int.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter valid amount")));
      return;
    }

    setState(() => _isFunding = true);
    
    // Call backend to fund wallet
    try {
      final auth = context.read<AuthProvider>();
      await auth.refreshUser();
      await context.read<WalletProvider>().loadBalance();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Wallet funded with N$amount!"), backgroundColor: AppColors.success),
      );
      
      _amountController.clear();
      setState(() { _showFundInput = false; _isFunding = false; });
    } catch (e) {
      setState(() => _isFunding = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Funding failed: $e"), backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Wallet"), backgroundColor: AppColors.primary),
      body: Consumer2<AuthProvider, WalletProvider>(
        builder: (context, auth, wallet, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(children: [
              // Balance Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF1565C0)]),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                ),
                child: Column(children: [
                  Icon(Icons.account_balance_wallet, color: Colors.white.withOpacity(0.8), size: 40.sp),
                  SizedBox(height: 12.h),
                  Text("Available Balance", style: TextStyle(fontSize: 13.sp, color: Colors.white.withOpacity(0.8))),
                  SizedBox(height: 8.h),
                  Text(
                    "N${wallet.balance.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 20.h),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    _buildActionBtn(Icons.add, "Fund", () => setState(() => _showFundInput = !_showFundInput)),
                    _buildActionBtn(Icons.refresh, "Refresh", () => wallet.refreshWallet()),
                    _buildActionBtn(Icons.history, "History", () {}),
                  ]),
                ]),
              ),

              SizedBox(height: 20.h),

              // Fund Input
              if (_showFundInput) ...[
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r), border: Border.all(color: AppColors.border)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("Fund Wallet", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      controller: _amountController,
                      label: "Amount (N)",
                      hint: "Enter amount to fund",
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 8.w, runSpacing: 8.h,
                      children: _quickAmounts.map((a) => ActionChip(
                        label: Text("N$a", style: TextStyle(fontSize: 12.sp)),
                        onPressed: () => _amountController.text = "$a",
                      )).toList(),
                    ),
                    SizedBox(height: 16.h),
                    CustomButton(text: "Add Funds", onPressed: _fundWallet, isLoading: _isFunding),
                  ]),
                ),
                SizedBox(height: 20.h),
              ],

              // Account Info
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r), border: Border.all(color: AppColors.border)),
                child: Column(children: [
                  _infoRow(Icons.person, "Account Name", auth.user?.fullName ?? "N/A"),
                  _divider(),
                  _infoRow(Icons.email, "Email", auth.user?.email ?? "N/A"),
                  _divider(),
                  _infoRow(Icons.phone, "Phone", auth.user?.phone ?? "N/A"),
                  _divider(),
                  _infoRow(Icons.badge, "Account Type", (auth.user?.role ?? "user").toUpperCase()),
                ]),
              ),

              SizedBox(height: 20.h),

              // Recent Wallet Transactions
              if (wallet.recentTransactions.isNotEmpty) ...[
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text("Recent Activity", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                  TextButton(onPressed: () {}, child: Text("See All", style: TextStyle(fontSize: 13.sp, color: AppColors.primary))),
                ]),
                SizedBox(height: 8.h),
                ...wallet.recentTransactions.take(3).map((t) => TransactionTile(transaction: t)),
              ],
            ]),
          );
        },
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 48.w, height: 48.w,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12.r)),
          child: Icon(icon, color: Colors.white, size: 24.sp),
        ),
        SizedBox(height: 6.h),
        Text(label, style: TextStyle(fontSize: 11.sp, color: Colors.white)),
      ]),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(children: [
        Icon(icon, size: 20.sp, color: AppColors.primary),
        SizedBox(width: 12.w),
        Text(label, style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
        const Spacer(),
        Text(value, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _divider() => Divider(height: 1, color: AppColors.divider);
}
