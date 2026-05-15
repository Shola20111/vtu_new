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

class TVScreen extends StatefulWidget {
  const TVScreen({super.key});
  @override
  State<TVScreen> createState() => _TVScreenState();
}

class _TVScreenState extends State<TVScreen> {
  final _formKey = GlobalKey<FormState>();
  final _smartcardController = TextEditingController();

  String _selectedProvider = "DSTV";
  String? _selectedPackage;
  bool _isLoading = false;

  final Map<String, List<Map<String, dynamic>>> _packages = {
    "DSTV": [
      {"name": "Premium", "price": 24500},
      {"name": "Compact Plus", "price": 16600},
      {"name": "Compact", "price": 10500},
      {"name": "Family", "price": 6200},
      {"name": "Access", "price": 2900},
    ],
    "GOTV": [
      {"name": "Supa Plus", "price": 7600},
      {"name": "Supa", "price": 5500},
      {"name": "Max", "price": 3900},
      {"name": "Jolli", "price": 2400},
      {"name": "Jinja", "price": 1600},
    ],
    "Startimes": [
      {"name": "Super", "price": 4900},
      {"name": "Classic", "price": 2600},
      {"name": "Basic", "price": 1300},
    ],
  };

  final Map<String, Color> _providerColors = {
    "DSTV": const Color(0xFF1A73E8),
    "GOTV": const Color(0xFF4CAF50),
    "Startimes": const Color(0xFFFF9800),
  };

  @override
  void dispose() {
    _smartcardController.dispose();
    super.dispose();
  }

  double? get _selectedPrice {
    if (_selectedPackage == null || _selectedProvider.isEmpty) return null;
    final packages = _packages[_selectedProvider] ?? [];
    try {
      return packages.firstWhere((p) => p["name"] == _selectedPackage)["price"];
    } catch (_) {
      return null;
    }
  }

  Future<void> _buy() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPackage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select a package")));
      return;
    }
    if (_selectedPrice == null) return;

    final auth = context.read<AuthProvider>();
    if ((auth.user?.walletBalance ?? 0) < _selectedPrice!) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Insufficient balance")));
      return;
    }

    setState(() => _isLoading = true);
    final vtu = context.read<VTUProvider>();
    final ok = await vtu.purchaseTV(
      provider: _selectedProvider,
      smartcardNumber: _smartcardController.text.trim(),
      package: _selectedPackage!,
      requestId: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (ok) {
      await auth.refreshUser();
      showDialog(
        context: context,
        builder: (_) => SuccessDialog(
          title: "TV Subscription Successful",
          transaction: vtu.lastTransaction?.transaction,
        ),
      );
      _smartcardController.clear();
      setState(() => _selectedPackage = null);
      vtu.clearLastTransaction();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vtu.error ?? "Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TV Subscription"), backgroundColor: AppColors.primary),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Provider Selection
            Text("Select Provider", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 12.h),
            Row(
              children: _packages.keys.map((prov) {
                final sel = _selectedProvider == prov;
                final color = _providerColors[prov] ?? AppColors.primary;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() { _selectedProvider = prov; _selectedPackage = null; }),
                    child: Container(
                      margin: EdgeInsets.only(right: 8.w),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: sel ? color : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: color, width: 2),
                      ),
                      child: Column(children: [
                        Icon(Icons.tv, color: sel ? Colors.white : color, size: 24.sp),
                        SizedBox(height: 4.h),
                        Text(prov, textAlign: TextAlign.center,
                          style: TextStyle(color: sel ? Colors.white : color, fontWeight: FontWeight.w700, fontSize: 13.sp)),
                      ]),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 24.h),

            // Package Selection
            Text("Select Package", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.border)),
              child: Column(
                children: (_packages[_selectedProvider] ?? []).map((pkg) {
                  final sel = _selectedPackage == pkg["name"];
                  final price = (pkg["price"] as int);
                  return InkWell(
                    onTap: () => setState(() => _selectedPackage = pkg["name"]),
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.primary.withOpacity(0.05) : null,
                        border: Border(bottom: BorderSide(color: AppColors.divider)),
                      ),
                      child: Row(children: [
                        Container(
                          width: 24.w, height: 24.w,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: sel ? AppColors.primary : AppColors.border, width: 2)),
                          child: sel ? Center(child: Container(width: 12.w, height: 12.w, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary))) : null,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(child: Text(pkg["name"], style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600))),
                        Text("N$price", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ]),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 24.h),

            // Smartcard Number
            CustomTextField(
              controller: _smartcardController,
              label: "Smartcard Number",
              hint: "Enter IUC number",
              keyboardType: TextInputType.number,
              validator: (v) => Validators.required(v, "Smartcard number"),
            ),

            SizedBox(height: 24.h),

            // Selected Package Summary
            if (_selectedPackage != null && _selectedPrice != null)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(12.r)),
                child: Row(children: [
                  const Icon(Icons.check_circle, color: AppColors.success),
                  SizedBox(width: 12.w),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("$_selectedProvider $_selectedPackage", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp)),
                    Text("Amount: N$_selectedPrice", style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp)),
                  ])),
                ]),
              ),

            SizedBox(height: 24.h),

            // Wallet Balance
            Consumer<AuthProvider>(
              builder: (_, auth, __) => Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12.r)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text("Balance:", style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
                  Text("N${auth.user?.walletBalance.toStringAsFixed(2) ?? "0.00"}", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ]),
              ),
            ),

            SizedBox(height: 32.h),

            CustomButton(text: "Subscribe Now", onPressed: _buy, isLoading: _isLoading),
            SizedBox(height: 16.h),
          ]),
        ),
      ),
    );
  }
}
