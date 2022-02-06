import 'package:commons_flutter/http/app_http_client.dart';
import 'package:commons_flutter/utils/app_string_utils.dart';
import 'package:commons_flutter/utils/network_utils.dart';
import 'package:creator_activity/app/dtos/activity_delivery_dto.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';

import 'responses/entrega_response.dart';

class FileActivityService {
  final AppHttpClient _client;

  FileActivityService(this._client);

  Future<bool> markDeliveryAsChecked(List<ActivityDto> activities) async {
    try {
      if (!(await NetworkUtils.hasInternetConnection())) {
        return false;
      }

      for (var activity in activities) {
        if (AppStringUtils.isEmptyOrNull(activity.delivery?.id)) continue;
        var data = {"entrega": activity.delivery?.id};
        await _client.post('/projeto/pt-br/entrega/conferir-feedback',
            data: data);
      }
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<ActivityDeliveryDto?> getActivityLastDelivery(
      ActivityDto activity) async {
    try {
      var resp = await _client
          .get('/projeto/pt-br/entrega/retornar/ultima/${activity.id}');
      if (resp != null && resp.data['entrega'] != null) {
        return EntregaResponse.fromJson(resp.data['entrega']).toDto();
      }
      return activity.delivery;
    } catch (err) {
      rethrow;
    }
  }
}
