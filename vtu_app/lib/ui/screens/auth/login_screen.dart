// import "package:vtu_app/utils/validators.dart";
// import "package:vtu_app/core/providers/wallet_provider.dart";
// import "package:vtu_app/ui/widgets/custom_text_field.dart";
// import "package:vtu_app/ui/widgets/custom_button.dart";
// import "package:vtu_app/core/constants/app_colors.dart";
// import "package:flutter/material.dart";
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:vtu_app/core/constants/app_colors.dart';
// import 'package:vtu_app/core/providers/auth_provider.dart';
// import 'package:vtu_app/ui/widgets/custom_button.dart';
// import 'package:vtu_app/ui/widgets/custom_text_field.dart';
// import 'package:vtu_app/utils/validators.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _identifierController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _identifierController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(24.w),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 60.h),
                
//                 // Logo and Title
//                 Center(
//                   child: Container(
//                     width: 80.w,
//                     height: 80.w,
//                     decoration: BoxDecoration(
//                       color: AppColors.primary,
//                       borderRadius: BorderRadius.circular(20.r),
//                     ),
//                     child: Icon(
//                       Icons.phone_android,
//                       size: 40.sp,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 24.h),
//                 Center(
//                   child: Text(
//                     'Welcome Back!',
//                     style: TextStyle(
//                       fontSize: 28.sp,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 Center(
//                   child: Text(
//                     'Sign in to continue',
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//                 ),
                
//                 SizedBox(height: 48.h),
                
//                 // Email/Username Field
//                 CustomTextField(
//                   controller: _identifierController,
//                   label: 'Email or Username',
//                   hint: 'Enter your email or username',
//                   prefix: Icon(
//                     Icons.person_outline,
//                     size: 20.sp,
//                     color: AppColors.textSecondary,
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) => Validators.required(value, 'Email or username'),
//                 ),
                
//                 SizedBox(height: 20.h),
                
//                 // Password Field
//                 CustomTextField(
//                   controller: _passwordController,
//                   label: 'Password',
//                   hint: 'Enter your password',
//                   prefix: Icon(
//                     Icons.lock_outline,
//                     size: 20.sp,
//                     color: AppColors.textSecondary,
//                   ),
//                   suffix: IconButton(
//                     icon: Icon(
//                       _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                       size: 20.sp,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscurePassword = !_obscurePassword;
//                       });
//                     },
//                   ),
//                   obscureText: _obscurePassword,
//                   validator: Validators.password,
//                 ),
                
//                 SizedBox(height: 32.h),
                
//                 // Login Button
//                 Consumer<AuthProvider>(
//                   builder: (context, authProvider, child) {
//                     return CustomButton(
//                       text: 'Sign In',
//                       onPressed: () => _handleLogin(authProvider),
//                       isLoading: authProvider.isLoading,
//                     );
//                   },
//                 ),
                
//                 SizedBox(height: 16.h),
                
