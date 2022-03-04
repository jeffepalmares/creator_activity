import 'package:commons_flutter/http/app_http_client.dart';
import 'package:commons_flutter/http/http_request_config.dart';
import 'package:creator_activity/app/dtos/corp_done_activity_dto.dart';
import 'package:creator_activity/app/lib_session.dart';
import 'package:creator_activity/app/services/requests/corp_sync_done_acitivity_request.dart';

class CorpActivityService {
  final AppHttpClient _client;

  CorpActivityService(this._client);

  Future<void> sendDoneActivities(List<CorpDoneActivityDto> activities) async {
    try {
      var data = CorpSyncDoneActivityRequest.build(activities);
      await _client.post("/corporativo/pt-br/importar/notas",
          data: data,
          options: HttpRequestConfig(
            token: LibSession.httpToken,
          ));
    } catch (err) {
      rethrow;
    }
  }
}
