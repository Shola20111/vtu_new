// import "package:vtu_app/utils/extensions.dart";
// import "package:vtu_app/core/models/transaction.dart";
// import "package:vtu_app/core/constants/app_colors.dart";
// import "package:flutter/material.dart";
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:vtu_app/core/constants/app_colors.dart';
// import 'package:vtu_app/core/models/transaction.dart';
// import 'package:vtu_app/utils/extensions.dart';

// class TransactionTile extends StatelessWidget {
//   final Transaction transaction;

//   const TransactionTile({
//     super.key,
//     required this.transaction,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 8.h),
//       padding: EdgeInsets.all(12.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(color: AppColors.divider),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(8.w),
//             decoration: BoxDecoration(
//               color: transaction.statusColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8.r),
//             ),
//             child: Icon(
//               transaction.serviceIcon,
//               color: transaction.statusColor,
//               size: 20.sp,
//             ),
//           ),
//           SizedBox(width: 12.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   transaction.serviceName,
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//                 SizedBox(height: 2.h),
//                 Text(
//                   '${transaction.phone.maskPhoneNumber()} • ${transaction.createdAt.timeAgo()}',
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 '-₦${transaction.amount.toStringAsFixed(2)}',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.error,
//                 ),
//               ),
//               SizedBox(height: 2.h),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
//                 decoration: BoxDecoration(
//                   color: transaction.statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(4.r),
//                 ),
//                 child: Text(
//                   transaction.status,
//                   style: TextStyle(
//                     fontSize: 10.sp,
//                     fontWeight: FontWeight.w600,
//                     color: transaction.statusColor,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vtu_app/core/constants/app_colors.dart';
import 'package:vtu_app/core/models/transaction.dart';
import 'package:vtu_app/utils/extensions.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.divider,
        ),
      ),
      child: Row(
        children: [

          /// SERVICE ICON
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: transaction.statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              transaction.serviceIcon,
              color: transaction.statusColor,
              size: 20.sp,
            ),
          ),

          SizedBox(width: 12.w),

          /// TRANSACTION INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.serviceName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  '${transaction.phone.maskPhoneNumber()} • ${transaction.createdAt.timeAgo()}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          /// AMOUNT + STATUS
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Text(
                '-₦${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
              ),

              SizedBox(height: 4.h),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: transaction.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  // transaction.status.toUpperCase(),
                  transaction.status.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: transaction.statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}