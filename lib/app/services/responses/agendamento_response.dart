class AgendamentoResponse {
  String? id;
  String? inicio;
  String? fim;
  bool? prova;

  AgendamentoResponse({this.id, this.inicio, this.fim, this.prova});

  AgendamentoResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    inicio = json['inicio'];
    fim = json['fim'];
    prova = json['prova'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['inicio'] = inicio;
    data['fim'] = fim;
    data['prova'] = prova;
    return data;
  }
}
