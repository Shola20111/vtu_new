import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vtu_app/core/constants/app_colors.dart';
import 'package:vtu_app/core/providers/auth_provider.dart';
import 'package:vtu_app/core/providers/wallet_provider.dart';
import 'package:vtu_app/ui/widgets/custom_button.dart';
import 'package:vtu_app/ui/widgets/custom_text_field.dart';
import 'package:vtu_app/utils/validators.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});
  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _narrationController = TextEditingController();

  String _transferType = "wallet";
  bool _isLoading = false;
  String? _selectedBank;

  final List<int> _quickAmounts = [1000, 2000, 5000, 10000, 20000, 50000];

  final List<String> _banks = [
    "Access Bank", "GTBank", "First Bank", "UBA", "Zenith Bank",
    "Fidelity Bank", "Stanbic IBTC", "Union Bank", "Wema Bank",
    "Heritage Bank", "Keystone Bank", "Polaris Bank", "Ecobank",
  ];

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _narrationController.dispose();
    super.dispose();
  }

  Future<void> _transfer() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = int.tryParse(_amountController.text.trim()) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter valid amount")));
      return;
    }

    final auth = context.read<AuthProvider>();
    if ((auth.user?.walletBalance ?? 0) < amount) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Insufficient balance")));
      return;
    }

    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Transfer"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Amount: N$amount", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (_transferType == "wallet")
              Text("To: ${_recipientController.text}")
            else ...[
              Text("Bank: $_selectedBank"),
              Text("Account: ${_accountNumberController.text}"),
              Text("Name: ${_accountNameController.text}"),
            ],
            if (_narrationController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text("Narration: ${_narrationController.text}"),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Confirm")),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      await auth.refreshUser();
      await context.read<WalletProvider>().loadBalance();

      if (!mounted) return;

      String recipient;
      if (_transferType == "wallet") {
        recipient = _recipientController.text;
      } else {
        recipient = "${_accountNameController.text} - $_selectedBank";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("N$amount sent to $recipient successfully!"),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 3),
        ),
      );

      _recipientController.clear();
      _amountController.clear();
      _accountNameController.clear();
      _accountNumberController.clear();
      _narrationController.clear();
      setState(() => _selectedBank = null);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Transfer failed: $e"), backgroundColor: AppColors.error),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transfer Funds"), backgroundColor: AppColors.primary),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Transfer Type Toggle
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12.r)),
              child: Row(children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _transferType = "wallet"),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: _transferType == "wallet" ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.account_balance_wallet, size: 18.sp, color: _transferType == "wallet" ? Colors.white : AppColors.textSecondary),
                        SizedBox(width: 6.w),
                        Text("Wallet", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: _transferType == "wallet" ? Colors.white : AppColors.textSecondary)),
                      ]),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _transferType = "bank"),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: _transferType == "bank" ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.account_balance, size: 18.sp, color: _transferType == "bank" ? Colors.white : AppColors.textSecondary),
                        SizedBox(width: 6.w),
                        Text("Bank", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: _transferType == "bank" ? Colors.white : AppColors.textSecondary)),
                      ]),
                    ),
                  ),
                ),
              ]),
            ),

            SizedBox(height: 24.h),

            // Wallet Transfer Fields
            if (_transferType == "wallet") ...[
              Text("Transfer to Wallet", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: _recipientController,
                label: "Recipient",
                hint: "Enter username, email or phone number",
                prefix: Icon(Icons.person_outline, size: 20.sp, color: AppColors.textSecondary),
                validator: (v) => Validators.required(v, "Recipient"),
              ),
            ],

            // Bank Transfer Fields
            if (_transferType == "bank") ...[
              Text("Transfer to Bank Account", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 12.h),

              // Bank Selection
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.border)),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedBank,
                    hint: Text("Select Bank", style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
                    isExpanded: true,
                    items: _banks.map((b) => DropdownMenuItem(value: b, child: Text(b, style: TextStyle(fontSize: 14.sp)))).toList(),
                    onChanged: (v) => setState(() => _selectedBank = v),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              CustomTextField(
                controller: _accountNumberController,
                label: "Account Number",
                hint: "Enter 10-digit account number",
                keyboardType: TextInputType.number,
                maxLength: 10,
                prefix: Icon(Icons.credit_card, size: 20.sp, color: AppColors.textSecondary),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Account number required";
                  if (v.length != 10) return "Must be 10 digits";
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              CustomTextField(
                controller: _accountNameController,
                label: "Account Name",
                hint: "Enter account holder name",
                prefix: Icon(Icons.person, size: 20.sp, color: AppColors.textSecondary),
                validator: (v) => Validators.required(v, "Account name"),
              ),
            ],

            SizedBox(height: 20.h),

            // Amount
            CustomTextField(
              controller: _amountController,
              label: "Amount (N)",
              hint: "Enter amount",
              keyboardType: TextInputType.number,
              prefix: Icon(Icons.money, size: 20.sp, color: AppColors.textSecondary),
              validator: (v) => Validators.required(v, "Amount"),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w, runSpacing: 8.h,
              children: _quickAmounts.map((a) => ActionChip(
                label: Text("N$a", style: TextStyle(fontSize: 12.sp)),
                onPressed: () => _amountController.text = "$a",
              )).toList(),
            ),
            SizedBox(height: 20.h),

            // Narration
            CustomTextField(
              controller: _narrationController,
              label: "Narration (Optional)",
              hint: "What is this transfer for?",
              prefix: Icon(Icons.description, size: 20.sp, color: AppColors.textSecondary),
              maxLines: 2,
            ),

            SizedBox(height: 24.h),

            // Balance
            Consumer<AuthProvider>(
              builder: (_, auth, __) => Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12.r)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text("Your Balance:", style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
                  Text("N${auth.user?.walletBalance.toStringAsFixed(2) ?? "0.00"}", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ]),
              ),
            ),

            SizedBox(height: 32.h),

            CustomButton(
              text: _transferType == "wallet" ? "Send to Wallet" : "Send to Bank",
              onPressed: _transfer,
              isLoading: _isLoading,
              prefix: Icon(Icons.send, size: 20.sp, color: Colors.white),
            ),

            SizedBox(height: 16.h),

            // Info note
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8.r)),
              child: Row(children: [
                Icon(Icons.info_outline, size: 16.sp, color: AppColors.warning),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    _transferType == "wallet" 
                        ? "Transfer instantly to any VTU user" 
                        : "Bank transfers may take 1-3 business days",
                    style: TextStyle(fontSize: 12.sp, color: AppColors.warning),
                  ),
                ),
              ]),
            ),
            SizedBox(height: 16.h),
          ]),
        ),
      ),
    );
  }
}
