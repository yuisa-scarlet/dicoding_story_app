import 'package:http/http.dart' as http;
import 'package:lilian_flutter_starter/core/api_client.dart';

typedef GetHandler = Future<http.Response> Function(String path);
typedef PostHandler =
    Future<http.Response> Function(
      String path, {
      Object? body,
      Map<String, String>? headers,
    });
typedef MultipartPostHandler =
    Future<http.Response> Function(
      String path, {
      required Map<String, String> fields,
      required List<http.MultipartFile> files,
      Map<String, String>? headers,
    });

class FakeApiClient extends ApiClient {
  FakeApiClient({
    GetHandler? onGet,
    PostHandler? onPost,
    MultipartPostHandler? onMultipartPost,
  }) : _onGet = onGet,
       _onPost = onPost,
       _onMultipartPost = onMultipartPost,
       super(baseUrl: 'https://example.com');

  final GetHandler? _onGet;
  final PostHandler? _onPost;
  final MultipartPostHandler? _onMultipartPost;

  @override
  Future<http.Response> get(String path) {
    if (_onGet == null) {
      throw UnimplementedError('GET handler is not configured');
    }
    return _onGet(path);
  }

  @override
  Future<http.Response> post(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) {
    if (_onPost == null) {
      throw UnimplementedError('POST handler is not configured');
    }
    return _onPost(path, body: body, headers: headers);
  }

  @override
  Future<http.Response> multipartPost(
    String path, {
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
    Map<String, String>? headers,
  }) {
    if (_onMultipartPost == null) {
      throw UnimplementedError('Multipart POST handler is not configured');
    }
    return _onMultipartPost(
      path,
      fields: fields,
      files: files,
      headers: headers,
    );
  }
}
