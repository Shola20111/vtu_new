import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vtu_app/core/constants/app_colors.dart';
import 'package:vtu_app/core/providers/auth_provider.dart';
import 'package:vtu_app/core/providers/vtu_provider.dart';
import 'package:vtu_app/ui/widgets/custom_button.dart';
import 'package:vtu_app/ui/widgets/custom_text_field.dart';
import 'package:vtu_app/ui/widgets/success_dialog.dart';
import 'package:vtu_app/utils/validators.dart';

class AirtimeScreen extends StatefulWidget {
  const AirtimeScreen({super.key});

  @override
  State<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends State<AirtimeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _selectedNetwork = 'MTN';
  double _selectedAmount = 100;
  bool _isLoading = false;

  final List<String> _networks = ['MTN', 'Airtel', 'Glo', '9mobile'];
  final List<double> _amounts = [100, 200, 500, 1000, 2000, 5000];

  final Map<String, Color> _networkColors = {
    'MTN': const Color(0xFFFFCC00),
    'Airtel': const Color(0xFFED1C24),
    'Glo': const Color(0xFF4AA53E),
    '9mobile': const Color(0xFF00853E),
  };

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handlePurchase() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    if ((authProvider.user?.walletBalance ?? 0) < _selectedAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insufficient wallet balance'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final vtuProvider = context.read<VTUProvider>();
    final success = await vtuProvider.purchaseAirtime(
      network: _selectedNetwork,
      phone: _phoneController.text.trim(),
      amount: _selectedAmount,
      requestId: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      await authProvider.refreshUser();
      showDialog(
        context: context,
        builder: (_) => SuccessDialog(
          title: 'Airtime Purchase Successful',
          transaction: vtuProvider.lastTransaction?.transaction,
          network: _selectedNetwork,
        ),
      );
      _phoneController.clear();
      vtuProvider.clearLastTransaction();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vtuProvider.error ?? 'Purchase failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Airtime'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Network',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12.h),
              Row(
                children: _networks.map((network) {
                  final isSelected = _selectedNetwork == network;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedNetwork = network),
                      child: Container(
                        margin: EdgeInsets.only(right: 8.w),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _networkColors[network]
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: _networkColors[network] ?? AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          network,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 24.h),
              Text(
                'Select Amount',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12.h),
              DropdownButtonFormField<double>(
                value: _selectedAmount,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                items: _amounts.map((a) {
                  return DropdownMenuItem(
                    value: a,
                    child: Text('N${a.toInt()}'),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedAmount = v!),
              ),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                children: [100, 200, 500, 1000].map((a) {
                  return ActionChip(
                    label: Text('N$a'),
                    onPressed: () =>
                        setState(() => _selectedAmount = a.toDouble()),
                  );
                }).toList(),
              ),
              SizedBox(height: 24.h),
              CustomTextField(
                controller: _phoneController,
                label: 'Phone Number',
                hint: 'Enter phone number',
                keyboardType: TextInputType.phone,
                validator: Validators.phone,
              ),
              SizedBox(height: 24.h),
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Wallet Balance:',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          'N${auth.user?.walletBalance.toStringAsFixed(2) ?? "0.00"}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 32.h),
              CustomButton(
                text: 'Purchase Airtime',
                onPressed: _handlePurchase,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
