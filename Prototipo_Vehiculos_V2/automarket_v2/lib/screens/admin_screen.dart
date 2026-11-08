import 'package:flutter/material.dart';
import '../models/trabajador.dart';
import '../services/trabajadores_service.dart';
import '../widgets/widgets.dart';
import '../pages/worker_list_page.dart';
import '../pages/gallery_page.dart';
import 'login_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TrabajadoresService _service = TrabajadoresService();
  List<Trabajador> _trabajadores = [];
  bool _cargando = true;
  String _busqueda = '';
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _cargarTrabajadores();
  }

  Future<void> _cargarTrabajadores() async {
    setState(() => _cargando = true);
    final lista = await _service.obtenerTrabajadores();
    if (mounted) {
      setState(() {
        _trabajadores = lista;
        _cargando = false;
      });
    }
  }

  void _abrirModalAgregarTrabajador() {
    final formKey = GlobalKey<FormState>();
    final nombreCtrl = TextEditingController();
    final cedulaCtrl = TextEditingController();
    final correoCtrl = TextEditingController();
    final telefonoCtrl = TextEditingController();
    String rolSeleccionado = 'Asesor Comercial';
    String sucursalSeleccionada = 'Sede Principal (Cali)';

    final rolesDisponibles = [
      'Asesor Comercial',
      'Analista de Precios',
      'Gestor de Inventario',
      'Asesor de Servicio',
      'Administrador de Patio',
    ];

    final sucursalesDisponibles = [
      'Sede Principal (Cali)',
      'Sede Norte (Cali)',
      'Sede Sur (Cali)',
      'Sede Bogotá',
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              clipBehavior: Clip.antiAlias,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 550, maxHeight: 680),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                      color: const Color(0xFF0F2041),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.person_add_alt_1, color: Colors.white),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Agregar Trabajador',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Ingrese los datos del nuevo trabajador para registrarlo',
                                  style: TextStyle(color: Colors.white70, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white70),
                            onPressed: () => Navigator.of(dialogCtx).pop(),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextField(
                                controller: nombreCtrl,
                                label: 'Nombre Completo *',
                                hintText: 'Ej: Carlos Andrés Mendoza',
                                prefixIcon: Icons.person_outline,
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'Por favor ingrese el nombre completo';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppTextField(
                                      controller: cedulaCtrl,
                                      keyboardType: TextInputType.number,
                                      label: 'Cédula / Documento *',
                                      hintText: 'Ej: 1144123456',
                                      prefixIcon: Icons.badge_outlined,
                                      validator: (val) {
                                        if (val == null || val.trim().isEmpty) {
                                          return 'Ingrese la cédula';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: AppTextField(
                                      controller: telefonoCtrl,
                                      keyboardType: TextInputType.phone,
                                      label: 'Teléfono / Celular *',
                                      hintText: 'Ej: 318 555 4321',
                                      prefixIcon: Icons.phone_outlined,
                                      validator: (val) {
                                        if (val == null || val.trim().isEmpty) {
                                          return 'Ingrese el teléfono';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              AppTextField(
                                controller: correoCtrl,
                                keyboardType: TextInputType.emailAddress,
                                label: 'Correo Electrónico *',
                                hintText: 'Ej: carlos.mendoza@automarket.com',
                                prefixIcon: Icons.email_outlined,
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'Ingrese el correo electrónico';
                                  }
                                  if (!val.contains('@') || !val.contains('.')) {
                                    return 'Ingrese un correo electrónico válido';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              AppDropdownField<String>(
                                label: 'Cargo / Rol *',
                                value: rolSeleccionado,
                                items: rolesDisponibles,
                                itemLabel: (r) => r,
                                prefixIcon: Icons.work_outline,
                                onChanged: (nuevo) {
                                  if (nuevo != null) {
                                    setModalState(() => rolSeleccionado = nuevo);
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              AppDropdownField<String>(
                                label: 'Sede / Sucursal *',
                                value: sucursalSeleccionada,
                                items: sucursalesDisponibles,
                                itemLabel: (s) => s,
                                prefixIcon: Icons.store_mall_directory_outlined,
                                onChanged: (nuevo) {
                                  if (nuevo != null) {
                                    setModalState(() => sucursalSeleccionada = nuevo);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border(top: BorderSide(color: Colors.grey.shade300)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppButton(
                            label: 'Cancelar',
                            variant: AppButtonVariant.ghost,
                            onPressed: () => Navigator.of(dialogCtx).pop(),
                          ),
                          const SizedBox(width: 12),
                          AppButton(
                            label: 'Guardar Trabajador',
                            icon: Icons.check,
                            variant: AppButtonVariant.primary,
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                final now = DateTime.now();
                                final fechaStr =
                                    '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

                                final nuevoTrabajador = Trabajador(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  nombre: nombreCtrl.text.trim(),
                                  cedula: cedulaCtrl.text.trim(),
                                  correo: correoCtrl.text.trim(),
                                  telefono: telefonoCtrl.text.trim(),
                                  rol: rolSeleccionado,
                                  sucursal: sucursalSeleccionada,
                                  fechaIngreso: fechaStr,
                                );

                                await _service.agregarTrabajador(nuevoTrabajador);
                                if (!dialogCtx.mounted) return;
                                Navigator.of(dialogCtx).pop();
                                await _cargarTrabajadores();

                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Trabajador "${nuevoTrabajador.nombre}" registrado con éxito.'),
                                    backgroundColor: Colors.green.shade700,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmarEliminarTrabajador(Trabajador t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Está seguro de que desea eliminar al trabajador ${t.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _service.eliminarTrabajador(t.id);
              await _cargarTrabajadores();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Trabajador ${t.nombre} eliminado.')),
                );
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trabajadoresFiltrados = _trabajadores.where((t) {
      if (_busqueda.isEmpty) return true;
      final q = _busqueda.toLowerCase();
      return t.nombre.toLowerCase().contains(q) ||
          t.cedula.toLowerCase().contains(q) ||
          t.rol.toLowerCase().contains(q) ||
          t.correo.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      body: Row(
        children: [
          AppSidebar(
            title: 'AutoMarket Admin',
            selectedIndex: _selectedTabIndex,
            onItemSelected: (index) => setState(() => _selectedTabIndex = index),
            onLogout: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            items: const [
              SidebarItemData(
                icon: Icons.people,
                label: 'Gestión Empleados',
              ),
              SidebarItemData(
                icon: Icons.widgets_outlined,
                label: 'Galería de Widgets',
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: _cargando
                  ? const Center(child: CircularProgressIndicator())
                  : _selectedTabIndex == 0
                      ? WorkerListPage(
                          trabajadores: trabajadoresFiltrados,
                          searchQuery: _busqueda,
                          onSearchChanged: (val) => setState(() => _busqueda = val),
                          onDeleteWorker: _confirmarEliminarTrabajador,
                          onAddWorker: _abrirModalAgregarTrabajador,
                        )
                      : const GalleryPage(),
            ),
          ),
        ],
      ),
    );
  }
}
