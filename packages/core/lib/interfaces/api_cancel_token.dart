
abstract class ApiCancelToken {
  /// Cancels the in-flight request.
  /// [reason] is optional context passed to the HTTP library.
  void cancel([dynamic reason]);

  /// Whether this token has already been cancelled.
  bool get isCancelled;
}