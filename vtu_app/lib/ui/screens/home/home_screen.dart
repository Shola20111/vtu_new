
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// import 'package:vtu_app/core/constants/app_colors.dart';

// import 'package:vtu_app/core/providers/auth_provider.dart';
// import 'package:vtu_app/core/providers/wallet_provider.dart';

// import 'package:vtu_app/ui/widgets/transaction_tile.dart';

// class HomeScreen extends StatefulWidget {
//   final StatefulNavigationShell
//       navigationShell;

//   const HomeScreen({
//     super.key,
//     required this.navigationShell,
//   });

//   @override
//   State<HomeScreen> createState() =>
//       _HomeScreenState();
// }

// class _HomeScreenState
//     extends State<HomeScreen> {
//   bool _walletLoaded = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     /// Prevent duplicate reloads
//     if (!_walletLoaded) {
//       _walletLoaded = true;

//       WidgetsBinding.instance
//           .addPostFrameCallback((_) async {
//         try {
//           await context
//               .read<WalletProvider>()
//               .loadBalance();
//         } catch (_) {}
//       });
//     }
//   }

//   void _onTap(int index) {
//     widget.navigationShell.goBranch(
//       index,

//       /// Correct logic:
//       /// reset only when reselecting tab
//       initialLocation:
//           index ==
//               widget.navigationShell
//                   .currentIndex,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: widget.navigationShell,

//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color:
//                   Colors.black.withValues(alpha:
//                 0.08,
//               ),

//               blurRadius: 12,

//               offset: const Offset(
//                 0,
//                 -2,
//               ),
//             ),
//           ],
//         ),

//         child: NavigationBar(
//           selectedIndex:
//               widget.navigationShell
//                   .currentIndex,

//           onDestinationSelected:
//               _onTap,

//           backgroundColor:
//               Colors.white,

//           elevation: 0,

//           height: 68.h,

//           labelBehavior:
//               NavigationDestinationLabelBehavior
//                   .alwaysShow,

//           destinations: const [
//             NavigationDestination(
//               icon: Icon(
//                 Icons.dashboard_outlined,
//               ),

//               selectedIcon: Icon(
//                 Icons.dashboard,

//                 color:
//                     AppColors.primary,
//               ),

//               label: 'Home',
//             ),

//             NavigationDestination(
//               icon: Icon(
//                 Icons.phone_android_outlined,
//               ),

//               selectedIcon: Icon(
//                 Icons.phone_android,

//                 color:
//                     AppColors.primary,
//               ),

//               label: 'Airtime',
//             ),

//             NavigationDestination(
//               icon: Icon(
//                 Icons.wifi_outlined,
//               ),

//               selectedIcon: Icon(
//                 Icons.wifi,

//                 color:
//                     AppColors.primary,
//               ),

//               label: 'Data',
//             ),

//             NavigationDestination(
//               icon: Icon(
//                 Icons
//                     .account_balance_wallet_outlined,
//               ),

//               selectedIcon: Icon(
//                 Icons
//                     .account_balance_wallet,

//                 color:
//                     AppColors.primary,
//               ),

//               label: 'Wallet',
//             ),

//             NavigationDestination(
//               icon: Icon(
//                 Icons.person_outline,
//               ),

//               selectedIcon: Icon(
//                 Icons.person,

//                 color:
//                     AppColors.primary,
//               ),

//               label: 'Profile',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// DASHBOARD SCREEN
// class DashboardScreen
//     extends StatelessWidget {
//   const DashboardScreen({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final authProvider =
//         context.watch<AuthProvider>();

//     final walletProvider =
//         context.watch<WalletProvider>();

//     // final user =
//     //     authProvider.user;

