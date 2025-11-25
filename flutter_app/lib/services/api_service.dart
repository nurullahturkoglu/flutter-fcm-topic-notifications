import 'package:dio/dio.dart';

class ApiService {
  // For Android Emulator, use your local IP (e.g., 192.168.1.8:3000)
  // Find your IP: Windows (ipconfig), macOS/Linux (ifconfig)
  // For iOS Simulator, use localhost. For physical devices, use your local IP. (e.g., 192.168.1.8:3000)
  static const String baseUrl = 'http://localhost:3000';
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 5);
  }

  Future<ApiResponse> sendTopicNotification(String title, String body) async {
    try {
      final response = await _dio.post(
        '/api/topic/notify',
        data: {
          'title': title,
          'body': body,
        },
      );

      if (response.statusCode == 200) {
        return const ApiResponse(
          success: true,
          message: 'Notification sent successfully',
        );
      }
      return const ApiResponse(
        success: false,
        message: 'Failed to send notification',
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.message ?? 'Failed to send notification',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Unexpected error: $e',
      );
    }
  }

  Future<ApiResponse> sendTokenNotification(
      String token, String title, String body) async {
    try {
      final response = await _dio.post(
        '/api/token/notify',
        data: {
          'token': token,
          'title': title,
          'body': body,
        },
      );

      if (response.statusCode == 200) {
        return const ApiResponse(
          success: true,
          message: 'Notification sent successfully',
        );
      }
      return const ApiResponse(
        success: false,
        message: 'Failed to send notification',
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.message ?? 'Failed to send notification',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Unexpected error: $e',
      );
    }
  }
}

class ApiResponse {
  final bool success;
  final String message;

  const ApiResponse({
    required this.success,
    required this.message,
  });
}
