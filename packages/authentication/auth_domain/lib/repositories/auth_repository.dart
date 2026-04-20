import '../entities/user.dart';
import 'package:core_implementation/core_implementation.dart';
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