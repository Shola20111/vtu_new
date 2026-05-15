// class User {
//   final String id;
//   final String fullName;
//   final String email;
//   final String username;
//   final String phone;
//   final String role;
//   final double walletBalance;
//   final double commissionRate;
//   final bool isVerified;
//   final DateTime? createdAt;

//   User({
//     required this.id,
//     required this.fullName,
//     required this.email,
//     required this.username,
//     required this.phone,
//     required this.role,
//     required this.walletBalance,
//     this.commissionRate = 0.0,
//     this.isVerified = false,
//     this.createdAt,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'] ?? json['_id'] ?? '',
//       fullName: json['fullName'] ?? '',
//       email: json['email'] ?? '',
//       username: json['username'] ?? '',
//       phone: json['phone'] ?? '',
//       role: json['role'] ?? 'user',
//       walletBalance: (json['walletBalance'] ?? 0).toDouble(),
//       commissionRate: (json['commissionRate'] ?? 0).toDouble(),
//       isVerified: json['isVerified'] ?? false,
//       createdAt: json['createdAt'] != null 
//           ? DateTime.parse(json['createdAt']) 
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'fullName': fullName,
//       'email': email,
//       'username': username,
//       'phone': phone,
//       'role': role,
//       'walletBalance': walletBalance,
//       'commissionRate': commissionRate,
//       'isVerified': isVerified,
//     };
//   }

//   User copyWith({
//     String? id,
//     String? fullName,
//     String? email,
//     String? username,
//     String? phone,
//     String? role,
//     double? walletBalance,
//     double? commissionRate,
//     bool? isVerified,
//     DateTime? createdAt,
//   }) {
//     return User(
//       id: id ?? this.id,
//       fullName: fullName ?? this.fullName,
//       email: email ?? this.email,
//       username: username ?? this.username,
//       phone: phone ?? this.phone,
//       role: role ?? this.role,
//       walletBalance: walletBalance ?? this.walletBalance,
//       commissionRate: commissionRate ?? this.commissionRate,
//       isVerified: isVerified ?? this.isVerified,
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }
// }

// class LoginRequest {
//   final String identifier;
//   final String password;

//   LoginRequest({required this.identifier, required this.password});

//   Map<String, dynamic> toJson() {
//     return {
//       'identifier': identifier,
//       'password': password,
//     };
//   }
// }

// class RegisterRequest {
//   final String fullName;
//   final String email;
//   final String username;
//   final String password;
//   final String phone;

//   RegisterRequest({
//     required this.fullName,
//     required this.email,
//     required this.username,
//     required this.password,
//     required this.phone,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'fullName': fullName,
//       'email': email,
//       'username': username,
//       'password': password,
//       'phone': phone,
//     };
//   }
// }

// class AuthResponse {
//   final bool success;
//   final User user;
//   final String? token;

//   AuthResponse({
//     required this.success,
//     required this.user,
//     this.token,
//   });

//   factory AuthResponse.fromJson(Map<String, dynamic> json) {
//     return AuthResponse(
//       success: json['success'] ?? false,
//       user: User.fromJson(json['user'] ?? {}),
//       token: json['token'],
//     );
//   }
// }


class User {
  final String id;

  final String fullName;

  final String email;

  final String username;

  final String phone;

  final String role;

  /// Store wallet as string/decimal from backend ideally
  /// Using double temporarily
  final double walletBalance;

  final double commissionRate;

  final bool isVerified;

  final DateTime? createdAt;

  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.username,
    required this.phone,
    required this.role,
    required this.walletBalance,
    this.commissionRate = 0.0,
    this.isVerified = false,
    this.createdAt,
  });

  factory User.fromJson(
    Map<String, dynamic> json,
  ) {
    return User(
      id: _parseString(
        json['id'] ?? json['_id'],
      ),

      fullName: _parseString(
        json['fullName'],
      ),

      email: _parseString(
        json['email'],
      ),

      username: _parseString(
        json['username'],
      ),

      phone: _parseString(
        json['phone'],
      ),

      role: _parseString(
        json['role'],
        fallback: 'user',
      ),

      walletBalance: _parseDouble(
        json['walletBalance'],
      ),

      commissionRate: _parseDouble(
        json['commissionRate'],
      ),

      isVerified:
          json['isVerified'] == true,

      createdAt: _parseDateTime(
        json['createdAt'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'fullName': fullName,

      'email': email,

      'username': username,

      'phone': phone,

      'role': role,

      'walletBalance': walletBalance,

      'commissionRate': commissionRate,

      'isVerified': isVerified,

      'createdAt':
          createdAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? username,
    String? phone,
    String? role,
    double? walletBalance,
    double? commissionRate,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,

      fullName:
          fullName ?? this.fullName,

      email: email ?? this.email,

      username:
          username ?? this.username,

      phone: phone ?? this.phone,

      role: role ?? this.role,

      walletBalance:
          walletBalance ??
              this.walletBalance,

      commissionRate:
          commissionRate ??
              this.commissionRate,

      isVerified:
          isVerified ??
              this.isVerified,

      createdAt:
          createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return '''
User(
  id: $id,
  fullName: $fullName,
  email: $email,
  username: $username,
  walletBalance: $walletBalance
)
''';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is User &&
            runtimeType ==
                other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode =>
      id.hashCode;

  /// Safe string parser
  static String _parseString(
    dynamic value, {
    String fallback = '',
  }) {
    if (value == null) {
      return fallback;
    }

    return value.toString();
  }

  /// Safe double parser
  static double _parseDouble(
    dynamic value,
  ) {
    if (value == null) {
      return 0.0;
    }

    if (value is int) {
      return value.toDouble();
    }

    if (value is double) {
      return value;
    }

    return double.tryParse(
          value.toString(),
        ) ??
        0.0;
  }

  /// Safe DateTime parser
  static DateTime? _parseDateTime(
    dynamic value,
  ) {
    if (value == null) {
      return null;
    }

    try {
      return DateTime.parse(
        value.toString(),
      );
    } catch (_) {
      return null;
    }
  }
}

class LoginRequest {
  final String identifier;

  final String password;

  const LoginRequest({
    required this.identifier,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'identifier':
          identifier.trim(),

      'password': password,
    };
  }
}

class RegisterRequest {
  final String fullName;

  final String email;

  final String username;

  final String password;

  final String phone;

  const RegisterRequest({
    required this.fullName,
    required this.email,
    required this.username,
    required this.password,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName':
          fullName.trim(),

      'email':
          email.trim().toLowerCase(),

      'username':
          username.trim(),

      'password': password,

      'phone': phone.trim(),
    };
  }
}

class AuthResponse {
  final bool success;

  final User? user;

  final String? token;

  final String? message;

  const AuthResponse({
    required this.success,
    this.user,
    this.token,
    this.message,
  });

  factory AuthResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return AuthResponse(
      success:
          json['success'] == true,

      user: json['user'] != null
          ? User.fromJson(
              json['user'],
            )
          : null,

      token: json['token']
          ?.toString(),

      message: json['message']
          ?.toString(),
    );
  }
}