import 'package:auth_domain/auth_domain.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import 'package:core/core_package.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  ResultFuture<LoginResponseEntity> login({
    required String email,
    required String password,
    required String phone,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    return guardedApiCall(() async {
      final result = await _remoteDataSource.login(
        email: email,
        password: password,
        phone: phone,
      );
      await _localDataSource.cacheUser(result);
      final token = result.data?.token;
      if (token != null) await _localDataSource.cacheToken(token);
      return result;
    });
  }

  @override
  ResultFuture<LoginResponseEntity> register({
    required String email,
    required String password,
    required String name,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    return guardedApiCall(() async {
      final result = await _remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );
      await _localDataSource.cacheUser(result);
      final token = result.data?.token;
      if (token != null) await _localDataSource.cacheToken(token);
      return result;
    });
  }

  @override
  ResultVoid logout() async {
    try {
      await _remoteDataSource.logout();
    } catch (_) {
      // Server logout failed — still clear local data
    }
    return guardedApiCall(() => _localDataSource.clearCache());
  }

  @override
  ResultFuture<LoginResponseEntity> getCurrentUser() {
    return guardedApiCall(() => _localDataSource.getCachedUser());
  }
}