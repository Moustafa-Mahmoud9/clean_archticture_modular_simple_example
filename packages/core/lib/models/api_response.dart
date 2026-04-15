import 'api_error_type.dart';

abstract class ApiResponse<T> {
  const ApiResponse();

  R when<R>({
    required R Function(T data) success,
    required R Function(ApiErrorType error, String message) failure,
  });
}