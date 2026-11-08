import 'package:flutter/material.dart';
import '../models/vehiculo.dart';
import '../services/vehiculos_service.dart';
import '../widgets/widgets.dart';
import '../pages/vehicle_list_page.dart';
import '../pages/vehicle_detail_page.dart';
import '../pages/vehicle_create_page.dart';
import '../pages/favorites_page.dart';
import '../pages/gemini_page.dart';
import 'login_screen.dart';

enum MainFlowView {
  lista,
  detalle,
  crear,
}

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final VehiculosService _service = VehiculosService();

  // Estado que vive en la Screen anfitriona
  List<VehiculoAnuncio> _vehiculos = [];
  List<String> _favoritosIds = [];
  bool _cargando = true;

  int _selectedTabIndex = 0;
  MainFlowView _currentFlowView = MainFlowView.lista;
  VehiculoAnuncio? _selectedVehiculo;
  String _searchQuery = '';

  // Estado de Estimador IA Gemini
  bool _cargandoIA = false;
  Map<String, dynamic>? _geminiResultado;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _cargando = true);
    final lista = await _service.obtenerVehiculos();
    final favs = await _service.obtenerFavoritosIds();
    if (mounted) {
      setState(() {
        _vehiculos = lista;
        _favoritosIds = favs;
        _cargando = false;
      });
    }
  }

  // Métodos y callbacks para modificar el estado
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onSelectVehicle(VehiculoAnuncio v) {
    setState(() {
      _selectedVehiculo = v;
      _currentFlowView = MainFlowView.detalle;
    });
  }

  void _onNavigateToCreate() {
    setState(() {
      _currentFlowView = MainFlowView.crear;
    });
  }

  void _onBackToList() {
    setState(() {
      _currentFlowView = MainFlowView.lista;
      _selectedVehiculo = null;
    });
  }

  Future<void> _onCreateVehicle(VehiculoAnuncio nuevo) async {
    await _service.agregarVehiculo(nuevo);
    final listaActualizada = await _service.obtenerVehiculos();
    if (!mounted) return;

    setState(() {
      _vehiculos = listaActualizada;
      _currentFlowView = MainFlowView.lista;
      _selectedVehiculo = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Vehículo "${nuevo.titulo}" publicado exitosamente.'),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  Future<void> _onToggleFavorite(VehiculoAnuncio vehiculo) async {
    final yaEsFavorito = _favoritosIds.contains(vehiculo.id);

    setState(() {
      if (yaEsFavorito) {
        _favoritosIds.remove(vehiculo.id);
      } else {
        _favoritosIds.add(vehiculo.id);
      }
    });

    await _service.guardarFavoritosIds(_favoritosIds);

    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          yaEsFavorito
              ? 'Eliminado de tus favoritos: ${vehiculo.titulo}'
              : '❤️ Añadido a tus favoritos: ${vehiculo.titulo}',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: yaEsFavorito ? Colors.grey.shade800 : Colors.red.shade700,
      ),
    );
  }

  void _onContactSeller(VehiculoAnuncio vehiculo) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.chat_bubble_outline, color: Color(0xFF0F2041)),
            SizedBox(width: 8),
            Text('Contactar Anunciante'),
          ],
        ),
        content: Text(
          'Deseas iniciar una conversación directa con el publicador (${vehiculo.publicador}) para el vehículo ${vehiculo.titulo}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F2041),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mensaje de contacto enviado al vendedor.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Enviar Mensaje'),
          ),
        ],
      ),
    );
  }

  Future<void> _onConsultarIA(String query) async {
    setState(() {
      _cargandoIA = true;
      _geminiResultado = null;
    });

    await Future.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    final lower = query.toLowerCase();
    String vehiculo = 'Vehículo Consultado';
    String rango = '\$ 55.000.000 - \$ 62.000.000 COP';
    String precioSugerido = '\$ 58.500.000 COP';
    String demanda = 'Media';
    String depreciacion = '9.2% anual';
    String recomendacion = 'Precio acorde a mercado promedio.';

    if (lower.contains('mazda 3') || lower.contains('mazda')) {
      vehiculo = 'Mazda 3 (Modelo 2019)';
      rango = '\$ 64.000.000 - \$ 68.000.000 COP';
      precioSugerido = '\$ 66.000.000 COP';
      demanda = 'Alta (Excelente rotación en Colombia)';
      depreciacion = '7.5% anual (Baja depreciación)';
      recomendacion = 'Vehículo muy apetecido en el mercado de usados. Se recomienda verificar historial de mantenimientos en concesionario y kilometraje menor a 60.000 km.';
    } else if (lower.contains('tracker') || lower.contains('chevrolet')) {
      vehiculo = 'Chevrolet Tracker (Modelo 2021)';
      rango = '\$ 70.000.000 - \$ 75.000.000 COP';
      precioSugerido = '\$ 72.500.000 COP';
      demanda = 'Alta (Segmento SUV familiar)';
      depreciacion = '8.0% anual';
      recomendacion = 'Gran demanda por tecnología y espacio. Buen margen de retoma si se adquiere por debajo de \$69.000.000 COP.';
    } else if (lower.contains('duster') || lower.contains('renault')) {
      vehiculo = 'Renault Duster (Modelo 2020)';
      rango = '\$ 58.000.000 - \$ 63.000.000 COP';
      precioSugerido = '\$ 60.000.000 COP';
      demanda = 'Muy Alta (Líder en repuestos y mantenimiento económico)';
      depreciacion = '8.5% anual';
      recomendacion = 'Alta liquidez. Fácil de revender en menos de 20 días en patio.';
    } else if (lower.contains('toyota') || lower.contains('corolla')) {
      vehiculo = 'Toyota Corolla / Hilux';
      rango = '\$ 85.000.000 - \$ 95.000.000 COP';
      precioSugerido = '\$ 90.000.000 COP';
      demanda = 'Sobresaliente (Mínima depreciación)';
      depreciacion = '5.0% anual';
      recomendacion = 'Excelente retención de valor. Margen asegurado para compra directa.';
    } else {
      vehiculo = query;
      rango = '\$ 48.000.000 - \$ 54.000.000 COP';
      precioSugerido = '\$ 51.000.000 COP';
      demanda = 'Moderada';
      depreciacion = '9.0% anual';
      recomendacion = 'Verificar peritaje mecánico y estado de carrocería antes de realizar la oferta.';
    }

    setState(() {
      _cargandoIA = false;
      _geminiResultado = {
        'vehiculo': vehiculo,
        'rango': rango,
        'precioSugerido': precioSugerido,
        'demanda': demanda,
        'depreciacion': depreciacion,
        'recomendacion': recomendacion,
        'fecha': DateTime.now(),
      };
    });
  }

  Widget _buildBody() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    // Tab 0: Recorrido Principal (Entrar -> Ver Lista -> Abrir Detalle -> Crear Algo)
    if (_selectedTabIndex == 0) {
      switch (_currentFlowView) {
        case MainFlowView.lista:
          final filtrados = _vehiculos.where((v) {
            if (_searchQuery.isEmpty) return true;
            final q = _searchQuery.toLowerCase();
            return v.marca.toLowerCase().contains(q) ||
                v.linea.toLowerCase().contains(q) ||
                v.titulo.toLowerCase().contains(q) ||
                v.ubicacion.toLowerCase().contains(q) ||
                v.publicador.toLowerCase().contains(q) ||
                v.combustible.toLowerCase().contains(q);
          }).toList();

          return VehicleListPage(
            vehiculos: filtrados,
            favoritosIds: _favoritosIds,
            searchQuery: _searchQuery,
            onSearchChanged: _onSearchChanged,
            onSelectVehicle: _onSelectVehicle,
            onToggleFavorite: _onToggleFavorite,
            onNavigateToCreate: _onNavigateToCreate,
          );

        case MainFlowView.detalle:
          if (_selectedVehiculo == null) {
            return const Center(child: Text('Ningún vehículo seleccionado'));
          }
          return VehicleDetailPage(
            vehiculo: _selectedVehiculo!,
            isFavorite: _favoritosIds.contains(_selectedVehiculo!.id),
            onToggleFavorite: () => _onToggleFavorite(_selectedVehiculo!),
            onBack: _onBackToList,
            onContactSeller: () => _onContactSeller(_selectedVehiculo!),
          );

        case MainFlowView.crear:
          return VehicleCreatePage(
            onCreate: _onCreateVehicle,
            onCancel: _onBackToList,
          );
      }
    }

    // Tab 1: Favoritos
    if (_selectedTabIndex == 1) {
      if (_currentFlowView == MainFlowView.detalle && _selectedVehiculo != null) {
        return VehicleDetailPage(
          vehiculo: _selectedVehiculo!,
          isFavorite: _favoritosIds.contains(_selectedVehiculo!.id),
          onToggleFavorite: () => _onToggleFavorite(_selectedVehiculo!),
          onBack: _onBackToList,
          onContactSeller: () => _onContactSeller(_selectedVehiculo!),
        );
      }

      final vehiculosFavoritos = _vehiculos.where((v) => _favoritosIds.contains(v.id)).toList();
      return FavoritesPage(
        favoritos: vehiculosFavoritos,
        onSelectVehicle: _onSelectVehicle,
        onRemoveFavorite: _onToggleFavorite,
        onExplore: () {
          setState(() {
            _selectedTabIndex = 0;
            _currentFlowView = MainFlowView.lista;
          });
        },
      );
    }

    // Tab 2: Estimación Gemini IA
    return GeminiPage(
      isLoading: _cargandoIA,
      resultado: _geminiResultado,
      onConsultar: _onConsultarIA,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Barra lateral de navegación reutilizable (AppSidebar)
          AppSidebar(
            title: 'AutoMarket Empleado',
            selectedIndex: _selectedTabIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedTabIndex = index;
                _currentFlowView = MainFlowView.lista;
                _selectedVehiculo = null;
              });
            },
            onLogout: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            items: [
              const SidebarItemData(
                icon: Icons.search,
                label: 'Explorar (Scraping)',
              ),
              SidebarItemData(
                icon: Icons.favorite,
                label: 'Favoritos',
                badgeCount: _favoritosIds.length,
              ),
              const SidebarItemData(
                icon: Icons.psychology,
                label: 'Estimación (IA)',
              ),
            ],
          ),

          // Pantalla anfitriona que renderiza las Pages
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: _buildBody(),
            ),
          ),
        ],
      ),
    );
  }
}
