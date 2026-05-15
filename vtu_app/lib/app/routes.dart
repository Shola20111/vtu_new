import 'package:go_router/go_router.dart';
import 'package:vtu_app/ui/screens/splash/splash_screen.dart';
import 'package:vtu_app/ui/screens/auth/login_screen.dart';
import 'package:vtu_app/ui/screens/auth/register_screen.dart';
import 'package:vtu_app/ui/screens/home/home_screen.dart';
import 'package:vtu_app/ui/screens/airtime/airtime_screen.dart';
import 'package:vtu_app/ui/screens/data/data_screen.dart';
import 'package:vtu_app/ui/screens/electricity/electricity_screen.dart';
import 'package:vtu_app/ui/screens/tv/tv_screen.dart';
import 'package:vtu_app/ui/screens/exam/exam_screen.dart';
import 'package:vtu_app/ui/screens/wallet/wallet_screen.dart';
import 'package:vtu_app/ui/screens/transactions/transactions_screen.dart';
import 'package:vtu_app/ui/screens/transfer/transfer_screen.dart';
import 'package:vtu_app/ui/screens/profile/profile_screen.dart';
import 'package:vtu_app/core/services/storage_service.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => HomeScreen(
          navigationShell: navigationShell,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/airtime',
                builder: (context, state) => const AirtimeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/data',
                builder: (context, state) => const DataScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/wallet',
                builder: (context, state) => const WalletScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/electricity',
        builder: (context, state) => const ElectricityScreen(),
      ),
      GoRoute(
        path: '/tv',
        builder: (context, state) => const TVScreen(),
      ),
      GoRoute(
        path: '/exam',
        builder: (context, state) => const ExamScreen(),
      ),
      GoRoute(
        path: '/transfer',
        builder: (context, state) => const TransferScreen(),
      ),
      GoRoute(
        path: '/transactions',
        builder: (context, state) => const TransactionsScreen(),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = StorageService.isLoggedIn();
      final isAuthRoute = state.matchedLocation == '/login' || 
                          state.matchedLocation == '/register' ||
                          state.matchedLocation == '/splash';
      
      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }
      
      if (isLoggedIn && isAuthRoute && state.matchedLocation != '/splash') {
        return '/dashboard';
      }
      
      return null;
    },
  );
}
