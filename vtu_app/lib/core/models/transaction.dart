// import "package:vtu_app/core/constants/app_colors.dart";
// import "package:flutter/material.dart";
// import "package:flutter/material.dart";
// class Transaction {
//   final String id;
//   final String requestId;
//   final String serviceType;
//   final String serviceName;
//   final double amount;
//   final String phone;
//   final String status;
//   final DateTime createdAt;
//   final ProviderResponse? providerResponse;

//   Transaction({
//     required this.id,
//     required this.requestId,
//     required this.serviceType,
//     required this.serviceName,
//     required this.amount,
//     required this.phone,
//     required this.status,
//     required this.createdAt,
//     this.providerResponse,
//   });

//   factory Transaction.fromJson(Map<String, dynamic> json) {
//     return Transaction(
//       id: json['id'] ?? json['_id'] ?? '',
//       requestId: json['requestId'] ?? '',
//       serviceType: json['serviceType'] ?? '',
//       serviceName: json['serviceName'] ?? '',
//       amount: (json['amount'] ?? 0).toDouble(),
//       phone: json['phone'] ?? '',
//       status: json['status'] ?? 'pending',
//       createdAt: json['createdAt'] != null 
//           ? DateTime.parse(json['createdAt']) 
//           : DateTime.now(),
//       providerResponse: json['providerResponse'] != null 
//           ? ProviderResponse.fromJson(json['providerResponse']) 
//           : null,
//     );
//   }

//   Color get statusColor {
//     switch (status.toLowerCase()) {
//       case 'successful':
//         return AppColors.success;
//       case 'failed':
//         return AppColors.error;
//       case 'processing':
//         return AppColors.warning;
//       default:
//         return AppColors.textSecondary;
//     }
//   }

//   IconData get serviceIcon {
//     switch (serviceType.toLowerCase()) {
//       case 'airtime':
//         return Icons.phone_android;
//       case 'data':
//         return Icons.wifi;
//       case 'tv':
//         return Icons.tv;
//       case 'electricity':
//         return Icons.electric_bolt;
//       case 'exam':
//         return Icons.school;
//       default:
//         return Icons.receipt;
//     }
//   }
// }

// class ProviderResponse {
//   final String? code;
//   final String? message;
//   final String? token;
//   final String? units;

//   ProviderResponse({
//     this.code,
//     this.message,
//     this.token,
//     this.units,
//   });

//   factory ProviderResponse.fromJson(Map<String, dynamic> json) {
//     return ProviderResponse(
//       code: json['code'],
//       message: json['message'],
//       token: json['token'],
//       units: json['units'],
//     );
//   }
// }

// // VTU Request Models
// class AirtimeRequest {
//   final String network;
//   final String phone;
//   final double amount;

//   AirtimeRequest({
//     required this.network,
//     required this.phone,
//     required this.amount,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'network': network,
//       'phone': phone,
//       'amount': amount,
//     };
//   }
// }

// class DataRequest {
//   final String network;
//   final String phone;
//   final String dataPlan;

//   DataRequest({
//     required this.network,
//     required this.phone,
//     required this.dataPlan,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'network': network,
//       'phone': phone,
//       'dataPlan': dataPlan,
//     };
//   }
// }

// class VTUResponse {
//   final bool success;
//   final String message;
//   final TransactionResponse? transaction;

//   VTUResponse({
//     required this.success,
//     required this.message,
//     this.transaction,
//   });

//   factory VTUResponse.fromJson(Map<String, dynamic> json) {
//     return VTUResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       transaction: json['transaction'] != null 
//           ? TransactionResponse.fromJson(json['transaction']) 
//           : null,
//     );
//   }
// }

// class TransactionResponse {
//   final String id;
//   final String requestId;
//   final double amount;
//   final String phone;
//   final String? network;
//   final String? token;
//   final String? units;

//   TransactionResponse({
//     required this.id,
//     required this.requestId,
//     required this.amount,
//     required this.phone,
//     this.network,
//     this.token,
//     this.units,
//   });

//   factory TransactionResponse.fromJson(Map<String, dynamic> json) {
//     return TransactionResponse(
//       id: json['id'] ?? '',
//       requestId: json['requestId'] ?? '',
//       amount: (json['amount'] ?? 0).toDouble(),
//       phone: json['phone'] ?? '',
//       network: json['network'],
//       token: json['token'],
//       units: json['units'],
//     );
//   }
// }

