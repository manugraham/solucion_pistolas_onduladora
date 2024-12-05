class Bobina {
  int? iCodigoProveedor = 0;
  String? sNombreProveedor = "";
  String? sCodigoBobina = "";
  String? sCodigoInternoBobina = "";
  String? sEstado = "";
  String? sGrupo = "";
  int? iArticulo = 0;
  int? iCantidad = 0;
  String? sUnidad = "";
  String? sZona = "";
  int? iCasillero = 0;
  int? iLongitud = 0;
  int? iCodigoAlmacen = 0;
  String? sNombreAlmacen = "";
  String? sMensaje = "";
  String? sGrupoConsumo = "";
  String? sFechaUltimoMovimiento;
  int? iAncho;
  int? iGramaje;

  Bobina(
      {this.iCodigoProveedor,
      this.sNombreProveedor,
      this.sCodigoBobina,
      this.sCodigoInternoBobina,
      this.sEstado,
      this.sGrupo,
      this.iArticulo,
      this.iCantidad,
      this.sUnidad,
      this.sZona,
      this.iCasillero,
      this.iLongitud,
      this.iCodigoAlmacen,
      this.sNombreAlmacen,
      this.sMensaje,
      this.sGrupoConsumo,
      this.sFechaUltimoMovimiento,
      this.iGramaje,
      this.iAncho});

  factory Bobina.fromJson(Map<String, dynamic> json) {
    return Bobina(
        iCodigoProveedor: json['CodigoProveedor'] as int,
        sNombreProveedor: json['NombreProveedor'] as String,
        sCodigoBobina: json['CodigoBobina'] as String,
        sCodigoInternoBobina: json['CodigoInternoBobina'] as String,
        sEstado: json['Estado'] as String,
        iCodigoAlmacen: json['CodigoAlmacen'] as int,
        sNombreAlmacen: json['NombreAlmacen'] as String,
        iCantidad: json['Cantidad'] as int,
        sUnidad: json['Unidad'] as String,
        sZona: json['Zona'] as String,
        iCasillero: json['Casillero'] as int,
        iLongitud: json['Longitud'] as int,
        sGrupo: json['Grupo'] as String,
        iArticulo: json['Articulo'] as int,
        sMensaje: json['Mensaje'] as String,
        sGrupoConsumo: json['GrupoConsumo'],
        sFechaUltimoMovimiento: json['FechaUltimoMovimiento'] as String,
        iAncho: json['Ancho'] as int,
        iGramaje: json['Gramaje'] as int);
  }

  int? get codigoProveedor => iCodigoProveedor;
  String? get nombreProveedor => sNombreProveedor;
  String? get codigoBobina => sCodigoBobina;
  String? get codigoInternoBobina => sCodigoInternoBobina;
  String? get estado => sEstado;
  int? get codigoAlmacen => iCodigoAlmacen;
  String? get nombreAlmacen => sNombreAlmacen;
  int? get cantidad => iCantidad;
  String? get unidad => sUnidad;
  String? get zona => sZona;
  int? get casillero => iCasillero;
  int? get longitud => iLongitud;
  String? get grupo => sGrupo;
  int? get articulo => iArticulo;
  String? get mensaje => sMensaje;
  String? get grupoConsumo => sGrupoConsumo;
  String? get fechaUltimoMovimiento => sFechaUltimoMovimiento;
  int? get ancho => iAncho;
  int? get gramaje => iGramaje;
}
