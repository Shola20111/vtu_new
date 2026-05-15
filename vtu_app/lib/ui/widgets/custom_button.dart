// import "package:vtu_app/core/constants/app_colors.dart";
// import "package:flutter/material.dart";
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:vtu_app/core/constants/app_colors.dart';

// class CustomButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? onPressed;
//   final bool isLoading;
//   final Color? backgroundColor;
//   final Color? textColor;
//   final double? height;
//   final double? width;
//   final double? borderRadius;
//   final Widget? prefix;
//   final Widget? suffix;

//   const CustomButton({
//     super.key,
//     required this.text,
//     this.onPressed,
//     this.isLoading = false,
//     this.backgroundColor,
//     this.textColor,
//     this.height,
//     this.width,
//     this.borderRadius,
//     this.prefix,
//     this.suffix,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: height ?? 56.h,
//       width: width ?? double.infinity,
//       child: ElevatedButton(
//         onPressed: isLoading ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: backgroundColor ?? AppColors.primary,
//           foregroundColor: textColor ?? Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(borderRadius?.r ?? 16.r),
//           ),
//           disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
//         ),
//         child: isLoading
//             ? SizedBox(
//                 height: 24.h,
//                 width: 24.w,
//                 child: const CircularProgressIndicator(
//                   strokeWidth: 2,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (prefix != null) ...[
//                     prefix!,
//                     SizedBox(width: 8.w),
//                   ],
//                   Text(
//                     text,
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   if (suffix != null) ...[
//                     SizedBox(width: 8.w),
//                     suffix!,
//                   ],
//                 ],
//               ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vtu_app/core/constants/app_colors.dart';

class CustomButton extends StatefulWidget {
  final String text;

  final Future<void> Function()? onPressed;

  final bool isLoading;

  final bool enabled;

  final Color? backgroundColor;

  final Color? foregroundColor;

  final double? height;

  final double? width;

  final double borderRadius;

  final Widget? prefix;

  final Widget? suffix;

  final bool outlined;

  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.backgroundColor,
    this.foregroundColor,
    this.height,
    this.width,
    this.borderRadius = 16,
    this.prefix,
    this.suffix,
    this.outlined = false,
    this.padding,
  });

  @override
  State<CustomButton> createState() =>
      _CustomButtonState();
}

class _CustomButtonState
    extends State<CustomButton> {
  bool _internalLoading = false;

  bool get _isDisabled =>
      widget.isLoading ||
      _internalLoading ||
      !widget.enabled ||
      widget.onPressed == null;

  Future<void> _handleTap() async {
    if (_isDisabled) return;

    setState(() {
      _internalLoading = true;
    });

    try {
      await widget.onPressed?.call();
    } finally {
      if (mounted) {
        setState(() {
          _internalLoading = false;
        });
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final background =
        widget.outlined
            ? Colors.transparent
            : widget.backgroundColor ??
                AppColors.primary;

    final foreground =
        widget.foregroundColor ??
            (widget.outlined
                ? AppColors.primary
                : Colors.white);

    return SizedBox(
      height:
          widget.height ?? 56.h,

      width:
          widget.width ??
              double.infinity,

      child: ElevatedButton(
        onPressed:
            _isDisabled
                ? null
                : _handleTap,

        style:
            ElevatedButton.styleFrom(
          elevation: 0,

          shadowColor:
              Colors.transparent,

          backgroundColor:
              background,

          foregroundColor:
              foreground,

          disabledBackgroundColor:
              widget.outlined
                  ? Colors.transparent
                  : AppColors.primary
                      .withOpacity(
                    0.5,
                  ),

          disabledForegroundColor:
              foreground
                  .withOpacity(
                0.7,
              ),

          padding:
              widget.padding ??
                  EdgeInsets.symmetric(
                    horizontal:
                        16.w,
                    vertical:
                        14.h,
                  ),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              widget.borderRadius
                  .r,
            ),

            side:
                widget.outlined
                    ? const BorderSide(
                        color:
                            AppColors
                                .primary,
                      )
                    : BorderSide.none,
          ),
        ),

        child: AnimatedSwitcher(
          duration:
              const Duration(
            milliseconds: 180,
          ),

          child:
              widget.isLoading ||
                      _internalLoading
                  ? SizedBox(
                      key:
                          const ValueKey(
                        'loading',
                      ),

                      height: 22.h,

                      width: 22.w,

                      child:
                          CircularProgressIndicator(
                        strokeWidth:
                            2.2,

                        valueColor:
                            AlwaysStoppedAnimation<
                                Color>(
                          foreground,
                        ),
                      ),
                    )
                  : Row(
                      key:
                          const ValueKey(
                        'content',
                      ),

                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                      mainAxisSize:
                          MainAxisSize
                              .min,

                      children: [
                        if (widget.prefix !=
                            null) ...[
                          widget.prefix!,

                          SizedBox(
                            width: 8.w,
                          ),
                        ],

                        Flexible(
                          child: Text(
                            widget.text,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style: theme
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                              fontSize:
                                  16.sp,

                              fontWeight:
                                  FontWeight
                                      .w600,

                              color:
                                  foreground,
                            ),
                          ),
                        ),

                        if (widget.suffix !=
                            null) ...[
                          SizedBox(
                            width: 8.w,
                          ),

                          widget.suffix!,
                        ],
                      ],
                    ),
        ),
      ),
    );
  }
}