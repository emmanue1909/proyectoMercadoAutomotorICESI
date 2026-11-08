import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trabajador.dart';

class TrabajadoresService {
  static final TrabajadoresService _instance = TrabajadoresService._internal();
  factory TrabajadoresService() => _instance;
  TrabajadoresService._internal();

  static const String _storageKey = 'automarket_trabajadores_v1';

  final List<Trabajador> _cache = [];
  bool _initialized = false;

  final List<Trabajador> _defaultTrabajadores = [
    Trabajador(
      id: '1',
      nombre: 'Juan Pérez',
      cedula: '1002345678',
      correo: 'juan.perez@automarket.com',
      telefono: '310 456 7890',
      rol: 'Asesor Comercial',
      sucursal: 'Sede Principal (Cali)',
      fechaIngreso: '15/01/2024',
    ),
    Trabajador(
      id: '2',
      nombre: 'María Gómez',
      cedula: '1003456789',
      correo: 'maria.gomez@automarket.com',
      telefono: '315 789 1234',
      rol: 'Analista de Precios',
      sucursal: 'Sede Norte (Cali)',
      fechaIngreso: '01/06/2024',
    ),
  ];

  Future<List<Trabajador>> obtenerTrabajadores() async {
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
            _cache.add(Trabajador.fromMap(item));
          } else if (item is Map) {
            _cache.add(Trabajador.fromMap(Map<String, dynamic>.from(item)));
          }
        }
      } else {
        _cache.clear();
        _cache.addAll(_defaultTrabajadores);
        await _guardarEnPrefs(prefs);
      }
    } catch (e) {
      // Si ocurre un error al acceder a almacenamiento persistente, mantener el cache en memoria
      if (_cache.isEmpty) {
        _cache.addAll(_defaultTrabajadores);
      }
    }

    _initialized = true;
    return List.unmodifiable(_cache);
  }

  Future<void> agregarTrabajador(Trabajador nuevo) async {
    if (!_initialized) {
      await obtenerTrabajadores();
    }
    _cache.add(nuevo);

    try {
      final prefs = await SharedPreferences.getInstance();
      await _guardarEnPrefs(prefs);
    } catch (_) {}
  }

  Future<void> eliminarTrabajador(String id) async {
    if (!_initialized) {
      await obtenerTrabajadores();
    }
    _cache.removeWhere((t) => t.id == id);

    try {
      final prefs = await SharedPreferences.getInstance();
      await _guardarEnPrefs(prefs);
    } catch (_) {}
  }

  Future<void> _guardarEnPrefs(SharedPreferences prefs) async {
    final listMaps = _cache.map((t) => t.toMap()).toList();
    await prefs.setString(_storageKey, jsonEncode(listMaps));
  }
}
