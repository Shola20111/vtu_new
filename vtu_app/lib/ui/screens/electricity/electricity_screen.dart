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

class ElectricityScreen extends StatefulWidget {
  const ElectricityScreen({super.key});
  @override
  State<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends State<ElectricityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _meterNumberController = TextEditingController();
  final _amountController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _customerAddressController = TextEditingController();

  String _selectedDisco = "Ikeja Electric";
  String _selectedMeterType = "Prepaid";
  bool _isLoading = false;

  final List<Map<String, String>> _discos = [
    {"name": "Ikeja Electric", "code": "ikeja"},
    {"name": "Eko Electric", "code": "eko"},
    {"name": "Ibadan Electric", "code": "ibadan"},
    {"name": "Abuja Electric", "code": "abuja"},
    {"name": "Port Harcourt Electric", "code": "ph"},
    {"name": "Kano Electric", "code": "kano"},
    {"name": "Jos Electric", "code": "jos"},
    {"name": "Kaduna Electric", "code": "kaduna"},
  ];

  final List<String> _meterTypes = ["Prepaid", "Postpaid"];

  final List<String> _quickAmounts = ["1000", "2000", "5000", "10000"];

  @override
  void dispose() {
    _meterNumberController.dispose();
    _amountController.dispose();
    _customerNameController.dispose();
    _customerAddressController.dispose();
    super.dispose();
  }

  Future<void> _buy() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter a valid amount")));
      return;
    }

    final auth = context.read<AuthProvider>();
    if ((auth.user?.walletBalance ?? 0) < amount) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Insufficient balance")));
      return;
    }

    final disco = _discos.firstWhere((d) => d["name"] == _selectedDisco);
    setState(() => _isLoading = true);

    final vtu = context.read<VTUProvider>();
    final ok = await vtu.purchaseElectricity(requestId: DateTime.now().millisecondsSinceEpoch.toString(), 
      disco: disco["code"]!,
      meterNumber: _meterNumberController.text.trim(),
      amount: amount,
      meterType: _selectedMeterType.toLowerCase(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (ok) {
      await auth.refreshUser();
      showDialog(
        context: context,
        builder: (_) => SuccessDialog(
          title: "Electricity Token Purchased",
          transaction: vtu.lastTransaction?.transaction,
          token: vtu.lastTransaction?.transaction?.token,
          units: vtu.lastTransaction?.transaction?.units,
        ),
      );
      _meterNumberController.clear();
      _amountController.clear();
      vtu.clearLastTransaction();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vtu.error ?? "Purchase failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buy Electricity"), backgroundColor: AppColors.primary),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Disco Selection
            Text("Select Disco", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.border)),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedDisco,
                  isExpanded: true,
                  items: _discos.map((d) => DropdownMenuItem(value: d["name"], child: Text(d["name"]!, style: TextStyle(fontSize: 14.sp)))).toList(),
                  onChanged: (v) => setState(() => _selectedDisco = v!),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Meter Type
            Text("Meter Type", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 12.h),
            Row(
              children: _meterTypes.map((type) {
                final sel = _selectedMeterType == type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedMeterType = type),
                    child: Container(
                      margin: EdgeInsets.only(right: 8.w),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: sel ? AppColors.primary : AppColors.border, width: 2),
                      ),
                      child: Text(type, textAlign: TextAlign.center,
                        style: TextStyle(color: sel ? Colors.white : Colors.black87, fontWeight: FontWeight.w600, fontSize: 14.sp)),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 20.h),

            // Meter Number
            CustomTextField(
              controller: _meterNumberController,
              label: "Meter Number",
              hint: "Enter meter number",
              keyboardType: TextInputType.number,
              validator: (v) => Validators.required(v, "Meter number"),
            ),

            SizedBox(height: 20.h),

            // Amount
            CustomTextField(
              controller: _amountController,
              label: "Amount (N)",
              hint: "Enter amount",
              keyboardType: TextInputType.number,
              validator: (v) => Validators.required(v, "Amount"),
            ),

            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              children: _quickAmounts.map((a) => ActionChip(
                label: Text("N$a", style: TextStyle(fontSize: 12.sp)),
                onPressed: () => setState(() => _amountController.text = a),
              )).toList(),
            ),

            SizedBox(height: 20.h),

            // Optional fields
            CustomTextField(controller: _customerNameController, label: "Customer Name (Optional)", hint: "Enter customer name"),
            SizedBox(height: 20.h),
            CustomTextField(controller: _customerAddressController, label: "Customer Address (Optional)", hint: "Enter customer address", maxLines: 2),

            SizedBox(height: 24.h),

            // Wallet Balance
            Consumer<AuthProvider>(
              builder: (_, auth, __) => Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12.r)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text("Balance:", style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
                  Text("N${auth.user?.walletBalance.toStringAsFixed(2) ?? "0.00"}", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ]),
              ),
            ),

            SizedBox(height: 32.h),

            CustomButton(text: "Buy Electricity Token", onPressed: _buy, isLoading: _isLoading),
            SizedBox(height: 16.h),
          ]),
        ),
      ),
    );
  }
}
