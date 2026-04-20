import '../models/file_extension.dart';
import '../models/http_method.dart';
import '../interfaces/api_cancel_token.dart';
import '../models/api_response.dart';
import 'endpoint_provider.dart';

/// Progress callback — fires with (bytesTransferred, totalBytes).
typedef ApiProgressCallback = void Function(int count, int total);


abstract class ApiClient {


  Future<ApiResponse<T>> request<T>(
      String path, {
        required HttpMethod method,
        EndpointProvider? endpointProvider,
        T Function(dynamic json)? fromJson,
        ApiCancelToken? cancelToken,
        ApiProgressCallback? onSendProgress,
        ApiProgressCallback? onReceiveProgress,
      });

  // ── 2. File upload with explicit FileExtension ────────────────────────────


  Future<ApiResponse<T>> uploadFile<T>(
      String path, {
        required String filePath,
        required FileExtension fileType,
        String fileField = 'file',
        Map<String, String> extraFields = const {},
        T Function(dynamic json)? fromJson,
        ApiCancelToken? cancelToken,
        ApiProgressCallback? onSendProgress,
      });

  // ── 3. File download with explicit FileExtension ──────────────────────────
  /// Resolves with the local path where the file was saved on success.
  Future<ApiResponse<String>> downloadFile(
      String path, {
        required String savePath,
        required FileExtension fileType,
        Map<String, dynamic>? queryParameters,
        ApiCancelToken? cancelToken,
        ApiProgressCallback? onReceiveProgress,
      });

  // ── 4. SSL Pinning — abstract, implementation does the library wiring ─────

  Future<void> applySslPinning(String assetPath);

  /// Configures the request/response logger for this client.
  Future<void> applyLogger({bool verbose = false});
}