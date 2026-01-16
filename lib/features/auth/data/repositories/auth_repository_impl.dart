import 'package:yb_news/core/errors/exceptions.dart';
import 'package:yb_news/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:yb_news/features/auth/data/models/user_model.dart';
import 'package:yb_news/features/auth/domain/entities/user.dart';
import 'package:yb_news/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource _datasource;

  AuthRepositoryImpl({AuthLocalDatasource? datasource})
    : _datasource = datasource ?? AuthLocalDatasource();

  @override
  Future<User> login(String email, String password) async {
    final userData = await _datasource.login(email, password);
    if (userData == null) {
      throw InvalidCredentialsException();
    }
    return UserModel.fromJson(userData);
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final userData = await _datasource.register(
      name: name,
      email: email,
      password: password,
    );
    return UserModel.fromJson(userData);
  }

  @override
  Future<User> getUserByEmail(String email) async {
    final userData = await _datasource.getUserByEmail(email);
    if (userData == null) {
      throw UserNotFoundException();
    }
    return UserModel.fromJson(userData);
  }
}