import 'package:flutter/material.dart';


enum TransactionStatus {
  pending,
  processing,
  successful,
  failed,
  reversed,
}

enum ServiceType {
  airtime,
  data,
  electricity,
  tv,
  exam,
  wallet,
  unknown,
}

class Transaction {
  final String id;

  final String requestId;

  final ServiceType serviceType;

  final String serviceName;

  /// Store as kobo/cents internally
  final int amountInKobo;

  final String phone;

  final TransactionStatus status;

  final DateTime createdAt;

  final ProviderResponse?
      providerResponse;

  const Transaction({
    required this.id,
    required this.requestId,
    required this.serviceType,
    required this.serviceName,
    required this.amountInKobo,
    required this.phone,
    required this.status,
    required this.createdAt,
    this.providerResponse,
  });

Color get statusColor {
  switch (status.toString().toLowerCase()) {
    case 'success':
      return Colors.green;

    case 'failed':
      return Colors.red;

    case 'pending':
      return Colors.orange;

    default:
      return Colors.grey;
  }
}

IconData get serviceIcon {
  switch (serviceType.toString().toLowerCase()) {
    case 'airtime':
      return Icons.phone_android;

    case 'data':
      return Icons.wifi;

    case 'electricity':
      return Icons.flash_on;

    case 'tv':
      return Icons.tv;

    default:
      return Icons.receipt;
  }
}

  /// Convert to naira
  double get amount =>
      amountInKobo / 100;

  factory Transaction.fromJson(
    Map<String, dynamic> json,
  ) {
    return Transaction(
      id:
          json['id']
              ?.toString() ??
          json['_id']
              ?.toString() ??
          '',

      requestId:
          json['requestId']
              ?.toString() ??
          '',

      serviceType:
          _parseServiceType(
        json['serviceType'],
      ),

      serviceName:
          json['serviceName']
              ?.toString() ??
          '',

      amountInKobo:
          _parseAmount(
        json['amount'],
      ),

      phone:
          json['phone']
              ?.toString() ??
          '',

      status:
          _parseStatus(
        json['status'],
      ),

      createdAt:
          _parseDate(
        json['createdAt'],
      ),

      providerResponse:
          json['providerResponse'] !=
                  null
              ? ProviderResponse
                  .fromJson(
                  json[
                      'providerResponse'],
                )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'requestId': requestId,

      'serviceType':
          serviceType.name,

      'serviceName':
          serviceName,

      'amount':
          amountInKobo / 100,

      'phone': phone,

      'status': status.name,

      'createdAt':
          createdAt.toIso8601String(),

      'providerResponse':
          providerResponse
              ?.toJson(),
    };
  }

  Transaction copyWith({
    String? id,
    String? requestId,
    ServiceType? serviceType,
    String? serviceName,
    int? amountInKobo,
    String? phone,
    TransactionStatus? status,
    DateTime? createdAt,
    ProviderResponse?
        providerResponse,
  }) {
    return Transaction(
      id: id ?? this.id,

      requestId:
          requestId ??
              this.requestId,

      serviceType:
          serviceType ??
              this.serviceType,

      serviceName:
          serviceName ??
              this.serviceName,

      amountInKobo:
          amountInKobo ??
              this.amountInKobo,

      phone:
          phone ?? this.phone,

      status:
          status ?? this.status,

      createdAt:
          createdAt ??
              this.createdAt,

      providerResponse:
          providerResponse ??
              this.providerResponse,
    );
  }

  static TransactionStatus
      _parseStatus(dynamic value) {
    switch (value
        ?.toString()
        .toLowerCase()) {
      case 'successful':
        return TransactionStatus
            .successful;

      case 'processing':
        return TransactionStatus
            .processing;

      case 'failed':
        return TransactionStatus
            .failed;

      case 'reversed':
        return TransactionStatus
            .reversed;

      default:
        return TransactionStatus
            .pending;
    }
  }

  static ServiceType
      _parseServiceType(
    dynamic value,
  ) {
    switch (value
        ?.toString()
        .toLowerCase()) {
      case 'airtime':
        return ServiceType.airtime;

      case 'data':
        return ServiceType.data;

      case 'electricity':
        return ServiceType
            .electricity;

      case 'tv':
        return ServiceType.tv;

      case 'exam':
        return ServiceType.exam;

      case 'wallet':
        return ServiceType.wallet;

      default:
        return ServiceType.unknown;
    }
  }

