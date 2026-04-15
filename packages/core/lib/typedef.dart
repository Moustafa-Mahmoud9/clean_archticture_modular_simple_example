import 'package:core/core_package.dart';
import 'package:dartz/dartz.dart';


/// Shorthand for the standard async Either return type used in repositories and use cases.
typedef ResultFuture<T> = Future<Either<Failure, T>>;

/// Shorthand for use cases / repositories that return void on success.
typedef ResultVoid = Future<Either<Failure, void>>;

/// Shorthand for JSON map — used in model fromJson / toJson methods.
typedef DataMap = Map<String, dynamic>;