class BitacoraDto {
  final int idBitacora;
  final DateTime fechaBitacora;
  final int idUsuario;
  final String descripcion;

  BitacoraDto({
    required this.idBitacora,
    required this.fechaBitacora,
    required this.idUsuario,
    required this.descripcion,
  });

  factory BitacoraDto.fromJson(Map<String, dynamic> json) {
    return BitacoraDto(
      // Fíjate que usamos las mismas claves que envía la API
      idBitacora: json['IdBitacora'] ?? 0,
      fechaBitacora: json['FechaBitacora'] == null
          ? DateTime.now()
          : DateTime.parse(json['FechaBitacora']),
      idUsuario: json['IdUsuario'] ?? 0,
      descripcion: json['Descripcion'] ?? '', 
    );
  }
}
