// import 'package:dio/dio.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
// import 'package:vtu_app/core/constants/api_constants.dart';
// import 'package:vtu_app/core/network/api_interceptor.dart';

// class ApiClient {
//   static final ApiClient _instance = ApiClient._internal();
//   factory ApiClient() => _instance;
//   ApiClient._internal();

//   Dio? _dio;

//   Dio get dio {
//     _dio ??= _createDio();
//     return _dio!;
//   }

//   Dio _createDio() {
//     final dio = Dio(BaseOptions(
//       baseUrl: ApiConstants.baseUrl,
//       connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
//       receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       },
//     ));

//     dio.interceptors.add(ApiInterceptor());
//     dio.interceptors.add(
//       PrettyDioLogger(
//         requestHeader: true,
//         requestBody: true,
//         responseBody: true,
//         responseHeader: false,
//         error: true,
//         compact: true,
//       ),
//     );

//     return dio;
//   }

//   void updateToken(String token) {
//     dio.options.headers[ApiConstants.authorization] = 
//         '${ApiConstants.bearer} $token';
//   }

//   void clearToken() {
//     dio.options.headers.remove(ApiConstants.authorization);
//   }
// }


import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:vtu_app/core/constants/api_constants.dart';
import 'package:vtu_app/core/network/api_interceptor.dart';

class ApiClient {
  ApiClient._internal();

  static final ApiClient _instance =
      ApiClient._internal();

  factory ApiClient() => _instance;

  late final Dio _dio = _createDio();

  Dio get dio => _dio;

  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,

        connectTimeout: const Duration(
          milliseconds:
              ApiConstants.connectTimeout,
        ),

        receiveTimeout: const Duration(
          milliseconds:
              ApiConstants.receiveTimeout,
        ),

        sendTimeout: const Duration(
          milliseconds:
              ApiConstants.connectTimeout,
        ),

        responseType: ResponseType.json,

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },

        validateStatus: (status) {
          return status != null &&
              status >= 200 &&
              status < 500;
        },
      ),
    );

    /// Custom app interceptor
    dio.interceptors.add(
      ApiInterceptor(),
    );

    /// Logger (Debug only)
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,

          requestBody: true,

          responseBody: true,

          responseHeader: false,

          error: true,

          compact: true,

          maxWidth: 120,
        ),
      );
    }

    return dio;
  }

  /// Update authorization token
  void updateToken(String token) {
    _dio.options.headers[
            ApiConstants.authorization] =
        '${ApiConstants.bearer} $token';
  }

  /// Clear authorization token
  void clearToken() {
    _dio.options.headers.remove(
      ApiConstants.authorization,
    );
  }

  /// Generic GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Generic POST
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Generic PUT
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Generic DELETE
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}