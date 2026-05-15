// import "package:vtu_app/core/services/vtu_service.dart";
// import "package:vtu_app/core/models/transaction.dart";
// import "package:flutter/material.dart";
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:vtu_app/core/models/transaction.dart';
// import 'package:vtu_app/core/services/vtu_service.dart';

// class WalletProvider extends ChangeNotifier {
//   final VTUService _vtuService = VTUService();
  
//   double _balance = 0.0;
//   bool _isLoading = false;
//   String? _error;
//   List<Transaction> _recentTransactions = [];
  
//   double get balance => _balance;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   List<Transaction> get recentTransactions => _recentTransactions;
  
//   // Load wallet balance
//   Future<void> loadBalance() async {
//     _setLoading(true);
//     _clearError();
    
//     try {
//       _balance = await _vtuService.getWalletBalance();
//       _setLoading(false);
//     } catch (e) {
//       _setError(e.toString());
//       _setLoading(false);
//     }
//   }
  
//   // Load recent transactions for wallet screen
//   Future<void> loadRecentTransactions() async {
//     try {
//       _recentTransactions = await _vtuService.getTransactions(
//         page: 1,
//         limit: 5,
//       );
//       notifyListeners();
//     } catch (e) {
//       // Silent fail for recent transactions
//     }
//   }
  
//   // Refresh all wallet data
//   Future<void> refreshWallet() async {
//     await Future.wait([
//       loadBalance(),
//       loadRecentTransactions(),
//     ]);
//   }
  
//   // Update balance after transaction
//   void updateBalance(double newBalance) {
//     _balance = newBalance;
//     notifyListeners();
//   }
  
//   // Deduct amount locally (optimistic update)
//   void deductAmount(double amount) {
//     if (_balance >= amount) {
//       _balance -= amount;
//       notifyListeners();
//     }
//   }
  
//   // Check if balance is sufficient
//   bool hasSufficientBalance(double amount) {
//     return _balance >= amount;
//   }
  
//   // Get balance formatted as string
//   String get formattedBalance {
//     return '₦${_balance.toStringAsFixed(2)}';
//   }
  
//   // Get compact balance (e.g., ₦1.5K, ₦2.3M)
//   String get compactBalance {
//     if (_balance >= 1000000) {
//       return '₦${(_balance / 1000000).toStringAsFixed(1)}M';
//     } else if (_balance >= 1000) {
//       return '₦${(_balance / 1000).toStringAsFixed(1)}K';
//     }
//     return formattedBalance;
//   }
  
//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }
  
//   void _setError(String error) {
//     _error = error;
//     notifyListeners();
//   }
  
//   void _clearError() {
//     _error = null;
//     notifyListeners();
//   }
// }


import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:vtu_app/core/models/transaction.dart';
import 'package:vtu_app/core/services/vtu_service.dart';

class WalletProvider extends ChangeNotifier {
  final VTUService _vtuService =
      VTUService();

  /// Wallet balance
  double _balance = 0.0;

  /// Loading states
  bool _isLoadingBalance = false;

  bool _isLoadingTransactions =
      false;

  /// Error state
  String? _error;

  /// Transactions
  List<Transaction>
      _recentTransactions = [];

  /// Pagination
  int _currentPage = 1;

  bool _hasMore = true;

  bool _isFetchingMore = false;

  /// Prevent duplicate refreshes
  bool _isRefreshing = false;

  /// Getters
  double get balance => _balance;

  bool get isLoadingBalance =>
      _isLoadingBalance;

  bool get isLoadingTransactions =>
      _isLoadingTransactions;

  bool get isFetchingMore =>
      _isFetchingMore;

  bool get hasMore => _hasMore;

  String? get error => _error;

  List<Transaction>
      get recentTransactions =>
          List.unmodifiable(
            _recentTransactions,
          );

  /// Load wallet balance
  Future<void> loadBalance({
    bool silent = false,
  }) async {
    if (_isLoadingBalance) return;

    if (!silent) {
      _setBalanceLoading(true);
    }

    _clearError();

    try {
      final balance =
          await _vtuService
              .getWalletBalance();

      _balance = balance;

      if (!silent) {
        _setBalanceLoading(false);
      }

      notifyListeners();
    } catch (e) {
      _setError(
        _formatError(e),
      );

      if (!silent) {
        _setBalanceLoading(false);
      }
    }
  }

