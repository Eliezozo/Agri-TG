import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../domain/auth_models.dart';

part 'auth_api_service.freezed.dart';
part 'auth_api_service.g.dart';

class AuthApiService {
  final Dio _dio;
  
  AuthApiService(this._dio);

  Future<AuthResponse> login(LoginRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    return AuthResponse(
      token: 'mock_jwt_token_123',
      member: CoopMember(
        id: 'member_1',
        fullName: 'Kossi Akpovi',
        phone: request.phone,
        role: 'president',
        cooperativeId: 'coop_togo_01',
        cooperativeName: 'Coopérative Agricole de Kpalimé',
        joinedAt: DateTime.now(),
      ),
    );
  }

  Future<CoopMember> getProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    return CoopMember(
      id: 'member_1',
      fullName: 'Kossi Akpovi',
      phone: '90000000',
      role: 'president',
      cooperativeId: 'coop_togo_01',
      cooperativeName: 'Coopérative Agricole de Kpalimé',
      joinedAt: DateTime.now(),
    );
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
