class VehiculoAnuncio {
  final String id;
  final String titulo;
  final String precio;
  final String kilometraje;
  final String ubicacion;
  final String publicador;
  final String transmision;
  final String combustible;
  final String? descripcion;
  final String? color;
  final String? ano;

  const VehiculoAnuncio({
    required this.id,
    required this.titulo,
    required this.precio,
    required this.kilometraje,
    required this.ubicacion,
    required this.publicador,
    required this.transmision,
    required this.combustible,
    this.descripcion,
    this.color,
    this.ano,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'titulo': titulo,
    'precio': precio,
    'kilometraje': kilometraje,
    'ubicacion': ubicacion,
    'publicador': publicador,
    'transmision': transmision,
    'combustible': combustible,
    'descripcion': descripcion,
    'color': color,
    'ano': ano,
  };

  factory VehiculoAnuncio.fromMap(Map<String, dynamic> map) => VehiculoAnuncio(
    id: map['id'] ?? '',
    titulo: map['titulo'] ?? '',
    precio: map['precio'] ?? '',
    kilometraje: map['kilometraje'] ?? '',
    ubicacion: map['ubicacion'] ?? '',
    publicador: map['publicador'] ?? '',
    transmision: map['transmision'] ?? '',
    combustible: map['combustible'] ?? '',
    descripcion: map['descripcion'],
    color: map['color'],
    ano: map['ano'],
  );
}
