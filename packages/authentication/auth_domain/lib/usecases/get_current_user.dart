import 'package:core/core_package.dart';
import 'package:core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser implements UseCase<LoginResponseEntity, NoParams> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, LoginResponseEntity>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}