//     return Scaffold(
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: () async {
//             await walletProvider
//                 .loadBalance();
//           },

//           child: SingleChildScrollView(
//             physics:
//                 const AlwaysScrollableScrollPhysics(),

//             padding: EdgeInsets.all(
//               16.w,
//             ),

//             child: Column(
//               crossAxisAlignment:
//                   CrossAxisAlignment.start,

//               children: [
//                 /// Header
//                 _DashboardHeader(
//                   authProvider:
//                       authProvider,

//                   walletProvider:
//                       walletProvider,
//                 ),

//                 SizedBox(
//                   height: 24.h,
//                 ),

//                 /// Services
//                 Text(
//                   'Our Services',

//                   style: TextStyle(
//                     fontSize: 18.sp,

//                     fontWeight:
//                         FontWeight.bold,

//                     color: AppColors
//                         .textPrimary,
//                   ),
//                 ),

//                 SizedBox(
//                   height: 16.h,
//                 ),

//                 GridView.count(
//                   crossAxisCount: 3,

//                   shrinkWrap: true,

//                   physics:
//                       const NeverScrollableScrollPhysics(),

//                   crossAxisSpacing:
//                       12.w,

//                   mainAxisSpacing:
//                       12.h,

//                   childAspectRatio:
//                       0.95,

//                   children: [
//                     _ServiceCard(
//                       icon:
//                           Icons.phone_android,

//                       label: 'Airtime',

//                       color:
//                           AppColors.mtn,

//                       onTap: () {
//                         context.go(
//                           '/airtime',
//                         );
//                       },
//                     ),

//                     _ServiceCard(
//                       icon: Icons.wifi,

//                       label: 'Data',

//                       color:
//                           AppColors.airtel,

//                       onTap: () {
//                         context.go(
//                           '/data',
//                         );
//                       },
//                     ),

//                     _ServiceCard(
//                       icon: Icons.tv,

//                       label: 'TV',

//                       color: AppColors
//                           .secondary,

//                       onTap: () {
//                         context.go('/tv');
//                       },
//                     ),

//                     _ServiceCard(
//                       icon: Icons
//                           .electric_bolt,

//                       label:
//                           'Electricity',

//                       color:
//                           AppColors.warning,

//                       onTap: () {
//                         context.go(
//                           '/electricity',
//                         );
//                       },
//                     ),

//                     _ServiceCard(
//                       icon: Icons.school,

//                       label:
//                           'Exam PIN',

//                       color:
//                           AppColors.info,

//                       onTap: () {
//                         context.go(
//                           '/exam',
//                         );
//                       },
//                     ),

//                     _ServiceCard(
//                       icon:
//                           Icons.receipt_long,

//                       label: 'History',

//                       color:
//                           AppColors.glo,

//                       onTap: () {
//                         context.go(
//                           '/transactions',
//                         );
//                       },
//                     ),
//                   ],
//                 ),

//                 SizedBox(
//                   height: 24.h,
//                 ),

//                 /// Transactions
//                 if (walletProvider
//                     .recentTransactions
//                     .isNotEmpty)
//                   Column(
//                     crossAxisAlignment:
//                         CrossAxisAlignment
//                             .start,

//                     children: [
//                       Row(
//                         mainAxisAlignment:
//                             MainAxisAlignment
//                                 .spaceBetween,

//                         children: [
//                           Text(
//                             'Recent Transactions',

//                             style:
//                                 TextStyle(
//                               fontSize:
//                                   18.sp,

//                               fontWeight:
//                                   FontWeight
//                                       .bold,

//                               color: AppColors
//                                   .textPrimary,
//                             ),
//                           ),

//                           TextButton(
//                             onPressed: () {
//                               context.go(
//                                 '/transactions',
//                               );
//                             },

//                             child: Text(
//                               'See All',

//                               style:
//                                   TextStyle(
//                                 fontSize:
//                                     14.sp,

//                                 color:
//                                     AppColors
//                                         .primary,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                       SizedBox(
//                         height: 12.h,
//                       ),

//                       ...walletProvider
//                           .recentTransactions
//                           .map(
//                         (transaction) {
//                           return TransactionTile(
//                             transaction:
//                                 transaction,
//                           );
//                         },
//                       ),
//                     ],
//                   ),

//                 SizedBox(
//                   height: 30.h,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// HEADER
// class _DashboardHeader
//     extends StatelessWidget {
//   final AuthProvider authProvider;

//   final WalletProvider walletProvider;

//   const _DashboardHeader({
//     required this.authProvider,
//     required this.walletProvider,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final firstName =
//         authProvider.user?.fullName
//             .split(' ')
//             .first ??
//         'User';

//     return Container(
//       padding: EdgeInsets.all(
//         20.w,
//       ),

//       decoration: BoxDecoration(
//         gradient:
//             const LinearGradient(
//           colors: [
//             AppColors.primary,
//             Color(0xFF1565C0),
//           ],
//         ),

//         borderRadius:
//             BorderRadius.circular(
//           20.r,
//         ),
//       ),

//       child: Column(
//         crossAxisAlignment:
//             CrossAxisAlignment.start,

//         children: [
//           Row(
//             mainAxisAlignment:
//                 MainAxisAlignment
//                     .spaceBetween,

//             children: [
//               Column(
//                 crossAxisAlignment:
//                     CrossAxisAlignment
//                         .start,

//                 children: [
//                   Text(
//                     'Hello, $firstName',

//                     style: TextStyle(
//                       fontSize: 20.sp,

//                       fontWeight:
//                           FontWeight.bold,

//                       color:
//                           Colors.white,
//                     ),
//                   ),

//                   SizedBox(
//                     height: 4.h,
//                   ),

//                   Text(
//                     'Welcome back!',

//                     style: TextStyle(
//                       fontSize: 14.sp,

//                       color: Colors
//                           .white
//                           .withOpacity(0.85),
//                     ),
//                   ),
//                 ],
//               ),

//               CircleAvatar(
//                 radius: 25.r,

//                 backgroundColor:
//                     Colors.white
//                         .withOpacity(
//                   0.2,
//                 ),

//                 child: Text(
//                   firstName
//                       .substring(0, 1)
//                       .toUpperCase(),

//                   style: TextStyle(
//                     fontSize: 20.sp,

//                     fontWeight:
//                         FontWeight.bold,

//                     color:
//                         Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           SizedBox(
//             height: 20.h,
//           ),

//           Container(
//             padding: EdgeInsets.all(
//               16.w,
//             ),

//             decoration: BoxDecoration(
//               color: Colors.white
//                   .withOpacity(0.2),

//               borderRadius:
//                   BorderRadius.circular(
//                 12.r,
//               ),
//             ),

//             child: Row(
//               mainAxisAlignment:
//                   MainAxisAlignment
//                       .spaceBetween,

//               children: [
//                 Column(
//                   crossAxisAlignment:
//                       CrossAxisAlignment
//                           .start,

//                   children: [
//                     Text(
//                       'Wallet Balance',

//                       style: TextStyle(
//                         fontSize: 12.sp,

//                         color: Colors
//                             .white
//                             .withOpacity(
//                           0.9,
//                         ),
//                       ),
//                     ),

//                     SizedBox(
//                       height: 4.h,
//                     ),

//                     Text(
//                       walletProvider
//                           .formattedBalance,

//                       style: TextStyle(
//                         fontSize: 24.sp,

//                         fontWeight:
//                             FontWeight.bold,

//                         color:
//                             Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),

//                 IconButton(
//                   icon: const Icon(
//                     Icons.refresh,

//                     color:
//                         Colors.white,
//                   ),

//                   onPressed: () async {
//                     await walletProvider
//                         .loadBalance();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// SERVICE CARD
// class _ServiceCard
//     extends StatelessWidget {
//   final IconData icon;

//   final String label;

//   final Color color;

//   final VoidCallback onTap;

//   const _ServiceCard({
//     required this.icon,
//     required this.label,
//     required this.color,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,

//       child: InkWell(
//         borderRadius:
//             BorderRadius.circular(
//           16.r,
//         ),

//         onTap: onTap,

//         child: Ink(
//           decoration: BoxDecoration(
//             color: Colors.white,

//             borderRadius:
//                 BorderRadius.circular(
//               16.r,
//             ),

//             boxShadow: [
//               BoxShadow(
//                 color:
//                     color.withOpacity(
//                   0.1,
//                 ),

//                 blurRadius: 10,

//                 offset:
//                     const Offset(0, 4),
//               ),
//             ],
//           ),

//           child: Column(
//             mainAxisAlignment:
//                 MainAxisAlignment.center,

//             children: [
//               Container(
//                 padding:
//                     EdgeInsets.all(
//                   12.w,
//                 ),

//                 decoration:
//                     BoxDecoration(
//                   color:
//                       color.withOpacity(
//                     0.1,
//                   ),

//                   borderRadius:
//                       BorderRadius.circular(
//                     12.r,
//                   ),
//                 ),

//                 child: Icon(
//                   icon,

//                   color: color,

//                   size: 28.sp,
//                 ),
//               ),

//               SizedBox(
//                 height: 8.h,
//               ),

//               Text(
//                 label,

//                 textAlign:
//                     TextAlign.center,

//                 style: TextStyle(
//                   fontSize: 12.sp,

//                   fontWeight:
//                       FontWeight.w500,

//                   color: AppColors
//                       .textPrimary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vtu_app/core/constants/app_colors.dart';
import 'package:vtu_app/core/providers/auth_provider.dart';
import 'package:vtu_app/core/providers/wallet_provider.dart';
import 'package:vtu_app/ui/widgets/transaction_tile.dart';

class HomeScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletProvider>().loadBalance();
      context.read<WalletProvider>().loadRecentTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: (index) {
            widget.navigationShell.goBranch(
              index,
              initialLocation: index == widget.navigationShell.currentIndex,
            );
          },
          backgroundColor: Colors.white,
          elevation: 0,
          height: 65.h,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard, color: AppColors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.phone_android_outlined),
              selectedIcon: Icon(Icons.phone_android, color: AppColors.primary),
              label: 'Airtime',
            ),
            NavigationDestination(
              icon: Icon(Icons.wifi_outlined),
              selectedIcon: Icon(Icons.wifi, color: AppColors.primary),
              label: 'Data',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              selectedIcon: Icon(Icons.account_balance_wallet, color: AppColors.primary),
              label: 'Wallet',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: AppColors.primary),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== DASHBOARD SCREEN ====================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletProvider>().loadBalance();
      context.read<WalletProvider>().loadRecentTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<WalletProvider>().refreshWallet();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                _buildHeaderCard(),
                
                SizedBox(height: 24.h),
                
                // Quick Actions
                _buildQuickActions(),
                
                SizedBox(height: 24.h),
                
                // Services Grid
                _buildSectionTitle('Our Services'),
                SizedBox(height: 12.h),
                _buildServicesGrid(),
                
                SizedBox(height: 24.h),
                
                // Recent Transactions
                _buildRecentTransactions(),
                
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Consumer2<AuthProvider, WalletProvider>(
      builder: (context, authProvider, walletProvider, child) {
        final user = authProvider.user;
        
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, Color(0xFF1565C0)],
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // User info row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${user?.fullName.split(' ')[0] ?? 'User'} 👋',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Welcome back to your VTU dashboard',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 25.r,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Text(
                      user?.fullName.isNotEmpty == true 
                          ? user!.fullName[0].toUpperCase() 
                          : 'U',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 20.h),
              
              // Wallet balance card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.account_balance_wallet,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wallet Balance',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              walletProvider.formattedBalance,
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildIconButton(
                          icon: Icons.refresh,
                          onTap: () => walletProvider.loadBalance(),
                        ),
                        SizedBox(width: 8.w),
                        _buildIconButton(
                          icon: Icons.add,
                          onTap: () => context.go('/wallet'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 16.h),
              
              // Stats row
              Row(
                children: [
                  _buildStatItem('Balance', walletProvider.formattedBalance),
                  SizedBox(width: 12.w),
                  _buildStatItem('Role', (user?.role ?? 'user').toUpperCase()),
                  SizedBox(width: 12.w),
                  _buildStatItem('Status', user?.isVerified == true ? 'Verified' : 'New'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: Colors.white, size: 18.sp),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.send,
            label: 'Buy Airtime',
            color: AppColors.mtn,
            onTap: () => context.go('/airtime'),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.wifi,
            label: 'Buy Data',
            color: AppColors.airtel,
            onTap: () => context.go('/data'),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.account_balance_wallet,
            label: 'Fund Wallet',
            color: AppColors.success,
            onTap: () => context.go('/wallet'),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28.sp),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildServicesGrid() {
    final services = [
      _ServiceItem(Icons.phone_android, 'Airtime', AppColors.mtn, '/airtime'),
      _ServiceItem(Icons.wifi, 'Data', AppColors.airtel, '/data'),
      _ServiceItem(Icons.tv, 'TV', AppColors.secondary, '/tv'),
      _ServiceItem(Icons.electric_bolt, 'Electricity', AppColors.warning, '/electricity'),
      _ServiceItem(Icons.school, 'Exam PIN', AppColors.info, '/exam'),
      _ServiceItem(Icons.receipt_long, 'History', AppColors.glo, '/transactions'),
      _ServiceItem(Icons.swap_horiz, 'Transfer', AppColors.secondary, '/transfer'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.85,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceCard(
          icon: service.icon,
          label: service.label,
          color: service.color,
          onTap: () => context.go(service.route),
        );
      },
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(icon, color: color, size: 28.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Consumer<WalletProvider>(
      builder: (context, walletProvider, child) {
        if (walletProvider.recentTransactions.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Recent Transactions'),
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(30.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 48.sp,
                      color: AppColors.textLight,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'No transactions yet',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Your transactions will appear here',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle('Recent Transactions'),
                TextButton(
                  onPressed: () => context.go('/transactions'),
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ...walletProvider.recentTransactions.take(5).map(
              (transaction) => TransactionTile(transaction: transaction),
            ),
          ],
        );
      },
    );
  }
}

class _ServiceItem {
  final IconData icon;
  final String label;
  final Color color;
  final String route;

  _ServiceItem(this.icon, this.label, this.color, this.route);
}