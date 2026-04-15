import 'package:core/core_package.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  ResultFuture<LoginResponseEntity> login({
    required String email,
    required String password,
    required String phone,
  });

  ResultFuture<LoginResponseEntity> register({
    required String email,
    required String password,
    required String name,
  });

  ResultVoid logout();

  ResultFuture<LoginResponseEntity> getCurrentUser();
}