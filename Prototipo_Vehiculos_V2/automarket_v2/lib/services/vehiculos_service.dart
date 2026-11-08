import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vehiculo.dart';
import '../models/favorito.dart';

class VehiculosService {
  static final VehiculosService _instance = VehiculosService._internal();
  factory VehiculosService() => _instance;
  VehiculosService._internal();

  static const String _storageKey = 'automarket_vehiculos_v3';
  static const String _favoritosKey = 'automarket_favoritos_v3';
  static const String _favoritosIdsKey = 'automarket_favoritos_ids';

  final List<VehiculoAnuncio> _cache = [];
  bool _initialized = false;

  final List<VehiculoAnuncio> _defaultVehiculos = const [
    VehiculoAnuncio(
      id: 'v1',
      marca: 'Mazda',
      linea: '3 Grand Touring',
      ano: 2019,
      precio: 65000000.0,
      kilometraje: 48500,
      ciudad: 'Cali, Valle del Cauca',
      idVendedor: 'usr_part_01',
      publicador: 'Particular',
      transmision: 'Automática',
      combustible: 'Gasolina',
      color: 'Rojo Diamante',
      descripcion: 'Excelente estado, único dueño, mantenimientos al día en concesionario Madiautos, tapicería en cuero y sunroof.',
    ),
    VehiculoAnuncio(
      id: 'v2',
      marca: 'Chevrolet',
      linea: 'Tracker Premier Turbo',
      ano: 2021,
      precio: 72000000.0,
      kilometraje: 36200,
      ciudad: 'Cali, Valle del Cauca',
      idVendedor: 'usr_dealer_01',
      publicador: 'Concesionario',
      transmision: 'Automática',
      combustible: 'Gasolina',
      color: 'Gris Mercurio',
      descripcion: 'Versión full equipo con techo panorámico, frenado autónomo de emergencia y pantalla táctil con Apple CarPlay y Android Auto.',
    ),
    VehiculoAnuncio(
      id: 'v3',
      marca: 'Renault',
      linea: 'Duster Zen 1.6',
      ano: 2020,
      precio: 58500000.0,
      kilometraje: 52000,
      ciudad: 'Medellín, Antioquia',
      idVendedor: 'usr_part_01',
      publicador: 'Particular',
      transmision: 'Mecánica',
      combustible: 'Gasolina',
      color: 'Blanco Glaciar',
      descripcion: 'Camioneta espaciosa, bajo consumo de combustible, lista para traspaso inmediato sin gravámenes.',
    ),
    VehiculoAnuncio(
      id: 'v4',
      marca: 'Toyota',
      linea: 'Corolla Cross XEI Híbrido',
      ano: 2022,
      precio: 98000000.0,
      kilometraje: 29000,
      ciudad: 'Bogotá D.C.',
      idVendedor: 'usr_dealer_01',
      publicador: 'Concesionario',
      transmision: 'CVT',
      combustible: 'Híbrido',
      color: 'Plata Metalizado',
      descripcion: 'Excelente eficiencia de combustible, exento de pico y placa en las principales ciudades de Colombia.',
    ),
    VehiculoAnuncio(
      id: 'v5',
      marca: 'Kia',
      linea: 'Picanto GT-Line',
      ano: 2021,
      precio: 44500000.0,
      kilometraje: 39800,
      ciudad: 'Cali, Valle del Cauca',
      idVendedor: 'usr_part_01',
      publicador: 'Particular',
      transmision: 'Mecánica',
      combustible: 'Gasolina',
      color: 'Rojo Pasión',
      descripcion: 'Edición deportiva GT-Line, rines de lujo bitono, mandos al volante y luces LED.',
    ),
    VehiculoAnuncio(
      id: 'v6',
      marca: 'Volkswagen',
      linea: 'Gol Trendline',
      ano: 2018,
      precio: 37000000.0,
      kilometraje: 64000,
      ciudad: 'Palmira, Valle',
      idVendedor: 'usr_part_01',
      publicador: 'Particular',
      transmision: 'Mecánica',
      combustible: 'Gasolina',
      color: 'Plata Sirius',
      descripcion: 'Vehículo muy económico y confiable mecánicamente. Documentos e impuestos al día.',
    ),
    VehiculoAnuncio(
      id: 'v7',
      marca: 'Nissan',
      linea: 'Frontier NP300 Doble Cabina',
      ano: 2020,
      precio: 92000000.0,
      kilometraje: 58000,
      ciudad: 'Pereira, Risaralda',
      idVendedor: 'usr_dealer_01',
      publicador: 'Concesionario',
      transmision: 'Mecánica 4x4',
      combustible: 'Diésel',
      color: 'Gris Oscuro',
      descripcion: 'Camioneta 4x4 ideal para trabajo pesado o viajes familiares. Mantenimiento general recién realizado.',
    ),
    VehiculoAnuncio(
      id: 'v8',
      marca: 'Ford',
      linea: 'EcoSport Titanium 2.0',
      ano: 2019,
      precio: 54000000.0,
      kilometraje: 55300,
      ciudad: 'Cali, Valle del Cauca',
      idVendedor: 'usr_part_01',
      publicador: 'Particular',
      transmision: 'Automática',
      combustible: 'Gasolina',
      color: 'Azul Belice',
      descripcion: 'Versión tope de gama Titanium, sistema de audio premium, tapizado en cuero claro y sunroof eléctrico.',
    ),
    VehiculoAnuncio(
      id: 'v9',
      marca: 'Hyundai',
      linea: 'Tucson Limited 4WD',
      ano: 2021,
      precio: 86000000.0,
      kilometraje: 41000,
      ciudad: 'Bogotá D.C.',
      idVendedor: 'usr_dealer_01',
      publicador: 'Concesionario',
      transmision: 'Automática',
      combustible: 'Gasolina',
      color: 'Negro Phantom',
      descripcion: 'Tracción total inteligente 4WD, sensores 360, freno de mano electrónico con Auto Hold.',
    ),
    VehiculoAnuncio(
      id: 'v10',
      marca: 'Suzuki',
      linea: 'Swift Híbrido GLX',
      ano: 2023,
      precio: 62000000.0,
      kilometraje: 18200,
      ciudad: 'Cali, Valle del Cauca',
      idVendedor: 'usr_part_01',
      publicador: 'Particular',
      transmision: 'Mecánica',
      combustible: 'Híbrido',
      color: 'Azul Perlado',
      descripcion: 'Casi nuevo, tecnología microhíbrida SHVS, sin restricción de movilidad y garantía vigente.',
    ),
  ];