  /// Load recent transactions
  Future<void>
      loadRecentTransactions({
    bool refresh = false,
  }) async {
    if (_isLoadingTransactions ||
        _isFetchingMore) {
      return;
    }

    if (refresh) {
      _currentPage = 1;

      _hasMore = true;

      _recentTransactions = [];
    }

    if (!_hasMore) return;

    if (_currentPage == 1) {
      _setTransactionsLoading(
        true,
      );
    } else {
      _isFetchingMore = true;

      notifyListeners();
    }

    try {
      final transactions =
          await _vtuService
              .getTransactions(
        page: _currentPage,
        limit: 10,
      );

      if (transactions.isEmpty) {
        _hasMore = false;
      } else {
        if (_currentPage == 1) {
          _recentTransactions =
              transactions;
        } else {
          _recentTransactions
              .addAll(
            transactions,
          );
        }

        _currentPage++;
      }

      _setTransactionsLoading(
        false,
      );

      _isFetchingMore = false;

      notifyListeners();
    } catch (e) {
      _setError(
        _formatError(e),
      );

      _setTransactionsLoading(
        false,
      );

      _isFetchingMore = false;
    }
  }

  /// Refresh everything
  Future<void> refreshWallet() async {
    if (_isRefreshing) return;

    _isRefreshing = true;

    try {
      await Future.wait([
        loadBalance(
          silent: true,
        ),

        loadRecentTransactions(
          refresh: true,
        ),
      ]);
    } finally {
      _isRefreshing = false;

      notifyListeners();
    }
  }

  /// Update balance manually
  void updateBalance(
    double newBalance,
  ) {
    _balance = newBalance;

    notifyListeners();
  }

  /// Optimistic deduction
  bool deductAmount(
    double amount,
  ) {
    if (!hasSufficientBalance(
      amount,
    )) {
      return false;
    }

    _balance -= amount;

    notifyListeners();

    return true;
  }

  /// Rollback failed deduction
  void rollbackDeduction(
    double amount,
  ) {
    _balance += amount;

    notifyListeners();
  }

  /// Add new transaction locally
  void addTransaction(
    Transaction transaction,
  ) {
    _recentTransactions.insert(
      0,
      transaction,
    );

    notifyListeners();
  }

  /// Clear wallet state
  void clearWallet() {
    _balance = 0.0;

    _error = null;

    _currentPage = 1;

    _hasMore = true;

    _recentTransactions = [];

    notifyListeners();
  }

  /// Sufficient balance check
  bool hasSufficientBalance(
    double amount,
  ) {
    return _balance >= amount;
  }

  /// Formatted balance
  String get formattedBalance {
    return '₦${_balance.toStringAsFixed(2)}';
  }

  /// Compact balance
  String get compactBalance {
    if (_balance >= 1000000) {
      return '₦${(_balance / 1000000).toStringAsFixed(1)}M';
    }

    if (_balance >= 1000) {
      return '₦${(_balance / 1000).toStringAsFixed(1)}K';
    }

    return formattedBalance;
  }

  /// Loading helpers
  void _setBalanceLoading(
    bool value,
  ) {
    _isLoadingBalance = value;

    notifyListeners();
  }

  void _setTransactionsLoading(
    bool value,
  ) {
    _isLoadingTransactions =
        value;

    notifyListeners();
  }

  /// Error handling
  void _setError(String error) {
    _error = error;

    notifyListeners();
  }

  void clearError() {
    _clearError();
  }

  void _clearError() {
    _error = null;
  }

  /// User-friendly errors
  String _formatError(
    dynamic error,
  ) {
    final message =
        error.toString();

    if (message.contains(
        'SocketException')) {
      return 'No internet connection';
    }

    if (message.contains(
        'timeout')) {
      return 'Request timeout';
    }

    return 'Something went wrong';
  }
}