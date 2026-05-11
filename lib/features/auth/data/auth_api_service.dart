import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../domain/auth_models.dart';

part 'auth_api_service.freezed.dart';
part 'auth_api_service.g.dart';

/// Service API pour l'authentification - wraps Dio directement (pattern "Dio Service")
class AuthApiService {
  final Dio _dio;

  AuthApiService(this._dio);

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      '/auth/login',
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<CoopMember> getProfile() async {
    final response = await _dio.get('/api/profile');
    return CoopMember.fromJson(response.data as Map<String, dynamic>);
  }
}

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String phone,
    required String pin,
  }) = _LoginRequest;
  factory LoginRequest.fromJson(Map<String, dynamic> j) => _$LoginRequestFromJson(j);
}

@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String token,
    required CoopMember member,
  }) = _AuthResponse;
  factory AuthResponse.fromJson(Map<String, dynamic> j) => _$AuthResponseFromJson(j);
}
