// import 'package:dio/dio.dart';
// import 'package:vtu_app/core/constants/api_constants.dart';
// import 'package:vtu_app/core/models/data_plan.dart';
// import 'package:vtu_app/core/models/transaction.dart';
// import 'package:vtu_app/core/network/api_client.dart';

// class VTUService {
//   final Dio _dio = ApiClient().dio;

//   // Airtime
//   Future<VTUResponse> purchaseAirtime(AirtimeRequest request) async {
//     try {
//       final response = await _dio.post(
//         ApiConstants.airtime,
//         data: request.toJson(),
//       );
//       return VTUResponse.fromJson(response.data);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   // Data Plans
//   Future<DataPlanResponse> getDataPlans(String network) async {
//     try {
//       final response = await _dio.get('${ApiConstants.dataPlans}/$network');
//       return DataPlanResponse.fromJson(response.data);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   // Purchase Data
//   Future<VTUResponse> purchaseData(DataRequest request) async {
//     try {
//       final response = await _dio.post(
//         ApiConstants.data,
//         data: request.toJson(),
//       );
//       return VTUResponse.fromJson(response.data);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   // Electricity
//   Future<VTUResponse> purchaseElectricity(Map<String, dynamic> request) async {
//     try {
//       final response = await _dio.post(
//         ApiConstants.electricity,
//         data: request,
//       );
//       return VTUResponse.fromJson(response.data);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   // TV Subscription
//   Future<VTUResponse> purchaseTV(Map<String, dynamic> request) async {
//     try {
//       final response = await _dio.post(
//         ApiConstants.tv,
//         data: request,
//       );
//       return VTUResponse.fromJson(response.data);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   // Exam PIN
//   Future<VTUResponse> purchaseExamPIN(Map<String, dynamic> request) async {
//     try {
//       final response = await _dio.post(
//         ApiConstants.exam,
//         data: request,
//       );
//       return VTUResponse.fromJson(response.data);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   // Get Transactions
//   Future<List<Transaction>> getTransactions({
//     int page = 1,
//     int limit = 20,
//     String? serviceType,
//   }) async {
//     try {
//       final response = await _dio.get(
//         ApiConstants.transactions,
//         queryParameters: {
//           'page': page,
//           'limit': limit,
//           if (serviceType != null) 'serviceType': serviceType,
//         },
//       );
      
//       final data = response.data;
//       final transactions = (data['transactions'] as List?)
//           ?.map((t) => Transaction.fromJson(t))
//           .toList() ?? [];
      
