import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vtu_app/core/constants/app_colors.dart';
import 'package:vtu_app/core/providers/auth_provider.dart';
import 'package:vtu_app/core/providers/vtu_provider.dart';
import 'package:vtu_app/core/models/data_plan.dart';
import 'package:vtu_app/ui/widgets/custom_button.dart';
import 'package:vtu_app/ui/widgets/custom_text_field.dart';
import 'package:vtu_app/ui/widgets/success_dialog.dart';
import 'package:vtu_app/utils/validators.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});
  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _selectedNetwork = "MTN";
  DataPlan? _selectedPlan;
  bool _isLoading = false;
  List<DataPlan> _dataPlans = [];
  final List<String> _networks = ["MTN", "Airtel", "Glo", "9mobile"];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _loadPlans());
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadPlans() async {
    final vtu = context.read<VTUProvider>();
    await vtu.loadDataPlans(_selectedNetwork);
    if (mounted) setState(() => _dataPlans = List.from(vtu.dataPlans));
  }

  Future<void> _buy() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPlan == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select a plan")));
      return;
    }
    final auth = context.read<AuthProvider>();
    if ((auth.user?.walletBalance ?? 0) < _selectedPlan!.price) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Insufficient balance")));
      return;
    }
    setState(() => _isLoading = true);
    final vtu = context.read<VTUProvider>();
    final ok = await vtu.purchaseData(
      network: _selectedNetwork,
      phone: _phoneController.text.trim(),
      dataPlan: _selectedPlan!.code,
      requestId: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (ok) {
      await auth.refreshUser();
      showDialog(context: context, builder: (_) => SuccessDialog(title: "Data Purchase Successful", transaction: vtu.lastTransaction?.transaction, network: _selectedNetwork));
      _phoneController.clear();
      setState(() => _selectedPlan = null);
      vtu.clearLastTransaction();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vtu.error ?? "Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vtu = context.watch<VTUProvider>();
    if (_dataPlans.isEmpty && vtu.dataPlans.isNotEmpty) {
      _dataPlans = List.from(vtu.dataPlans);
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Buy Data"), backgroundColor: AppColors.primary),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Select Network", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 12.h),
            Row(children: _networks.map((net) {
              final sel = _selectedNetwork == net;
              return Expanded(child: GestureDetector(
                onTap: () {
                  setState(() { _selectedNetwork = net; _selectedPlan = null; _dataPlans = []; });
                  _loadPlans();
                },
                child: Container(
                  margin: EdgeInsets.only(right: 8.w), padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: sel ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: sel ? AppColors.primary : AppColors.border, width: 2),
                  ),
                  child: Text(net, textAlign: TextAlign.center, style: TextStyle(color: sel ? Colors.white : Colors.black87, fontWeight: FontWeight.w600, fontSize: 12.sp)),
                ),
              ));
            }).toList()),
            SizedBox(height: 24.h),
            Text("Select Data Plan", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 12.h),
            if (_dataPlans.isEmpty)
              Container(height: 150.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)), child: const Center(child: CircularProgressIndicator()))
            else
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.border)),
                child: Column(children: _dataPlans.map((plan) {
                  final sel = _selectedPlan?.code == plan.code;
                  return InkWell(
                    onTap: () => setState(() => _selectedPlan = plan),
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(color: sel ? AppColors.primary.withOpacity(0.05) : null, border: Border(bottom: BorderSide(color: AppColors.divider))),
                      child: Row(children: [
                        Container(width: 24.w, height: 24.w, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: sel ? AppColors.primary : AppColors.border, width: 2)), child: sel ? Center(child: Container(width: 12.w, height: 12.w, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary))) : null),
                        SizedBox(width: 12.w),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(plan.name, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)), Text(plan.validity, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary))])),
                        Text(plan.formattedPrice, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ]),
                    ),
                  );
                }).toList()),
              ),
            SizedBox(height: 24.h),
            CustomTextField(controller: _phoneController, label: "Phone Number", hint: "Enter phone number", keyboardType: TextInputType.phone, validator: Validators.phone),
            SizedBox(height: 24.h),
            if (_selectedPlan != null) Container(padding: EdgeInsets.all(16.w), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(12.r)), child: Row(children: [const Icon(Icons.check_circle, color: AppColors.success), SizedBox(width: 12.w), Text("${_selectedPlan!.name}: ${_selectedPlan!.formattedPrice}", style: TextStyle(fontWeight: FontWeight.w600))])),
            SizedBox(height: 24.h),
            Consumer<AuthProvider>(builder: (_, auth, __) => Container(padding: EdgeInsets.all(16.w), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12.r)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Balance:", style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)), Text("N${auth.user?.walletBalance.toStringAsFixed(2) ?? "0.00"}", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.primary))]))),
            SizedBox(height: 32.h),
            CustomButton(text: "Buy Data", onPressed: _buy, isLoading: _isLoading),
          ]),
        ),
      ),
    );
  }
}
