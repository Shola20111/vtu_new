// import 'package:dio/dio.dart';
// import 'package:vtu_app/core/constants/api_constants.dart';
// import 'package:vtu_app/core/models/user.dart';
// import 'package:vtu_app/core/network/api_client.dart';

// class AuthService {
//   final Dio _dio = ApiClient().dio;

//   // Register
//   Future<AuthResponse> register(RegisterRequest request) async {
//     try {
//       final response = await _dio.post(
//         ApiConstants.register,
//         data: request.toJson(),
//       );
//       return AuthResponse.fromJson(response.data);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   // Login
//   Future<AuthResponse> login(LoginRequest request) async {
//     try {
//       final response = await _dio.post(
//         ApiConstants.login,
//         data: request.toJson(),
//       );
//       return AuthResponse.fromJson(response.data);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   // Get Profile
//   Future<User> getProfile() async {
//     try {
//       final response = await _dio.get(ApiConstants.profile);
//       final data = response.data;
//       if (data['success'] == true && data['user'] != null) {
//         return User.fromJson(data['user']);
//       }
//       throw Exception('Failed to load profile');
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   String _handleError(DioException e) {
//     if (e.response?.data != null) {
//       final message = e.response?.data['message'];
//       if (message != null) return message;
//     }
    
//     switch (e.type) {
//       case DioExceptionType.connectionTimeout:
//         return 'Connection timeout. Please check your internet.';
//       case DioExceptionType.connectionError:
//         return 'No internet connection. Please check and try again.';
//       case DioExceptionType.badResponse:
//         if (e.response?.statusCode == 401) {
//           return 'Invalid credentials. Please try again.';
//         }
//         return 'Server error. Please try again later.';
//       default:
//         return 'An error occurred: ${e.message}';
//     }
//   }
// }


import 'package:dio/dio.dart';

import 'package:vtu_app/core/constants/api_constants.dart';
import 'package:vtu_app/core/models/user.dart';
import 'package:vtu_app/core/network/api_client.dart';

class AuthService {
  final Dio _dio = ApiClient().dio;

  /// Register
  Future<AuthResponse> register(
    RegisterRequest request,
  ) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: request.toJson(),
      );

      return _parseAuthResponse(
        response,
      );
    } on DioException catch (e) {
      throw Exception(
        _handleError(e),
      );
    } catch (e) {
      throw Exception(
        'Registration failed',
      );
    }
  }

  /// Login
  Future<AuthResponse> login(
    LoginRequest request,
  ) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: request.toJson(),
      );

      return _parseAuthResponse(
        response,
      );
    } on DioException catch (e) {
      throw Exception(
        _handleError(e),
      );
    } catch (e) {
      throw Exception(
        'Login failed',
      );
    }
  }

  /// Get authenticated profile
  Future<User> getProfile() async {
    try {
      final response = await _dio.get(
        ApiConstants.profile,
      );

      final data = response.data;

      if (data == null ||
          data is! Map<String, dynamic>) {
        throw Exception(
          'Invalid server response',
        );
      }

      if (response.statusCode != 200) {
        throw Exception(
          data['message'] ??
              'Failed to load profile',
        );
      }

      if (data['success'] != true ||
          data['user'] == null) {
        throw Exception(
          data['message'] ??
              'Failed to load profile',
        );
      }

      return User.fromJson(
        data['user'],
      );
    } on DioException catch (e) {
      throw Exception(
        _handleError(e),
      );
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  /// Parse auth response safely
  AuthResponse _parseAuthResponse(
    Response response,
  ) {
    final data = response.data;

    if (data == null ||
        data is! Map<String, dynamic>) {
      throw Exception(
        'Invalid server response',
      );
    }

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception(
        data['message'] ??
            'Request failed',
      );
    }

    return AuthResponse.fromJson(
      data,
    );
  }

  /// Handle Dio errors
  String _handleError(
    DioException e,
  ) {
    final responseData =
        e.response?.data;

    /// Backend message
    if (responseData != null &&
        responseData is Map<String, dynamic>) {
      final message =
          responseData['message'];

      if (message != null &&
          message.toString().isNotEmpty) {
        return message.toString();
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet.';

      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';

      case DioExceptionType.receiveTimeout:
        return 'Server is taking too long to respond.';

      case DioExceptionType.connectionError:
        return 'No internet connection.';

      case DioExceptionType.badCertificate:
        return 'Secure connection failed.';

      case DioExceptionType.badResponse:
        final statusCode =
            e.response?.statusCode;

        switch (statusCode) {
          case 400:
            return 'Bad request';

          case 401:
            return 'Invalid credentials';

          case 403:
            return 'Access denied';

          case 404:
            return 'Resource not found';

          case 422:
            return 'Invalid input data';

          case 500:
            return 'Internal server error';

          default:
            return 'Server error occurred';
        }

      case DioExceptionType.cancel:
        return 'Request was cancelled';

      case DioExceptionType.unknown:
        return 'Unexpected error occurred';
    }
  }
}