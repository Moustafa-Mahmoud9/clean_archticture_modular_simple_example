import 'package:auth_domain/auth_domain.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import 'package:core/core_package.dart';
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource  _localDataSource;
  final NetworkInfo          _networkInfo;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource  localDataSource,
    required NetworkInfo          networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource  = localDataSource,
        _networkInfo      = networkInfo;

  // ── Login ───────────────────────────────────────────────────────────────────

  @override
  ResultFuture<LoginResponseEntity> login({
    required String email,
    required String password,
    required String phone,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final result = await _remoteDataSource.login(
        email: email,
        password: password,
        phone: phone,
      );

      // Cache the full login response locally
      await _localDataSource.cacheUser(result);

      // Cache the token so AuthInterceptor can attach it to future requests.
      // Your API returns the token inside data.token — extract it here.
      final token = result.data?.token;
      if (token != null) await _localDataSource.cacheToken(token);

      return Right(result);
    } on NetworkException      catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on TimeoutException      catch (e) {
      return Left(TimeoutFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ParseException        catch (e) {
      return Left(ParseFailure(message: e.message));
    } on ServerException       catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  // ── Register ────────────────────────────────────────────────────────────────

  @override
  ResultFuture<LoginResponseEntity> register({
    required String email,
    required String password,
    required String name,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final result = await _remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );

      await _localDataSource.cacheUser(result);

      final token = result.data?.token;
      if (token != null) await _localDataSource.cacheToken(token);

      return Right(result);
    } on NetworkException      catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on TimeoutException      catch (e) {
      return Left(TimeoutFailure(message: e.message));
    } on ParseException        catch (e) {
      return Left(ParseFailure(message: e.message));
    } on ServerException       catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  // ── Logout ──────────────────────────────────────────────────────────────────

  @override
  ResultVoid logout() async {
    try {
      // Attempt server-side logout — ignore network errors,
      // always clear local cache regardless.
      await _remoteDataSource.logout();
    } catch (_) {
      // Server logout failed or no connection — proceed to clear local data anyway
    } finally {
      await _localDataSource.clearCache();
    }
    return const Right(null);
  }

  // ── Get current user ────────────────────────────────────────────────────────

  @override
  ResultFuture<LoginResponseEntity> getCurrentUser() async {
    try {
      final cachedUser = await _localDataSource.getCachedUser();
      return Right(cachedUser);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}