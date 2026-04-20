import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'package:core_implementation/core_implementation.dart';
class GetCurrentUser implements UseCase<LoginResponseEntity, NoParams> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, LoginResponseEntity>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}