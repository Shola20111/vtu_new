// import 'package:flutter/material.dart';
// import 'package:vtu_app/app/routes.dart';
// import 'package:vtu_app/app/theme.dart';

// class VTUApp extends StatelessWidget {
//   const VTUApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'VTU App',
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.lightTheme,
//       routerConfig: AppRouter.router,
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:vtu_app/app/routes.dart';
import 'package:vtu_app/app/theme.dart';

class VTUApp extends StatelessWidget {
  const VTUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VTU App',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      // Add later if available
      // darkTheme: AppTheme.darkTheme,
      // themeMode: ThemeMode.system,

      restorationScopeId: 'app',

      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: child ?? const SizedBox.shrink(),
        );
      },

      routerConfig: AppRouter.router,
    );
  }
}