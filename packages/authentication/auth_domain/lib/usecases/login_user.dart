import 'package:core/core_package.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUser implements UseCase<LoginResponseEntity, LoginBodyEntity> {
  final AuthRepository repository;

  LoginUser(this.repository);

  @override
  Future<Either<Failure, LoginResponseEntity>> call(LoginBodyEntity params) async {
    return await repository.login(
      email: params.email,
      password: params.password,
      phone:params.phone
    );
  }
}

class LoginBodyEntity {
  final String email;
  final String password;
  final String phone;

  LoginBodyEntity(
      {required this.email, required this.password, required this.phone});

  toPostBody() {
    Map<String, dynamic> body = {
      "password": password,
      "phone": phone,
    };

    return body;
  }
}