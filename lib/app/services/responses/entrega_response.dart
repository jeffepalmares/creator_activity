import 'package:creator_activity/app/dtos/activity_delivery_content_dto.dart';
import 'package:creator_activity/app/dtos/activity_delivery_dto.dart';

class EntregaResponse {
  String? id;
  List<EntregaConteudo>? conteudo;
  String? conteudoAnotacoes;
  String? data;
  String? feedback;
  String? feedbackData;
  String? status;
  bool? refazer;
  bool? conferido;
  String? conferidoData;
  Nota? nota;

  EntregaResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['conteudo'] != null) {
      conteudo = [];
      json['conteudo']
          .forEach((e) => conteudo?.add(EntregaConteudo.fromJson(e)));
    }
    conteudoAnotacoes = json['conteudoAnotacoes'];
    data = json['data'];
    feedback = json['feedback'];
    feedbackData = json['feedbackData'];
    status = json['status'];
    refazer = json['refazer'];
    conferido = json['conferido'];
    conferidoData = json['conferidoData'];
    if (json['nota'] != null) {
      nota = Nota.fromJson(json['nota']);
    }
  }

  ActivityDeliveryDto toDto() {
    return ActivityDeliveryDto(
      checked: conferido,
      checkedDate: conferidoData,
      contentAnnotation: conteudoAnotacoes,
      contents: conteudo?.map((e) => e.toDto()).toList(),
      date: data,
      feedback: feedback,
      feedbackDate: feedbackData,
      id: id,
      score: nota?.nota,
      shouldRedo: refazer,
      status: status,
    );
  }
}

class Nota {
  String? id;
  String? status;
  String? nota;
  String? data;

  Nota.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    nota = json['nota'];
    data = json['data'];
  }
}

class EntregaConteudo {
  String? tipo;
  String? conteudo;

  EntregaConteudo.fromJson(Map<String, dynamic> json) {
    tipo = json['tipo'];
    conteudo = json['conteudo'];
  }

  ActivityDeliveryContentDto toDto() {
    return ActivityDeliveryContentDto(
      content: conteudo,
      type: tipo,
    );
  }
}
