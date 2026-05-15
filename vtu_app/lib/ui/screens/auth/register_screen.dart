// import "package:vtu_app/utils/validators.dart";
// import "package:vtu_app/ui/widgets/custom_text_field.dart";
// import "package:vtu_app/ui/widgets/custom_button.dart";
// import "package:vtu_app/core/constants/app_colors.dart";
// import "package:flutter/material.dart";
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:vtu_app/core/constants/app_colors.dart';
// import 'package:vtu_app/core/models/user.dart';
// import 'package:vtu_app/core/providers/auth_provider.dart';
// import 'package:vtu_app/ui/widgets/custom_button.dart';
// import 'package:vtu_app/ui/widgets/custom_text_field.dart';
// import 'package:vtu_app/utils/validators.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _fullNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _usernameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _usernameController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
//           onPressed: () => context.go('/login'),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(24.w),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Create Account',
//                   style: TextStyle(
//                     fontSize: 28.sp,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 Text(
//                   'Sign up to get started with VTU services',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
                
//                 SizedBox(height: 32.h),
                
//                 // Full Name
//                 CustomTextField(
//                   controller: _fullNameController,
//                   label: 'Full Name',
//                   hint: 'Enter your full name',
//                   prefix: Icon(
//                     Icons.person,
//                     size: 20.sp,
//                     color: AppColors.textSecondary,
//                   ),
//                   validator: Validators.fullName,
//                 ),
                
//                 SizedBox(height: 16.h),
                
//                 // Email
//                 CustomTextField(
//                   controller: _emailController,
//                   label: 'Email',
//                   hint: 'Enter your email',
//                   prefix: Icon(
//                     Icons.email_outlined,
//                     size: 20.sp,
//                     color: AppColors.textSecondary,
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: Validators.email,
//                 ),
                
//                 SizedBox(height: 16.h),
                
//                 // Username
//                 CustomTextField(
//                   controller: _usernameController,
//                   label: 'Username',
//                   hint: 'Choose a username',
//                   prefix: Icon(
//                     Icons.alternate_email,
//                     size: 20.sp,
//                     color: AppColors.textSecondary,
//                   ),
//                   validator: Validators.username,
//                 ),
                
//                 SizedBox(height: 16.h),
                
//                 // Phone
//                 CustomTextField(
//                   controller: _phoneController,
//                   label: 'Phone Number',
//                   hint: 'Enter your phone number',
//                   prefix: const Padding(
//                     padding: EdgeInsets.all(14),
//                     child: Text(
//                       '+234',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                   ),
//                   keyboardType: TextInputType.phone,
//                   validator: Validators.phone,
//                 ),
                
//                 SizedBox(height: 16.h),
                
//                 // Password
//                 CustomTextField(
//                   controller: _passwordController,
//                   label: 'Password',
//                   hint: 'Create a password',
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
                
//                 SizedBox(height: 16.h),
                
//                 // Confirm Password
//                 CustomTextField(
//                   controller: _confirmPasswordController,
//                   label: 'Confirm Password',
//                   hint: 'Confirm your password',
//                   prefix: Icon(
//                     Icons.lock_outline,
//                     size: 20.sp,
//                     color: AppColors.textSecondary,
//                   ),
//                   suffix: IconButton(
//                     icon: Icon(
//                       _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
//                       size: 20.sp,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscureConfirmPassword = !_obscureConfirmPassword;
//                       });
//                     },
//                   ),
//                   obscureText: _obscureConfirmPassword,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please confirm your password';
//                     }
//                     if (value != _passwordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return null;
//                   },
//                 ),
                
//                 SizedBox(height: 32.h),
                
//                 // Register Button
//                 Consumer<AuthProvider>(
//                   builder: (context, authProvider, child) {
//                     return CustomButton(
//                       text: 'Create Account',
//                       onPressed: () => _handleRegister(authProvider),
//                       isLoading: authProvider.isLoading,
//                     );
//                   },
//                 ),
                
