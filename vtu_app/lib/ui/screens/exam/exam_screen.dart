import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vtu_app/core/constants/app_colors.dart';
import 'package:vtu_app/core/providers/auth_provider.dart';
import 'package:vtu_app/core/providers/vtu_provider.dart';
import 'package:vtu_app/ui/widgets/custom_button.dart';
import 'package:vtu_app/ui/widgets/success_dialog.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});
  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  String _selectedExam = "WAEC";
  int _quantity = 1;
  bool _isLoading = false;

  final Map<String, Map<String, dynamic>> _exams = {
    "WAEC": {
      "color": const Color(0xFF1A73E8),
      "icon": Icons.school,
      "price": 3500,
      "description": "West African Examinations Council",
      "scratchCard": "WAEC Scratch Card PIN",
    },
    "NECO": {
      "color": const Color(0xFF4CAF50),
      "icon": Icons.menu_book,
      "price": 2000,
      "description": "National Examinations Council",
      "scratchCard": "NECO Token PIN",
    },
    "JAMB": {
      "color": const Color(0xFFFF9800),
      "icon": Icons.library_books,
      "price": 5000,
      "description": "Joint Admissions and Matriculation Board",
      "scratchCard": "JAMB e-PIN",
    },
  };

  double get _pricePerUnit => (_exams[_selectedExam]?["price"] ?? 0).toDouble();
  double get _totalPrice => _pricePerUnit * _quantity;

  Future<void> _buy() async {
    final auth = context.read<AuthProvider>();
    if ((auth.user?.walletBalance ?? 0) < _totalPrice) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Insufficient balance")));
      return;
    }

    setState(() => _isLoading = true);
    final vtu = context.read<VTUProvider>();
    final ok = await vtu.purchaseExamPIN(
      examType: _selectedExam,
      quantity: _quantity,
      requestId: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (ok) {
      await auth.refreshUser();
      showDialog(
        context: context,
        builder: (_) => SuccessDialog(
          title: "$_selectedExam PIN Purchased",
          transaction: vtu.lastTransaction?.transaction,
        ),
      );
      setState(() => _quantity = 1);
      vtu.clearLastTransaction();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vtu.error ?? "Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final exam = _exams[_selectedExam]!;
    return Scaffold(
      appBar: AppBar(title: const Text("Buy Exam PIN"), backgroundColor: AppColors.primary),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Exam Type Selection
          Text("Select Exam Type", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          ...(_exams.entries.map((entry) {
            final key = entry.key;
            final val = entry.value;
            final sel = _selectedExam == key;
            final color = val["color"] as Color;
            return GestureDetector(
              onTap: () => setState(() => _selectedExam = key),
              child: Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: sel ? color.withOpacity(0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: sel ? color : AppColors.border, width: sel ? 2 : 1),
                ),
                child: Row(children: [
                  Container(
                    width: 50.w, height: 50.w,
                    decoration: BoxDecoration(color: sel ? color : color.withOpacity(0.1), borderRadius: BorderRadius.circular(12.r)),
                    child: Icon(val["icon"] as IconData, color: sel ? Colors.white : color, size: 28.sp),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(key, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: sel ? color : AppColors.textPrimary)),
                      SizedBox(height: 4.h),
                      Text(val["description"] as String, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6.r)),
                        child: Text("N${val["price"]}/PIN", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: color)),
                      ),
                    ]),
                  ),
                  if (sel) Icon(Icons.check_circle, color: color, size: 28.sp),
                ]),
              ),
            );
          })),

          SizedBox(height: 24.h),

          // Quantity Selector
          Text("Quantity", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r), border: Border.all(color: AppColors.border)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _buildQtyBtn(Icons.remove, () { if (_quantity > 1) setState(() => _quantity--); }),
              Container(
                width: 80.w,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text("$_quantity", textAlign: TextAlign.center, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
              ),
              _buildQtyBtn(Icons.add, () => setState(() => _quantity++)),
            ]),
          ),

          SizedBox(height: 24.h),

          // Order Summary
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [(exam["color"] as Color).withOpacity(0.8), exam["color"] as Color]),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(children: [
              Text("Order Summary", style: TextStyle(fontSize: 14.sp, color: Colors.white.withOpacity(0.9))),
              SizedBox(height: 16.h),
              _summaryRow("Exam", _selectedExam),
              _summaryRow("Price per PIN", "N${_pricePerUnit.toInt()}"),
              _summaryRow("Quantity", "$_quantity"),
              Container(height: 1, color: Colors.white.withOpacity(0.3), margin: EdgeInsets.symmetric(vertical: 12.h)),
              _summaryRow("Total Amount", "N${_totalPrice.toInt()}", bold: true),
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

          CustomButton(text: "Buy $_selectedExam PIN", onPressed: _buy, isLoading: _isLoading),
          SizedBox(height: 16.h),
        ]),
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w, height: 44.w,
        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12.r)),
        child: Icon(icon, color: AppColors.primary, size: 22.sp),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontSize: 13.sp, color: Colors.white.withOpacity(0.8))),
        Text(value, style: TextStyle(fontSize: bold ? 18.sp : 13.sp, fontWeight: bold ? FontWeight.bold : FontWeight.w500, color: Colors.white)),
      ]),
    );
  }
}
