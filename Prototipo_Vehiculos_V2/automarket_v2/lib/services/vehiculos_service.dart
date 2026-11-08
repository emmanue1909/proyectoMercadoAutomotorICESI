import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vehiculo.dart';

class VehiculosService {
  static final VehiculosService _instance = VehiculosService._internal();
  factory VehiculosService() => _instance;
  VehiculosService._internal();

  static const String _storageKey = 'automarket_vehiculos_v2';
  static const String _favoritosKey = 'automarket_favoritos_ids';

  final List<VehiculoAnuncio> _cache = [];
  bool _initialized = false;

  final List<VehiculoAnuncio> _defaultVehiculos = const [
    VehiculoAnuncio(
      id: 'v1',
      titulo: 'Mazda 3 Grand Touring 2019',
      precio: '\$ 65.000.000 COP',
      kilometraje: '48.500 km',
      ubicacion: 'Cali, Valle del Cauca',
      publicador: 'Particular',
      transmision: 'Automática',
      combustible: 'Gasolina',
      color: 'Rojo Diamante',
      ano: '2019',
      descripcion: 'Excelente estado, único dueño, mantenimientos al día en concesionario Madiautos, tapicería en cuero y sunroof.',
    ),
    VehiculoAnuncio(
      id: 'v2',
      titulo: 'Chevrolet Tracker Premier Turbo 2021',
      precio: '\$ 72.000.000 COP',
      kilometraje: '36.200 km',
      ubicacion: 'Cali, Valle del Cauca',
      publicador: 'Concesionario',
      transmision: 'Automática',
      combustible: 'Gasolina',
      color: 'Gris Mercurio',
      ano: '2021',
      descripcion: 'Versión full equipo con techo panorámico, frenado autónomo de emergencia y pantalla táctil con Apple CarPlay y Android Auto.',
    ),
    VehiculoAnuncio(
      id: 'v3',
      titulo: 'Renault Duster Zen 1.6 2020',
      precio: '\$ 58.500.000 COP',
      kilometraje: '52.000 km',
      ubicacion: 'Medellín, Antioquia',
      publicador: 'Particular',
      transmision: 'Mecánica',
      combustible: 'Gasolina',
      color: 'Blanco Glaciar',
      ano: '2020',
      descripcion: 'Camioneta espaciosa, bajo consumo de combustible, lista para traspaso inmediato sin gravámenes.',
    ),
    VehiculoAnuncio(
      id: 'v4',
      titulo: 'Toyota Corolla Cross XEI Híbrido 2022',
      precio: '\$ 98.000.000 COP',
      kilometraje: '29.000 km',
      ubicacion: 'Bogotá D.C.',
      publicador: 'Concesionario',
      transmision: 'CVT',
      combustible: 'Híbrido',
      color: 'Plata Metalizado',
      ano: '2022',
      descripcion: 'Excelente eficiencia de combustible, exento de pico y placa en las principales ciudades de Colombia.',
    ),
    VehiculoAnuncio(
      id: 'v5',
      titulo: 'Kia Picanto GT-Line 2021',
      precio: '\$ 44.500.000 COP',
      kilometraje: '39.800 km',
      ubicacion: 'Cali, Valle del Cauca',
      publicador: 'Particular',
      transmision: 'Mecánica',
      combustible: 'Gasolina',
      color: 'Rojo Pasión',
      ano: '2021',
      descripcion: 'Edición deportiva GT-Line, rines de lujo bitono, mandos al volante y luces LED.',
    ),
    VehiculoAnuncio(
      id: 'v6',
      titulo: 'Volkswagen Gol Trendline 2018',
      precio: '\$ 37.000.000 COP',
      kilometraje: '64.000 km',
      ubicacion: 'Palmira, Valle',
      publicador: 'Particular',
      transmision: 'Mecánica',
      combustible: 'Gasolina',
      color: 'Plata Sirius',
      ano: '2018',
      descripcion: 'Vehículo muy económico y confiable mecánicamente. Documentos e impuestos al día.',
    ),
    VehiculoAnuncio(
      id: 'v7',
      titulo: 'Nissan Frontier NP300 Doble Cabina 2020',
      precio: '\$ 92.000.000 COP',
      kilometraje: '58.000 km',
      ubicacion: 'Pereira, Risaralda',
      publicador: 'Concesionario',
      transmision: 'Mecánica 4x4',
      combustible: 'Diésel',
      color: 'Gris Oscuro',
      ano: '2020',
      descripcion: 'Camioneta 4x4 ideal para trabajo pesado o viajes familiares. Mantenimiento general recién realizado.',
    ),
    VehiculoAnuncio(
      id: 'v8',
      titulo: 'Ford EcoSport Titanium 2.0 2019',
      precio: '\$ 54.000.000 COP',
      kilometraje: '55.300 km',
      ubicacion: 'Cali, Valle del Cauca',
      publicador: 'Particular',
      transmision: 'Automática',
      combustible: 'Gasolina',
      color: 'Azul Belice',
      ano: '2019',
      descripcion: 'Versión tope de gama Titanium, sistema de audio premium, tapizado en cuero claro y sunroof eléctrico.',
    ),
    VehiculoAnuncio(
      id: 'v9',
      titulo: 'Hyundai Tucson Limited 4WD 2021',
      precio: '\$ 86.000.000 COP',
      kilometraje: '41.000 km',
      ubicacion: 'Bogotá D.C.',
      publicador: 'Concesionario',
      transmision: 'Automática',
      combustible: 'Gasolina',
      color: 'Negro Phantom',
      ano: '2021',
      descripcion: 'Tracción total inteligente 4WD, sensores 360, freno de mano electrónico con Auto Hold.',
    ),
    VehiculoAnuncio(
      id: 'v10',
      titulo: 'Suzuki Swift Híbrido GLX 2023',
      precio: '\$ 62.000.000 COP',
      kilometraje: '18.200 km',
      ubicacion: 'Cali, Valle del Cauca',
      publicador: 'Particular',
      transmision: 'Mecánica',
      combustible: 'Híbrido',
      color: 'Azul Perlado',
      ano: '2023',
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

  Future<List<String>> obtenerFavoritosIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_favoritosKey) ?? [];
    } catch (_) {
      return [];
    }
  }

  Future<void> guardarFavoritosIds(List<String> ids) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritosKey, ids);
    } catch (_) {}
  }

  Future<void> _guardarEnPrefs(SharedPreferences prefs) async {
    final listMaps = _cache.map((v) => v.toMap()).toList();
    await prefs.setString(_storageKey, jsonEncode(listMaps));
  }
}
