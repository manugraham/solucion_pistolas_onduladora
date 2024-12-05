class SociedadUsuario {
  int? iCodigo;
  String? sNombre;
  bool? bPorDefecto;

  SociedadUsuario({this.iCodigo, this.sNombre, this.bPorDefecto});

  factory SociedadUsuario.fromJson(Map<String, dynamic> json) {
    return SociedadUsuario(
        iCodigo: json['Sociedad'] as int,
        sNombre: json['Nombre'] as String,
        bPorDefecto: json['PorDefecto'] as bool);
  }

  int? get codigo => iCodigo;
  String? get nombre => sNombre?.trim();
  bool? get porDefecto => bPorDefecto;
}
