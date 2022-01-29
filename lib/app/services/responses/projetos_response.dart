import 'entrega_response.dart';
import 'usuario_response.dart';
import 'agendamento_response.dart';
import 'grupo_response.dart';

class ProjetosResponse {
  String? id;
  String? codigo;
  String? titulo;
  UsuarioResponse? usuario;
  AgendamentoResponse? agendamento;
  GrupoResponse? grupo;
  String? tipo;
  String? ultimaNota;
  String? ultimaNotaData;
  String? link;
  String? classificacaoIndicativa;
  EntregaResponse? entrega;

  ProjetosResponse({
    this.id,
    this.codigo,
    this.titulo,
    this.usuario,
    this.agendamento,
    this.tipo,
    this.grupo,
    this.ultimaNota,
    this.ultimaNotaData,
    this.link,
    this.classificacaoIndicativa,
  });

  ProjetosResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    codigo = json['codigo'];
    titulo = json['titulo'];
    usuario = json['usuario'] != null
        ? UsuarioResponse.fromJson(json['usuario'])
        : null;
    agendamento = json['agendamento'] != null
        ? AgendamentoResponse.fromJson(json['agendamento'])
        : null;
    tipo = json['tipo'];
    grupo =
        json['grupo'] != null ? GrupoResponse.fromJson(json['grupo']) : null;
    ultimaNota = json['ultima_nota'];
    ultimaNotaData = json['ultima_nota_data'];
    link = json['link'];
    entrega = json['entrega'] != null
        ? EntregaResponse.fromJson(json['entrega'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['codigo'] = codigo;
    data['titulo'] = titulo;
    data['usuario'] = usuario?.toJson();
    data['agendamento'] = agendamento?.toJson();
    data['grupo'] = grupo?.toJson();
    data['ultima_nota'] = ultimaNota;
    data['ultima_nota_data'] = ultimaNotaData;
    data['link'] = link;
    data['classificacaoIndicativa'] = classificacaoIndicativa;
    return data;
  }
}
