// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:vtu_app/app/app.dart';
// import 'package:vtu_app/core/providers/auth_provider.dart';
// import 'package:vtu_app/core/providers/vtu_provider.dart';
// import 'package:vtu_app/core/providers/wallet_provider.dart';
// import 'package:vtu_app/core/services/storage_service.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await StorageService.init();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 812),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (_, child) {
//         return MultiProvider(
//           providers: [
//             ChangeNotifierProvider(create: (_) => AuthProvider()),
//             ChangeNotifierProvider(create: (_) => VTUProvider()),
//             ChangeNotifierProvider(create: (_) => WalletProvider()),
//           ],
//           child: const VTUApp(),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vtu_app/app/app.dart';
import 'package:vtu_app/core/providers/auth_provider.dart';
import 'package:vtu_app/core/providers/vtu_provider.dart';
import 'package:vtu_app/core/providers/wallet_provider.dart';
import 'package:vtu_app/core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);

    // TODO:
    // Add crash reporting service here
    // Example:
    // FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };

  try {
    await StorageService.init();

    runApp(const MyApp());
  } catch (e) {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Text(
                'App initialization failed.\n$e',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(
              create: (_) => AuthProvider(),
            ),

            ChangeNotifierProvider<VTUProvider>(
              create: (_) => VTUProvider(),
            ),

            ChangeNotifierProvider<WalletProvider>(
              create: (_) => WalletProvider(),
            ),
          ],
          child: const VTUApp(),
        );
      },
    );
  }
}