import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/auth_interceptor.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/auth_models.dart';
import 'auth_api_service.dart';

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  return AuthApiService(ref.watch(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(authApiServiceProvider),
    ref.watch(secureStorageProvider),
  );
});

class AuthRepository {
  final AuthApiService _api;
  final FlutterSecureStorage _storage;

  AuthRepository(this._api, this._storage);

  Future<CoopMember> login(String phone, String pin) async {
    try {
      final response = await _api.login(LoginRequest(phone: phone, pin: pin));
      await _storage.write(key: 'jwt_token', value: response.token);
      return response.member;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<CoopMember> getProfile() async {
    try {
      return await _api.getProfile();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  Future<String?> getStoredToken() async {
    return _storage.read(key: 'jwt_token');
  }
}
