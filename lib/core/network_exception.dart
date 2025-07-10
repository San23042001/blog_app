import 'package:dio/dio.dart';

class NetworkExceptions implements Exception {
  final String message;

  NetworkExceptions(this.message);

  static NetworkExceptions getDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkExceptions("Connection Timeout");
      case DioExceptionType.sendTimeout:
        return NetworkExceptions("Send Timeout");
      case DioExceptionType.receiveTimeout:
        return NetworkExceptions("Receive Timeout");
      case DioExceptionType.badCertificate:
        return NetworkExceptions("Bad Certificate");
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      case DioExceptionType.cancel:
        return NetworkExceptions("Request Cancelled");
      case DioExceptionType.connectionError:
        return NetworkExceptions("No Internet Connection");
      case DioExceptionType.unknown:
        return NetworkExceptions("Unexpected error occurred");
    }
  }

  static NetworkExceptions _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;
    final defaultMessage = response?.statusMessage ?? "Server Error";

    String extractValidationMessage(Map<String, dynamic>? data) {
      if (data == null) return "Bad Request";
      if (data['code'] == "ValidationError" &&
          data['errors'] is Map<String, dynamic>) {
        final errors = data['errors'] as Map<String, dynamic>;
        // Pick first error message
        for (var fieldError in errors.values) {
          if (fieldError is Map<String, dynamic> &&
              fieldError.containsKey('msg')) {
            return fieldError['msg'] as String;
          }
        }
      }
      return data['message'] ?? "Bad Request";
    }

    switch (statusCode) {
      case 400:
        final msg = extractValidationMessage(data);
        return NetworkExceptions("Bad Request: $msg");
      case 401:
        return NetworkExceptions(
          "Unauthorized: ${data?['message'] ?? defaultMessage}",
        );
      case 403:
        return NetworkExceptions(
          "Forbidden: ${data?['message'] ?? defaultMessage}",
        );
      case 404:
        return NetworkExceptions(
          "Not Found: ${data?['message'] ?? defaultMessage}",
        );
      case 409:
        return NetworkExceptions(
          "Conflict: ${data?['message'] ?? defaultMessage}",
        );
      case 500:
        return NetworkExceptions(
          "Internal Server Error: ${data?['message'] ?? defaultMessage}",
        );
      default:
        return NetworkExceptions(
          "HTTP $statusCode: ${data?['message'] ?? defaultMessage}",
        );
    }
  }

  @override
  String toString() => message;
}
