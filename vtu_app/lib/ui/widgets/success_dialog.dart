import "package:vtu_app/core/models/transaction.dart";
import "package:vtu_app/ui/widgets/custom_button.dart";
import "package:vtu_app/core/constants/app_colors.dart";
import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final TransactionResponse? transaction;
  final String? network;
  final String? token;
  final String? units;

  const SuccessDialog({
    super.key,
    required this.title,
    this.transaction,
    this.network,
    this.token,
    this.units,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 64.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            if (transaction != null) ...[
              _buildInfoRow('Amount', '₦${transaction!.amount}'),
              _buildInfoRow('Phone', transaction!.phone),
              if (network != null) _buildInfoRow('Network', network!),
              if (token != null) _buildInfoRow('Token', token!),
              if (units != null) _buildInfoRow('Units', units!),
              _buildInfoRow('Request ID', transaction!.requestId),
            ],
            SizedBox(height: 24.h),
            CustomButton(
              text: 'Done',
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
