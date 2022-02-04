import 'activity_scorm_dto.dart';

class ScormDto {
  String? usuario;
  String? projeto;
  ActivityScormDto? tentativa;

  ScormDto({this.usuario, this.projeto});

  ScormDto.fromJson(Map<String, dynamic> json) {
    usuario = json['usuario'];
    projeto = json['projeto'];
    tentativa = json['tentativa'] != null
        ? ActivityScormDto.fromJson(json['tentativa'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['usuario'] = usuario;
    data['projeto'] = projeto;
    data['tentativa'] = tentativa?.toJson();
    return data;
  }
}
