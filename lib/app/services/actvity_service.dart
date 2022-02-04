import 'dart:convert';
import 'dart:io';

import 'package:commons_flutter/exceptions/app_error.dart';
import 'package:commons_flutter/http/app_http_client.dart';
import 'package:commons_flutter/http/http_request_config.dart';
import 'package:commons_flutter/utils/network_utils.dart';
import 'package:creator_activity/app/dtos/activity_delivery_dto.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/enums/activity_status_enum.dart';
import 'package:creator_activity/app/lib_session.dart';
import 'package:dio/dio.dart';
import 'requests/sync_activity_request.dart';
import 'responses/activity_response.dart';
import 'responses/entrega_response.dart';

class StudentActivityService {
  final AppHttpClient _client;

  StudentActivityService(this._client);

  Future<List<ActivityDto>> getActivities() async {
    try {
      const uri = "/projeto/pt-br/buscar/projetos/minhas-turmas";

      var response = await _client.post(uri);

      return ActivityResponse.fromJson(response).toDto();
    } catch (err) {
      rethrow;
    }
  }

  Future sendDoneActivities(List<ActivityDto> activities) async {
    try {
      var data = SyncAtividadeRequest.build(activities);
      await _client.post(
        '/projeto/pt-br/gravar/notas/lote',
        data: data,
      );
      for (var element in activities) {
        element.synced = true;
      }
    } catch (err) {
      rethrow;
    }
  }

  Future sendDoneFileActivities(List<ActivityDto> activities) async {
    try {
      for (var activity in activities) {
        try {
          await _sendActivityFile(activity);
          activity.synced = true;
          activity.status = ActivityStatus.waitingCorrection;
        } catch (err) {
          activity.synced = false;
        }
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> _sendActivityFile(ActivityDto activity) async {
    try {
      var token = LibSession.httpToken;
      Dio _dio = Dio(BaseOptions(
          baseUrl: "https://repositorio.creator4all.com",
          headers: {"Authorization": "Bearer $token"},
          contentType: "multipart/form-data"));
      var files = SyncAtividadeRequest.buildFileRequest(activity);
      List<String> contents = [];
      for (var file in files) {
        var resp = await _dio.post("/api/entrega/enviar/arquivos/atividade",
            data: file);
        var jsonValue = json.decode(resp.data);
        if (jsonValue['status'] == 'erro') {
          throw AppError(resp.data['mensagem']);
        } else {
          jsonValue['conteudo'].forEach((e) {
            contents.add(e['conteudo']);
          });
        }
      }
      await _registerActivityFileDelivery(activity, contents);
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> markDeliveryAsChecked(List<ActivityDto> activities) async {
    try {
      if (!(await NetworkUtils.hasInternetConnection())) {
        return false;
      }

      for (var activity in activities) {
        var data = {"entrega": activity.delivery?.id};

        await _client.post('/projeto/pt-br/entrega/conferir-feedback',
            data: data);
      }
      return true;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> _registerActivityFileDelivery(
      ActivityDto activity, List<String> contents) async {
    try {
      var files =
          contents.map((c) => {"tipo": "arquivo", "conteudo": c}).toList();
      // if (activity.delivery != null && activity.delivery.id != null) {
      //   data.putIfAbsent("cancelar_entrega", () => activity.delivery.id);
      // }
      var data = {
        "projeto": activity.id,
        "tipo": "arquivo",
        "conteudo": json.encode(files),
      };
      if (activity.delivery != null) {
        data.putIfAbsent('cancelar_entrega', () => activity.delivery?.id);
      }
      var stringJson = json.encode(data);
      var resp = await _client.post('/projeto/pt-br/entrega/registrar',
          data: stringJson.toString());
    } catch (err) {
      rethrow;
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