  Future<List<VehiculoAnuncio>> obtenerVehiculos() async {
    if (_initialized) {
      return List.unmodifiable(_cache);
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonStr = prefs.getString(_storageKey);

      if (jsonStr != null && jsonStr.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        _cache.clear();
        for (final item in decoded) {
          if (item is Map<String, dynamic>) {
            _cache.add(VehiculoAnuncio.fromMap(item));
          } else if (item is Map) {
            _cache.add(VehiculoAnuncio.fromMap(Map<String, dynamic>.from(item)));
          }
        }
      } else {
        _cache.clear();
        _cache.addAll(_defaultVehiculos);
        await _guardarEnPrefs(prefs);
      }
    } catch (_) {
      if (_cache.isEmpty) {
        _cache.addAll(_defaultVehiculos);
      }
    }

    _initialized = true;
    return List.unmodifiable(_cache);
  }

  Future<void> agregarVehiculo(VehiculoAnuncio nuevo) async {
    if (!_initialized) {
      await obtenerVehiculos();
    }
    _cache.insert(0, nuevo);

    try {
      final prefs = await SharedPreferences.getInstance();
      await _guardarEnPrefs(prefs);
    } catch (_) {}
  }

  Future<void> eliminarVehiculo(String id) async {
    if (!_initialized) {
      await obtenerVehiculos();
    }
    _cache.removeWhere((v) => v.id == id);

    try {
      final prefs = await SharedPreferences.getInstance();
      await _guardarEnPrefs(prefs);
    } catch (_) {}
  }

  /// Retorna la lista de relaciones Favorito (relación relacional usuario-vehículo)
  Future<List<Favorito>> obtenerRelacionesFavoritos([String idUsuario = 'usr_emp_01']) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonStr = prefs.getString(_favoritosKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        return decoded
            .map((e) => Favorito.fromMap(Map<String, dynamic>.from(e)))
            .where((f) => f.idUsuario == idUsuario)
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Retorna los IDs de vehículos favoritos (compatibilidad directa con la UI)
  Future<List<String>> obtenerFavoritosIds([String idUsuario = 'usr_emp_01']) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = prefs.getStringList(_favoritosIdsKey);
      if (ids != null) return ids;

      // Respaldo desde la entidad relacional
      final favs = await obtenerRelacionesFavoritos(idUsuario);
      return favs.map((f) => f.idVehiculo).toList();
    } catch (_) {
      return [];
    }
  }

  /// Guarda y sincroniza tanto la lista de IDs como las entidades Favorito
  Future<void> guardarFavoritosIds(List<String> ids, [String idUsuario = 'usr_emp_01']) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritosIdsKey, ids);

      // Modelar y persistir la relación relacional Usuario - Vehículo
      final relaciones = ids.map((idVehiculo) => Favorito(
        id: 'fav_${idUsuario}_$idVehiculo',
        idUsuario: idUsuario,
        idVehiculo: idVehiculo,
        fechaAgregado: DateTime.now(),
      )).map((f) => f.toMap()).toList();

      await prefs.setString(_favoritosKey, jsonEncode(relaciones));
    } catch (_) {}
  }

  Future<void> _guardarEnPrefs(SharedPreferences prefs) async {
    final listMaps = _cache.map((v) => v.toMap()).toList();
    await prefs.setString(_storageKey, jsonEncode(listMaps));
  }
}
