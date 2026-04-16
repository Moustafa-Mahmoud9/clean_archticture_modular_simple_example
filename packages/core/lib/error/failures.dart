import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'exceptions.dart';

// ── Failure hierarchy ────────────────────────────────────────────────────────

/// Base class for all domain-level failures.
///
/// [statusCode] is nullable because failures like [NetworkFailure] and
/// [TimeoutFailure] have no HTTP response to carry a status code from.
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];


}

/// The remote server returned an error (4xx / 5xx).
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

/// Reading from or writing to local cache failed.
class CacheFailure extends Failure {
  const CacheFailure({required super.message}) : super(statusCode: null);
}

/// No internet connection was available.
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message}) : super(statusCode: null);
}

/// The request or response exceeded the allowed time.
class TimeoutFailure extends Failure {
  const TimeoutFailure({required super.message}) : super(statusCode: null);
}

/// The server returned 401 Unauthorized.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required super.message})
      : super(statusCode: 401);
}

/// The server returned 403 Forbidden.
class ForbiddenFailure extends Failure {
  const ForbiddenFailure({required super.message}) : super(statusCode: 403);
}

/// The response body could not be parsed into the expected model.
class ParseFailure extends Failure {
  const ParseFailure({required super.message}) : super(statusCode: null);
}

Future<Either<Failure, T>> guardedApiCall<T>(
    Future<T> Function() action,
    ) async
{
  try {
    return Right(await action());
  } on NetworkException catch (e) {
    return Left(NetworkFailure(message: e.message));
  } on TimeoutException catch (e) {
    return Left(TimeoutFailure(message: e.message));
  } on UnauthorizedException catch (e) {
    return Left(UnauthorizedFailure(message: e.message));
  } on ParseException catch (e) {
    return Left(ParseFailure(message: e.message));
  } on CacheException catch (e) {
    return Left(CacheFailure(message: e.message));
  } on ServerException catch (e) {
    return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
  } catch (e) {
    return Left(ServerFailure(message: e.toString()));
  }
}