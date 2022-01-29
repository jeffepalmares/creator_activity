import 'package:commons_flutter/utils/app_string_utils.dart';
import 'package:creator_activity/app/dtos/activity_class_dto.dart';
import 'package:creator_activity/app/dtos/activity_dto.dart';
import 'package:creator_activity/app/enums/activity_type_enum.dart';

import 'projetos_response.dart';

class ActivityResponse {
  String? status;
  String? mensagem;
  List<ProjetosResponse>? projetos;

  ActivityResponse({this.status, this.mensagem, this.projetos});

  ActivityResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    mensagem = json['mensagem'];
    if (json['projetos'] != null) {
      projetos = <ProjetosResponse>[];
      json['projetos'].forEach((v) {
        projetos?.add(ProjetosResponse.fromJson(v));
      });
    }
  }

  List<ActivityDto> toDto() {
    return projetos!
        .map((e) => ActivityDto(
              code: e.codigo,
              end: e.agendamento?.fim,
              age: e.classificacaoIndicativa,
              name: e.titulo,
              id: e.id,
              isExam: e.agendamento?.prova,
              type: (e.agendamento?.prova ?? false)
                  ? ActivityType.exam
                  : e.tipo == "ARQ"
                      ? ActivityType.file
                      : ActivityType.task,
              lastScore: e.ultimaNota,
              lastScoreDate: e.ultimaNotaData,
              scheduleId: e.agendamento?.id,
              start: e.agendamento?.inicio,
              link: e.link,
              delivery: e.entrega?.toDto(),
              activityClass: ActivityClassDto(
                code: e.grupo?.codigo,
                id: e.grupo?.id,
                name: e.grupo?.nome,
              ),
            ))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['mensagem'] = mensagem;
    data['projetos'] = projetos?.map((v) => v.toJson()).toList();
    return data;
  }
}
