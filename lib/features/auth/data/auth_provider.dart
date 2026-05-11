import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/auth_models.dart';
import 'auth_repository.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<CoopMember?> build() async {
    final token = await ref.read(authRepositoryProvider).getStoredToken();
    if (token == null) return null;
    return ref.read(authRepositoryProvider).getProfile();
  }

  Future<void> login(String phone, String pin) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).login(phone, pin),
    );
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }
}
