/// Modela la relación N:M entre Usuario y VehiculoAnuncio coherente con la BD relacional
class Favorito {
  final String id;
  final String idUsuario;
  final String idVehiculo;
  final DateTime fechaAgregado;

  const Favorito({
    required this.id,
    required this.idUsuario,
    required this.idVehiculo,
    required this.fechaAgregado,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'idUsuario': idUsuario,
    'idVehiculo': idVehiculo,
    'fechaAgregado': fechaAgregado.toIso8601String(),
  };

  factory Favorito.fromMap(Map<String, dynamic> map) => Favorito(
    id: map['id']?.toString() ?? '',
    idUsuario: map['idUsuario']?.toString() ?? '',
    idVehiculo: map['idVehiculo']?.toString() ?? '',
    fechaAgregado: map['fechaAgregado'] != null
        ? DateTime.tryParse(map['fechaAgregado'].toString()) ?? DateTime.now()
        : DateTime.now(),
  );
}
