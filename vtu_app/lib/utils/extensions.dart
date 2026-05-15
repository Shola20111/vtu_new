// import 'package:intl/intl.dart';

// extension StringExtension on String {
//   String capitalize() {
//     if (isEmpty) return this;
//     return this[0].toUpperCase() + substring(1).toLowerCase();
//   }

//   String maskPhoneNumber() {
//     if (length >= 11) {
//       return '${substring(0, 3)}****${substring(length - 4)}';
//     }
//     return this;
//   }

//   String get initials {
//     final parts = split(' ');
//     if (parts.length >= 2) {
//       return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
//     }
//     return substring(0, 1).toUpperCase();
//   }
// }

// extension DateTimeExtension on DateTime {
//   String formatDate() {
//     return DateFormat('dd MMM yyyy').format(this);
//   }

//   String formatDateTime() {
//     return DateFormat('dd MMM yyyy, hh:mm a').format(this);
//   }

//   String formatTime() {
//     return DateFormat('hh:mm a').format(this);
//   }

//   String timeAgo() {
//     final now = DateTime.now();
//     final difference = now.difference(this);

//     if (difference.inDays > 365) {
//       return '${(difference.inDays / 365).floor()} year(s) ago';
//     } else if (difference.inDays > 30) {
//       return '${(difference.inDays / 30).floor()} month(s) ago';
//     } else if (difference.inDays > 0) {
//       return '${difference.inDays} day(s) ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours} hour(s) ago';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes} minute(s) ago';
//     } else {
//       return 'Just now';
//     }
//   }
// }

// extension DoubleExtension on double {
//   String formatCurrency() {
//     return NumberFormat.currency(
//       symbol: '₦',
//       decimalDigits: 2,
//     ).format(this);
//   }

//   String formatCompact() {
//     if (this >= 1000000) {
//       return '₦${(this / 1000000).toStringAsFixed(1)}M';
//     } else if (this >= 1000) {
//       return '₦${(this / 1000).toStringAsFixed(1)}K';
//     }
//     return formatCurrency();
//   }
// }

// extension NumExtension on num {
//   String formatCurrency() {
//     return NumberFormat.currency(
//       symbol: '₦',
//       decimalDigits: 2,
//     ).format(this);
//   }
// }



import 'package:intl/intl.dart';

extension StringExtension on String {

  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;

    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// Mask phone number
  /// Example:
  /// 08123456789 => 081****6789
  String maskPhoneNumber() {
    if (length >= 11) {
      return '${substring(0, 3)}****${substring(length - 4)}';
    }

    return this;
  }

  /// Get initials from full name
  /// Example:
  /// John Doe => JD
  String get initials {
    final parts = trim().split(' ');

    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    return substring(0, 1).toUpperCase();
  }
}

extension DateTimeExtension on DateTime {

  /// 13 May 2026
  String formatDate() {
    return DateFormat('dd MMM yyyy').format(this);
  }

  /// 13 May 2026, 09:30 AM
  String formatDateTime() {
    return DateFormat('dd MMM yyyy, hh:mm a').format(this);
  }

  /// 09:30 AM
  String formatTime() {
    return DateFormat('hh:mm a').format(this);
  }

  /// Human readable time ago
  String timeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} day(s) ago';
    }

    if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} week(s) ago';
    }

    if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} month(s) ago';
    }

    return '${(difference.inDays / 365).floor()} year(s) ago';
  }
}

extension DoubleExtension on double {

  /// ₦1,000.00
  String formatCurrency() {
    return NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    ).format(this);
  }

  /// ₦1.5K / ₦2.3M
  String formatCompact() {

    if (this >= 1000000) {
      return '₦${(this / 1000000).toStringAsFixed(1)}M';
    }

    if (this >= 1000) {
      return '₦${(this / 1000).toStringAsFixed(1)}K';
    }

    return formatCurrency();
  }
}

extension NumExtension on num {

  String formatCurrency() {
    return NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    ).format(this);
  }
}