//                 SizedBox(height: 16.h),
                
//                 // Login Link
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Already have an account? ',
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () => context.go('/login'),
//                       child: Text(
//                         'Sign In',
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

//   Future<void> _handleRegister(AuthProvider authProvider) async {
//     if (!_formKey.currentState!.validate()) return;

//     final request = RegisterRequest(
//       fullName: _fullNameController.text.trim(),
//       email: _emailController.text.trim(),
//       username: _usernameController.text.trim(),
//       password: _passwordController.text,
//       phone: _phoneController.text.trim(),
//     );

//     final success = await authProvider.register(request);

//     if (success && mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Registration successful!'),
//           backgroundColor: AppColors.success,
//         ),
//       );
//       context.go('/dashboard');
//     } else if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(authProvider.error ?? 'Registration failed'),
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
import 'package:vtu_app/core/models/user.dart';
import 'package:vtu_app/core/providers/auth_provider.dart';
import 'package:vtu_app/ui/widgets/custom_button.dart';
import 'package:vtu_app/ui/widgets/custom_text_field.dart';
import 'package:vtu_app/utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/login');
              }
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 12.h,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    'Sign up to get started with VTU services',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: 32.h),

                  /// FULL NAME
                  CustomTextField(
                    controller: _fullNameController,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    keyboardType: TextInputType.name,
                    prefix: Icon(
                      Icons.person_outline,
                      size: 20.sp,
                      color: AppColors.textSecondary,
                    ),
                    validator: Validators.fullName,
                  ),

                  SizedBox(height: 16.h),

                  /// EMAIL
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    prefix: Icon(
                      Icons.email_outlined,
                      size: 20.sp,
                      color: AppColors.textSecondary,
                    ),
                    validator: Validators.email,
                  ),

                  SizedBox(height: 16.h),

                  /// USERNAME
                  CustomTextField(
                    controller: _usernameController,
                    label: 'Username',
                    hint: 'Choose a username',
                    prefix: Icon(
                      Icons.alternate_email,
                      size: 20.sp,
                      color: AppColors.textSecondary,
                    ),
                    validator: Validators.username,
                  ),

                  SizedBox(height: 16.h),

                  /// PHONE
                  CustomTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hint: '8012345678',
                    keyboardType: TextInputType.phone,
                    prefix: Padding(
                      padding: EdgeInsets.all(14.w),
                      child: Text(
                        '+234',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    validator: Validators.phone,
                  ),

                  SizedBox(height: 16.h),

                  /// PASSWORD
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Create a password',
                    obscureText: _obscurePassword,
                    prefix: Icon(
                      Icons.lock_outline,
                      size: 20.sp,
                      color: AppColors.textSecondary,
                    ),
                    suffix: IconButton(
                      splashRadius: 20.r,
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: Validators.password,
                  ),

                  SizedBox(height: 16.h),

                  /// CONFIRM PASSWORD
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hint: 'Confirm your password',
                    obscureText: _obscureConfirmPassword,
                    prefix: Icon(
                      Icons.lock_outline,
                      size: 20.sp,
                      color: AppColors.textSecondary,
                    ),
                    suffix: IconButton(
                      splashRadius: 20.r,
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword =
                              !_obscureConfirmPassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }

                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: 32.h),

                  /// REGISTER BUTTON
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return CustomButton(
                        text: 'Create Account',
                        isLoading: authProvider.isLoading,
                        onPressed: authProvider.isLoading
                            ? null
                            : () => _handleRegister(authProvider),
                      );
                    },
                  ),

                  SizedBox(height: 18.h),

                  /// LOGIN LINK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister(AuthProvider authProvider) async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final request = RegisterRequest(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim().toLowerCase(),
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    final success = await authProvider.register(request);

    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: AppColors.success,
        ),
      );

      context.go('/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.error ?? 'Registration failed',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}