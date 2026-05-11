import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/auth_interceptor.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/auth_models.dart';
import 'auth_api_service.dart';

export 'auth_api_service.dart' show LoginRequest, AuthResponse;

const _kMemberCacheKey = 'cached_member';

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
      // Persiste le token de façon sécurisée
      await _storage.write(key: 'jwt_token', value: response.token);
      // Cache le profil membre dans Hive
      final box = Hive.box('auth_cache');
      await box.put(_kMemberCacheKey, response.member.toJson());
      return response.member;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    } catch (e) {
      throw AppException('Erreur de connexion inattendue.');
    }
  }

  Future<CoopMember> getProfile() async {
    try {
      final member = await _api.getProfile();
      final box = Hive.box('auth_cache');
      await box.put(_kMemberCacheKey, member.toJson());
      return member;
    } on DioException catch (e) {
      // Retourne le cache si disponible
      final box = Hive.box('auth_cache');
      final cached = box.get(_kMemberCacheKey);
      if (cached != null) {
        return CoopMember.fromJson(Map<String, dynamic>.from(cached as Map));
      }
      throw AppException.fromDioError(e);
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    final box = Hive.box('auth_cache');
    await box.clear();
  }

  Future<String?> getStoredToken() async {
    return _storage.read(key: 'jwt_token');
  }
}
