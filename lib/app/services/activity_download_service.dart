import 'package:commons_flutter/http/app_http_client.dart';
import 'package:commons_flutter/http/http_request_config.dart';

class ActivityDownloadService {
  final AppHttpClient _client;

  ActivityDownloadService(this._client);

  Future downloadActivity(
    String code,
    Function(int count, int total) receiveProgress,
  ) async {
    try {
      var uri = "/projeto/pt-br/download/projeto/$code";

      var response = await _client.get(uri,
          options: HttpRequestConfig(
            responseType: HttpResponseType.bytes,
            receiveProgress: receiveProgress,
          ));

      return response.data;
    } catch (err) {
      rethrow;
    }
  }
}