//                 // Register Link
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Don't have an account? ",
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () => context.go('/register'),
//                       child: Text(
//                         'Sign Up',
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.primary,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _handleLogin(AuthProvider authProvider) async {
//     if (!_formKey.currentState!.validate()) return;

//     final success = await authProvider.login(
//       _identifierController.text.trim(),
//       _passwordController.text.trim(),
//     );

//     if (success && mounted) {
//       // Initialize wallet on login
//       context.read<WalletProvider>().loadBalance();
//       context.go('/dashboard');
//     } else if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(authProvider.error ?? 'Login failed'),
//           backgroundColor: AppColors.error,
//         ),
//       );
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:vtu_app/core/constants/app_colors.dart';
import 'package:vtu_app/core/providers/auth_provider.dart';
import 'package:vtu_app/core/providers/wallet_provider.dart';

import 'package:vtu_app/ui/widgets/custom_button.dart';
import 'package:vtu_app/ui/widgets/custom_text_field.dart';

import 'package:vtu_app/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final GlobalKey<FormState>
      _formKey =
      GlobalKey<FormState>();

  final TextEditingController
      _identifierController =
      TextEditingController();

  final TextEditingController
      _passwordController =
      TextEditingController();

  final FocusNode _passwordFocus =
      FocusNode();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();

    _passwordController.dispose();

    _passwordFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider =
        context.watch<AuthProvider>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },

      child: Scaffold(
        resizeToAvoidBottomInset: true,

        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior
                    .onDrag,

            padding: EdgeInsets.all(
              24.w,
            ),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  SizedBox(
                    height: 60.h,
                  ),

                  /// Logo
                  Center(
                    child: Container(
                      width: 80.w,

                      height: 80.w,

                      decoration:
                          BoxDecoration(
                        color:
                            AppColors.primary,

                        borderRadius:
                            BorderRadius.circular(
                          20.r,
                        ),
                      ),

                      child: Icon(
                        Icons.phone_android,

                        size: 40.sp,

                        color:
                            Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 24.h,
                  ),

                  /// Welcome text
                  Center(
                    child: Text(
                      'Welcome Back!',

                      style: TextStyle(
                        fontSize: 28.sp,

                        fontWeight:
                            FontWeight.bold,

                        color: AppColors
                            .textPrimary,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 8.h,
                  ),

                  Center(
                    child: Text(
                      'Sign in to continue',

                      style: TextStyle(
                        fontSize: 16.sp,

                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 48.h,
                  ),

                  /// Identifier field
                  CustomTextField(
                    controller:
                        _identifierController,

                    label:
                        'Email or Username',

                    hint:
                        'Enter your email or username',

                    keyboardType:
                        TextInputType
                            .emailAddress,

                    textInputAction:
                        TextInputAction.next,

                    autofillHints: const [
                      AutofillHints.email,
                      AutofillHints.username,
                    ],

                    prefix: Icon(
                      Icons.person_outline,

                      size: 20.sp,

                      color: AppColors
                          .textSecondary,
                    ),

                    validator: (value) {
                      return Validators
                          .required(
                        value,
                        'Email or username',
                      );
                    },

                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(
                        _passwordFocus,
                      );
                    },
                  ),

                  SizedBox(
                    height: 20.h,
                  ),

                  /// Password field
                  CustomTextField(
                    controller:
                        _passwordController,

                    focusNode:
                        _passwordFocus,

                    label: 'Password',

                    hint:
                        'Enter your password',

                    obscureText:
                        _obscurePassword,

                    textInputAction:
                        TextInputAction.done,

                    autofillHints: const [
                      AutofillHints.password,
                    ],

                    prefix: Icon(
                      Icons.lock_outline,

                      size: 20.sp,

                      color: AppColors
                          .textSecondary,
                    ),

                    suffix: IconButton(
                      splashRadius: 20.r,

                      icon: Icon(
                        _obscurePassword
                            ? Icons
                                .visibility_off
                            : Icons
                                .visibility,

                        size: 20.sp,
                      ),

                      onPressed: () {
                        setState(() {
                          _obscurePassword =
                              !_obscurePassword;
                        });
                      },
                    ),

                    validator:
                        Validators.password,

                    onFieldSubmitted: (_) {
                      _handleLogin(
                        authProvider,
                      );
                    },
                  ),

                  SizedBox(
                    height: 32.h,
                  ),

                  /// Error message
                  if (authProvider.error !=
                      null)
                    Padding(
                      padding:
                          EdgeInsets.only(
                        bottom: 16.h,
                      ),

                      child: Text(
                        authProvider.error!,

                        style: TextStyle(
                          color:
                              AppColors.error,

                          fontSize: 14.sp,
                        ),
                      ),
                    ),

                  /// Login button
                  CustomButton(
                    text: 'Sign In',

                    isLoading:
                        authProvider
                            .isLoading,

                    onPressed:
                        authProvider.isLoading
                            ? null
                            : () => _handleLogin(
                                  authProvider,
                                ),
                  ),

                  SizedBox(
                    height: 16.h,
                  ),

                  /// Register link
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                    children: [
                      Text(
                        "Don't have an account? ",

                        style: TextStyle(
                          fontSize: 14.sp,

                          color: AppColors
                              .textSecondary,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          context.go(
                            '/register',
                          );
                        },

                        child: Text(
                          'Sign Up',

                          style: TextStyle(
                            fontSize: 14.sp,

                            fontWeight:
                                FontWeight
                                    .w600,

                            color:
                                AppColors
                                    .primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(
    AuthProvider authProvider,
  ) async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    final success =
        await authProvider.login(
      _identifierController.text
          .trim(),

      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      try {
        await context
            .read<WalletProvider>()
            .loadBalance();

        if (!mounted) return;

        context.go('/dashboard');
      } catch (_) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Wallet initialization failed',
            ),

            backgroundColor:
                AppColors.error,
          ),
        );
      }
    }
  }
}