import 'package:core/core_package.dart';
import 'package:dio/dio.dart';

/// Concrete [ApiCancelToken] implementation wrapping Dio's [CancelToken].
///
/// Usage:
/// ```dart
/// final token = DioApiCancelToken();
///
/// _client.request(
///   endpoint.path,
///   method: endpoint.method,
///   endpointProvider: endpoint,
///   cancelToken: token,
/// );
///
/// // Cancel when widget is disposed
/// @override
/// void dispose() {
///   token.cancel('Widget disposed');
///   super.dispose();
/// }
/// ```
class DioApiCancelToken implements ApiCancelToken {
  final CancelToken _token = CancelToken();

  @override
  void cancel([dynamic reason]) => _token.cancel(reason?.toString());

  @override
  bool get isCancelled => _token.isCancelled;

  /// Expose the raw Dio token — used only by [DioClient] internally.
  CancelToken get dioToken => _token;
}