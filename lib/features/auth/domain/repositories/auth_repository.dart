import 'package:yb_news/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register({
    required String name,
    required String email,
    required String password,
  });
  Future<User> getUserByEmail(String email);
}