  static int _parseAmount(
    dynamic value,
  ) {
    final amount =
        double.tryParse(
              value.toString(),
            ) ??
            0;

    return (amount * 100)
        .round();
  }

  static DateTime _parseDate(
    dynamic value,
  ) {
    if (value == null) {
      return DateTime.now();
    }

    return DateTime.tryParse(
          value.toString(),
        ) ??
        DateTime.now();
  }
}

class ProviderResponse {
  final String? code;

  final String? message;

  final String? token;

  final String? units;

  const ProviderResponse({
    this.code,
    this.message,
    this.token,
    this.units,
  });

  factory ProviderResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProviderResponse(
      code:
          json['code']
              ?.toString(),

      message:
          json['message']
              ?.toString(),

      token:
          json['token']
              ?.toString(),

      units:
          json['units']
              ?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,

      'message': message,

      'token': token,

      'units': units,
    };
  }
}

/// Airtime Request
class AirtimeRequest {
  final String network;

  final String phone;

  final int amountInKobo;

  final String requestId;

  const AirtimeRequest({
    required this.network,
    required this.phone,
    required this.amountInKobo,
    required this.requestId,
  });

  Map<String, dynamic> toJson() {
    return {
      'network': network,

      'phone': phone,

      'amount':
          amountInKobo / 100,

      'requestId': requestId,
    };
  }
}

/// Data Request
class DataRequest {
  final String network;

  final String phone;

  final String dataPlan;

  final String requestId;

  const DataRequest({
    required this.network,
    required this.phone,
    required this.dataPlan,
    required this.requestId,
  });

  Map<String, dynamic> toJson() {
    return {
      'network': network,

      'phone': phone,

      'dataPlan': dataPlan,

      'requestId': requestId,
    };
  }
}

class VTUResponse {
  final bool success;

  final String message;

  final TransactionResponse?
      transaction;

  const VTUResponse({
    required this.success,
    required this.message,
    this.transaction,
  });

  factory VTUResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return VTUResponse(
      success:
          json['success'] ==
          true,

      message:
          json['message']
              ?.toString() ??
          '',

      transaction:
          json['transaction'] !=
                  null
              ? TransactionResponse
                  .fromJson(
                  json[
                      'transaction'],
                )
              : null,
    );
  }
}

class TransactionResponse {
  final String id;

  final String requestId;

  final int amountInKobo;

  final String phone;

  final String? network;

  final String? token;

  final String? units;

  const TransactionResponse({
    required this.id,
    required this.requestId,
    required this.amountInKobo,
    required this.phone,
    this.network,
    this.token,
    this.units,
  });

  double get amount =>
      amountInKobo / 100;

  factory TransactionResponse
      .fromJson(
    Map<String, dynamic> json,
  ) {
    return TransactionResponse(
      id:
          json['id']
              ?.toString() ??
          '',

      requestId:
          json['requestId']
              ?.toString() ??
          '',

      amountInKobo:
          Transaction
              ._parseAmount(
        json['amount'],
      ),

      phone:
          json['phone']
              ?.toString() ??
          '',

      network:
          json['network']
              ?.toString(),

      token:
          json['token']
              ?.toString(),

      units:
          json['units']
              ?.toString(),
    );
  }
}

class ElectricityRequest {
  final String disco;
  final String meterNumber;
  final int amountInKobo;
  final String meterType;
  final String requestId;

  ElectricityRequest({
    required this.disco,
    required this.meterNumber,
    required this.amountInKobo,
    required this.meterType,
    required this.requestId,
  });

  Map<String, dynamic> toJson() {
    return {
      'disco': disco,
      'meterNumber': meterNumber,
      'amount': amountInKobo,
      'meterType': meterType,
      'requestId': requestId,
    };
  }
}

class TVRequest {
  final String provider;
  final String smartcardNumber;
  final String package;
  final String requestId;

  TVRequest({
    required this.provider,
    required this.smartcardNumber,
    required this.package,
    required this.requestId,
  });

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'smartcardNumber': smartcardNumber,
      'package': package,
      'requestId': requestId,
    };
  }
}

class ExamPinRequest {
  final String examType;
  final int quantity;
  final String requestId;

  ExamPinRequest({
    required this.examType,
    required this.quantity,
    required this.requestId,
  });

  Map<String, dynamic> toJson() {
    return {
      'examType': examType,
      'quantity': quantity,
      'requestId': requestId,
    };
  }
}