class VehiculoAnuncio {
  final String id;
  final String marca;
  final String linea;
  final int ano;
  final double precio;
  final int kilometraje;
  final String ciudad;
  final String idVendedor;
  final String publicador;
  final String transmision;
  final String combustible;
  final String? color;
  final String? descripcion;

  const VehiculoAnuncio({
    required this.id,
    required this.marca,
    required this.linea,
    required this.ano,
    required this.precio,
    required this.kilometraje,
    required this.ciudad,
    required this.idVendedor,
    required this.publicador,
    required this.transmision,
    required this.combustible,
    this.color,
    this.descripcion,
  });

  /// Getter para la UI que compone el nombre completo del vehículo sin duplicar campos
  String get titulo => '$marca $linea $ano';

  /// Compatibilidad para código existente que lee vehiculo.ubicacion
  String get ubicacion => ciudad;

  /// Formatea el precio numérico a moneda colombiana para la UI: '$ 65.000.000 COP'
  String get precioFormateado {
    final entero = precio.round().toString();
    final formateado = entero.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return '\$ $formateado COP';
  }

  /// Formatea el kilometraje numérico para la UI: '48.500 km'
  String get kilometrajeFormateado {
    final entero = kilometraje.toString();
    final formateado = entero.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return '$formateado km';
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'marca': marca,
    'linea': linea,
    'ano': ano,
    'precio': precio,
    'kilometraje': kilometraje,
    'ciudad': ciudad,
    'ubicacion': ciudad,
    'idVendedor': idVendedor,
    'publicador': publicador,
    'transmision': transmision,
    'combustible': combustible,
    'color': color,
    'descripcion': descripcion,
  };

  factory VehiculoAnuncio.fromMap(Map<String, dynamic> map) {
    // Parseo robusto de precio numérico (soporta double, int o strings legados como '$ 65.000.000 COP')
    final rawPrecio = map['precio'];
    double parsedPrecio = 0.0;
    if (rawPrecio is num) {
      parsedPrecio = rawPrecio.toDouble();
    } else if (rawPrecio is String) {
      final cleaned = rawPrecio.replaceAll(RegExp(r'[^\d]'), '');
      parsedPrecio = double.tryParse(cleaned) ?? 0.0;
    }

    // Parseo robusto de kilometraje (soporta int, num o strings legados como '48.500 km')
    final rawKm = map['kilometraje'];
    int parsedKm = 0;
    if (rawKm is num) {
      parsedKm = rawKm.toInt();
    } else if (rawKm is String) {
      final cleaned = rawKm.replaceAll(RegExp(r'[^\d]'), '');
      parsedKm = int.tryParse(cleaned) ?? 0;
    }

    // Parseo de año
    final rawAno = map['ano'];
    int parsedAno = 2020;
    if (rawAno is num) {
      parsedAno = rawAno.toInt();
    } else if (rawAno is String) {
      parsedAno = int.tryParse(rawAno.replaceAll(RegExp(r'[^\d]'), '')) ?? 2020;
    }

    // Inferencia de marca y línea si vienen de un formato anterior con 'titulo'
    String marca = map['marca']?.toString() ?? '';
    String linea = map['linea']?.toString() ?? '';
    if (marca.isEmpty && map['titulo'] != null) {
      final parts = (map['titulo'] as String).trim().split(' ');
      if (parts.isNotEmpty) {
        marca = parts.first;
        if (parts.length > 2 && int.tryParse(parts.last) != null) {
          linea = parts.sublist(1, parts.length - 1).join(' ');
        } else if (parts.length > 1) {
          linea = parts.sublist(1).join(' ');
        }
      }
    }

    final ciudad = (map['ciudad'] ?? map['ubicacion'] ?? 'Cali, Valle del Cauca').toString();
    final publicador = map['publicador']?.toString() ?? 'Particular';
    final idVendedor = (map['idVendedor'] ?? (publicador == 'Concesionario' ? 'usr_dealer_01' : 'usr_part_01')).toString();

    return VehiculoAnuncio(
      id: map['id']?.toString() ?? '',
      marca: marca.isNotEmpty ? marca : 'General',
      linea: linea.isNotEmpty ? linea : 'Vehículo',
      ano: parsedAno,
      precio: parsedPrecio,
      kilometraje: parsedKm,
      ciudad: ciudad,
      idVendedor: idVendedor,
      publicador: publicador,
      transmision: map['transmision']?.toString() ?? 'Automática',
      combustible: map['combustible']?.toString() ?? 'Gasolina',
      color: map['color']?.toString(),
      descripcion: map['descripcion']?.toString(),
    );
  }
}
