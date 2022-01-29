class GrupoResponse {
  String? id;
  String? codigo;
  String? nome;

  GrupoResponse({this.id, this.codigo, this.nome});

  GrupoResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    codigo = json['codigo'];
    nome = json['nome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['codigo'] = codigo;
    data['nome'] = nome;
    return data;
  }
}
