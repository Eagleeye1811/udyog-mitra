import 'package:dio/dio.dart';
import './api_config.dart';
import './api_models.dart';

class ApiService {
  static final Dio _dio = ApiConfig.dio;

  // Generate business ideas with request cancellation
  static Future<Map<String, dynamic>> generateBusinessIdeas({
    required String skill,
    required String location,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        '/skill-to-business',
        data: {'skill': skill, 'location': location},
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // Validate business idea
  static Future<Map<String, dynamic>> validateIdea({
    required String idea,
    required String location,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        '/validate-idea',
        data: {'idea': idea, 'location': location},
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // Generate business roadmap
  static Future<Map<String, dynamic>> generateRoadmap({
    required String idea,
    required String location,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        '/generate-roadmap',
        data: {'idea': idea, 'location': location},
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // Ingest documents
  static Future<Map<String, dynamic>> ingestDocument({
    required String content,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        '/ingest',
        data: {'content': content},
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // Chat with the system
  static Future<Map<String, dynamic>> chat({
    required String userId,
    required String message,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        '/chat',
        data: {'user_id': userId, 'message': message},
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

// Business Planner specific API service
class BusinessPlannerApiService {
  static Future<SkillMappingResponse> generateBusinessIdeas({
    required String skill,
    required String location,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await ApiService.generateBusinessIdeas(
        skill: skill,
        location: location,
        cancelToken: cancelToken,
      );
      return SkillMappingResponse.fromJson(response['response']);
    } catch (e) {
      rethrow;
    }
  }

  static Future<IdeaEvaluationResponse> evaluateIdea({
    required String idea,
    required String location,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await ApiService.validateIdea(
        idea: idea,
        location: location,
        cancelToken: cancelToken,
      );
      return IdeaEvaluationResponse.fromJson(response['response']);
    } catch (e) {
      rethrow;
    }
  }

  static Future<RoadmapResponse> generateRoadmap({
    required String idea,
    required String location,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await ApiService.generateRoadmap(
        idea: idea,
        location: location,
        cancelToken: cancelToken,
      );
      return RoadmapResponse.fromJson(response['response']);
    } catch (e) {
      rethrow;
    }
  }
}

// Idea Evaluator specific API service
class IdeaEvaluatorApiService {
  static Future<IdeaEvaluationResponse> validateIdea({
    required String idea,
    required String location,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await ApiService.validateIdea(
        idea: idea,
        location: location,
        cancelToken: cancelToken,
      );
      return IdeaEvaluationResponse.fromJson(response['response']);
    } catch (e) {
      rethrow;
    }
  }
}

// Enhanced API Exception with Dio support
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? type;
  final Map<String, dynamic>? errorData;

  ApiException(this.message, {this.statusCode, this.type, this.errorData});

  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException('Connection timeout', type: 'timeout');
      case DioExceptionType.receiveTimeout:
        return ApiException('Response timeout', type: 'timeout');
      case DioExceptionType.sendTimeout:
        return ApiException('Request timeout', type: 'timeout');
      case DioExceptionType.cancel:
        return ApiException('Request was cancelled', type: 'cancelled');
      case DioExceptionType.connectionError:
        return ApiException('No internet connection', type: 'network');
      case DioExceptionType.badResponse:
        return ApiException(
          e.response?.data?['detail'] ?? 'Server error occurred',
          statusCode: e.response?.statusCode,
          type: 'server',
          errorData: e.response?.data,
        );
      default:
        return ApiException(
          'Unknown error occurred: ${e.message}',
          type: 'unknown',
        );
    }
  }

  @override
  String toString() => message;
}
