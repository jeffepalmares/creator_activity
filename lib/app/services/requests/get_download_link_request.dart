class DownloadLinkRequest {
  // ignore: non_constant_identifier_names
  String? projeto_codigo;

  DownloadLinkRequest({
    // ignore: non_constant_identifier_names
    this.projeto_codigo,
  });

  Map<String, dynamic> toMap() {
    return {
      'projeto_codigo': projeto_codigo,
    };
  }

  static Map<String, dynamic> build(String code) {
    return DownloadLinkRequest(projeto_codigo: code).toMap();
  }
}
