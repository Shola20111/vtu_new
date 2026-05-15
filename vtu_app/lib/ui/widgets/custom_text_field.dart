// import "package:flutter/material.dart";
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final String? hint;
//   final Widget? prefix;
//   final Widget? suffix;
//   final bool obscureText;
//   final TextInputType? keyboardType;
//   final String? Function(String?)? validator;
//   final int? maxLines;
//   final int? maxLength;
//   final bool enabled;
//   final Function(String)? onChanged;

//   const CustomTextField({
//     super.key,
//     required this.controller,
//     required this.label,
//     this.hint,
//     this.prefix,
//     this.suffix,
//     this.obscureText = false,
//     this.keyboardType,
//     this.validator,
//     this.maxLines = 1,
//     this.maxLength,
//     this.enabled = true,
//     this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//         ),
//         SizedBox(height: 8.h),
//         TextFormField(
//           controller: controller,
//           obscureText: obscureText,
//           keyboardType: keyboardType,
//           validator: validator,
//           maxLines: maxLines,
//           maxLength: maxLength,
//           enabled: enabled,
//           onChanged: onChanged,
//           decoration: InputDecoration(
//             hintText: hint,
//             prefixIcon: prefix,
//             suffixIcon: suffix,
//           ),
//         ),
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vtu_app/core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;

  final String label;

  final String? hint;

  final Widget? prefix;

  final Widget? suffix;

  final bool obscureText;

  final TextInputType? keyboardType;

  final TextInputAction textInputAction;

  final String? Function(String?)? validator;

  final int maxLines;

  final int? maxLength;

  final bool enabled;

  final bool readOnly;

  final bool autofocus;

  final Iterable<String>? autofillHints;

  final List<TextInputFormatter>? inputFormatters;

  final void Function(String)? onChanged;

  final VoidCallback? onTap;

  final void Function(String)? onFieldSubmitted;

  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.autofillHints,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.onFieldSubmitted,
    this.focusNode,
    this.textInputAction =
        TextInputAction.next,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              theme.textTheme.bodyMedium
                  ?.copyWith(
            fontSize: 14.sp,
            fontWeight:
                FontWeight.w600,
            color:
                AppColors.textPrimary,
          ),
        ),

        SizedBox(
          height: 8.h,
        ),

        TextFormField(
          controller:
              controller,

          focusNode:
              focusNode,

          obscureText:
              obscureText,

          keyboardType:
              keyboardType,

          validator:
              validator,

          enabled:
              enabled,

          readOnly:
              readOnly,

          autofocus:
              autofocus,

          autofillHints:
              autofillHints,

          inputFormatters:
              inputFormatters,

          onChanged:
              onChanged,

          onTap: onTap,

          onFieldSubmitted:
              onFieldSubmitted,

          textInputAction:
              textInputAction,

          maxLength:
              maxLength,

          maxLines:
              obscureText
                  ? 1
                  : maxLines,

          minLines: 1,

          style:
              theme.textTheme.bodyMedium
                  ?.copyWith(
            fontSize: 15.sp,
            color:
                AppColors.textPrimary,
          ),

          decoration:
              InputDecoration(
            hintText: hint,

            counterText: '',

            prefixIcon:
                prefix,

            suffixIcon:
                suffix,

            filled: true,

            fillColor:
                enabled
                    ? Colors.white
                    : AppColors
                        .border
                        .withOpacity(
                        0.2,
                      ),

            contentPadding:
                EdgeInsets.symmetric(
              horizontal:
                  16.w,
              vertical:
                  16.h,
            ),

            hintStyle:
                theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
              fontSize:
                  14.sp,
              color:
                  AppColors
                      .textSecondary,
            ),

            enabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                14.r,
              ),
              borderSide:
                  BorderSide(
                color:
                    AppColors
                        .border,
              ),
            ),

            focusedBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                14.r,
              ),
              borderSide:
                  const BorderSide(
                color:
                    AppColors
                        .primary,
                width: 1.5,
              ),
            ),

            errorBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                14.r,
              ),
              borderSide:
                  const BorderSide(
                color:
                    AppColors
                        .error,
              ),
            ),

            focusedErrorBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                14.r,
              ),
              borderSide:
                  const BorderSide(
                color:
                    AppColors
                        .error,
                width: 1.5,
              ),
            ),

            disabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                14.r,
              ),
              borderSide:
                  BorderSide(
                color:
                    AppColors
                        .border
                        .withOpacity(
                      0.5,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}