//       return transactions;
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   // Wallet Balance
//   Future<double> getWalletBalance() async {
//     try {
//       final response = await _dio.get(ApiConstants.walletBalance);
//       return (response.data['data'] ?? 0).toDouble();
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   String _handleError(DioException e) {
//     if (e.response?.data != null && e.response?.data['message'] != null) {
//       return e.response?.data['message'];
//     }
    
//     switch (e.type) {
//       case DioExceptionType.connectionTimeout:
//         return 'Connection timeout. Please try again.';
//       case DioExceptionType.sendTimeout:
//         return 'Send timeout. Please try again.';
//       case DioExceptionType.receiveTimeout:
//         return 'Receive timeout. Please try again.';
//       case DioExceptionType.badResponse:
//         return 'Server error: ${e.response?.statusCode}';
//       case DioExceptionType.cancel:
//         return 'Request cancelled';
//       case DioExceptionType.connectionError:
//         return 'No internet connection';
//       default:
//         return 'An error occurred: ${e.message}';
//     }
//   }
// }


import 'package:dio/dio.dart';

import 'package:vtu_app/core/constants/api_constants.dart';

import 'package:vtu_app/core/models/data_plan.dart';
import 'package:vtu_app/core/models/transaction.dart';

import 'package:vtu_app/core/network/api_client.dart';

class VTUService {
  final Dio _dio = ApiClient().dio;

  /// Airtime Purchase
  Future<VTUResponse>
      purchaseAirtime(
    AirtimeRequest request,
  ) async {
    return _postVTURequest(
      endpoint:
          ApiConstants.airtime,

      data: request.toJson(),
    );
  }

  /// Get Data Plans
  Future<DataPlanResponse>
      getDataPlans(
    String network,
  ) async {
    try {
      final response =
          await _dio.get(
        '${ApiConstants.dataPlans}/$network',
      );

      _validateResponse(
        response,
      );

      return DataPlanResponse
          .fromJson(
        response.data,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception(
        'Failed to load data plans',
      );
    }
  }

  /// Purchase Data
  Future<VTUResponse>
      purchaseData(
    DataRequest request,
  ) async {
    return _postVTURequest(
      endpoint: ApiConstants.data,

      data: request.toJson(),
    );
  }

  /// Electricity
  Future<VTUResponse>
      purchaseElectricity(
    ElectricityRequest request,
  ) async {
    return _postVTURequest(
      endpoint:
          ApiConstants.electricity,

      data: request.toJson(),
    );
  }

  /// TV Subscription
  Future<VTUResponse>
      purchaseTV(
    TVRequest request,
  ) async {
    return _postVTURequest(
      endpoint: ApiConstants.tv,

      data: request.toJson(),
    );
  }

  /// Exam PIN
  Future<VTUResponse>
      purchaseExamPIN(
    ExamPinRequest request,
  ) async {
    return _postVTURequest(
      endpoint:
          ApiConstants.exam,

      data: request.toJson(),
    );
  }

  /// Transactions
  Future<List<Transaction>>
      getTransactions({
    int page = 1,
    int limit = 20,
    String? serviceType,
  }) async {
    try {
      final response =
          await _dio.get(
        ApiConstants.transactions,

        queryParameters: {
          'page': page,
          'limit': limit,

          if (serviceType != null)
            'serviceType':
                serviceType,
        },
      );

      _validateResponse(
        response,
      );

      final data =
          response.data;

      final transactions =
          (data['transactions']
                      as List?)
                  ?.map(
                    (json) =>
                        Transaction
                            .fromJson(
                      json,
                    ),
                  )
                  .toList() ??
              [];

      return transactions;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (_) {
      throw Exception(
        'Failed to load transactions',
      );
    }
  }

  /// Wallet Balance
  Future<double>
      getWalletBalance() async {
    try {
      final response =
          await _dio.get(
        ApiConstants.walletBalance,
      );

      _validateResponse(
        response,
      );

      final balance =
          response.data['data'];

      if (balance == null) {
        return 0.0;
      }

      return double.tryParse(
            balance.toString(),
          ) ??
          0.0;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (_) {
      throw Exception(
        'Failed to load wallet balance',
      );
    }
  }

  /// Generic VTU POST handler
  Future<VTUResponse>
      _postVTURequest({
    required String endpoint,
    required Map<String, dynamic>
        data,
  }) async {
    try {
      final response =
          await _dio.post(
        endpoint,
        data: data,
      );

      _validateResponse(
        response,
      );

      return VTUResponse
          .fromJson(
        response.data,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (_) {
      throw Exception(
        'Transaction failed',
      );
    }
  }

  /// Response validator
  void _validateResponse(
    Response response,
  ) {
    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception(
        'Unexpected server response',
      );
    }

    final data =
        response.data;

    if (data == null) {
      throw Exception(
        'Empty server response',
      );
    }

    if (data is Map &&
        data['success'] == false) {
      throw Exception(
        data['message'] ??
            'Operation failed',
      );
    }
  }

  /// Error handling
  String _handleError(
    DioException e,
  ) {
    final responseData =
        e.response?.data;

    if (responseData != null &&
        responseData is Map &&
        responseData['message'] !=
            null) {
      return responseData['message']
          .toString();
    }

    switch (e.type) {
      case DioExceptionType
            .connectionTimeout:
        return 'Connection timeout. Please try again.';

      case DioExceptionType
            .sendTimeout:
        return 'Request timeout. Please try again.';

      case DioExceptionType
            .receiveTimeout:
        return 'Server response timeout.';

      case DioExceptionType
            .badResponse:
        return _handleStatusCode(
          e.response?.statusCode,
        );

      case DioExceptionType.cancel:
        return 'Request cancelled';

      case DioExceptionType
            .connectionError:
        return 'No internet connection';

      default:
        return 'Something went wrong';
    }
  }

  /// Status code mapping
  String _handleStatusCode(
    int? statusCode,
  ) {
    switch (statusCode) {
      case 400:
        return 'Invalid request';

      case 401:
        return 'Unauthorized access';

      case 403:
        return 'Access denied';

      case 404:
        return 'Service not found';

      case 422:
        return 'Invalid transaction data';

      case 500:
        return 'Server error';

      case 503:
        return 'Service unavailable';

      default:
        return 'Unexpected server error';
    }
  }
}