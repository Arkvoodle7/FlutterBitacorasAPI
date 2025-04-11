class CreateBitacoraRequest {
  final int idUsuario;
  final String descripcion;

  CreateBitacoraRequest({
    required this.idUsuario,
    required this.descripcion,
  });

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'descripcion': descripcion,
    };
  }
}
