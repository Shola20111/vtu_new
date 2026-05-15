
// import 'package:dio/dio.dart';
// import 'package:vtu_app/core/constants/api_constants.dart';
// import 'package:vtu_app/core/services/storage_service.dart';

// class ApiInterceptor extends Interceptor {
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     final token = StorageService.getTokenSync();
//     if (token != null && token.isNotEmpty) {
//       options.headers[ApiConstants.authorization] = 
//           '${ApiConstants.bearer} $token';
//     }
//     handler.next(options);
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     if (err.response?.statusCode == 401) {
//       StorageService.clear();
//     }
//     handler.next(err);
//   }

//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     handler.next(response);
//   }
// }


import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:vtu_app/core/constants/api_constants.dart';
import 'package:vtu_app/core/services/storage_service.dart';

class ApiInterceptor extends Interceptor {
  bool _isRefreshing = false;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    try {
      final token =
          StorageService.getTokenSync();

      if (token != null &&
          token.isNotEmpty) {
        options.headers[
                ApiConstants.authorization] =
            '${ApiConstants.bearer} $token';
      }

      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: e,
        ),
      );
    }
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode =
        err.response?.statusCode;

    /// Unauthorized
    if (statusCode == 401) {
      try {
        /// Prevent multiple simultaneous clears
        if (!_isRefreshing) {
          _isRefreshing = true;

          await StorageService.clear();

          _isRefreshing = false;
        }
      } catch (e) {
        debugPrint(
          '401 handling error: $e',
        );
      }
    }

    /// Timeout handling
    if (err.type ==
            DioExceptionType.connectionTimeout ||
        err.type ==
            DioExceptionType.receiveTimeout ||
        err.type ==
            DioExceptionType.sendTimeout) {
      debugPrint(
        'Network timeout occurred',
      );
    }

    /// Network issues
    if (err.type ==
        DioExceptionType.connectionError) {
      debugPrint(
        'No internet connection',
      );
    }

    /// Server error logging
    if (statusCode != null &&
        statusCode >= 500) {
      debugPrint(
        'Server error: $statusCode',
      );
    }

    handler.next(err);
  }
}