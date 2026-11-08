import 'package:flutter/material.dart';
import '../models/vehiculo.dart';
import '../widgets/widgets.dart';

class VehicleCreatePage extends StatefulWidget {
  final ValueChanged<VehiculoAnuncio> onCreate;
  final VoidCallback onCancel;

  const VehicleCreatePage({
    Key? key,
    required this.onCreate,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<VehicleCreatePage> createState() => _VehicleCreatePageState();
}

class _VehicleCreatePageState extends State<VehicleCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final _tituloController = TextEditingController();
  final _precioController = TextEditingController();
  final _kilometrajeController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _colorController = TextEditingController();
  final _anoController = TextEditingController();
  final _descripcionController = TextEditingController();

  String _publicador = 'Particular';
  String _transmision = 'Automática';
  String _combustible = 'Gasolina';

  final List<String> _publicadores = ['Particular', 'Concesionario'];
  final List<String> _transmisiones = ['Automática', 'Mecánica', 'CVT', 'Mecánica 4x4'];
  final List<String> _combustibles = ['Gasolina', 'Diésel', 'Híbrido', 'Eléctrico', 'Gas / Gasolina'];

  @override
  void dispose() {
    _tituloController.dispose();
    _precioController.dispose();
    _kilometrajeController.dispose();
    _ubicacionController.dispose();
    _colorController.dispose();
    _anoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final precioTexto = _precioController.text.trim();
    final precioFormateado = precioTexto.startsWith('\$') ? precioTexto : '\$ $precioTexto COP';

    final kmTexto = _kilometrajeController.text.trim();
    final kmFormateado = kmTexto.toLowerCase().endsWith('km') ? kmTexto : '$kmTexto km';

    final nuevo = VehiculoAnuncio(
      id: 'v_${DateTime.now().millisecondsSinceEpoch}',
      titulo: _tituloController.text.trim(),
      precio: precioFormateado,
      kilometraje: kmFormateado,
      ubicacion: _ubicacionController.text.trim(),
      publicador: _publicador,
      transmision: _transmision,
      combustible: _combustible,
      color: _colorController.text.trim().isNotEmpty ? _colorController.text.trim() : 'Gris',
      ano: _anoController.text.trim().isNotEmpty ? _anoController.text.trim() : '2023',
      descripcion: _descripcionController.text.trim(),
    );

    widget.onCreate(nuevo);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTopBar(
            title: 'Publicar Nuevo Vehículo',
            subtitle: 'Complete los datos para agregar un nuevo anuncio al catálogo del sistema',
            onBack: widget.onCancel,
          ),
          AppCard(
            padding: const EdgeInsets.all(28.0),
            elevation: 2,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información General del Vehículo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F2041),
                    ),
                  ),
                  const SizedBox(height: 18),

                  AppTextField(
                    controller: _tituloController,
                    label: 'Título del Anuncio *',
                    hintText: 'Ej: Mazda CX-30 Grand Touring 2022',
                    prefixIcon: Icons.title,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Por favor ingrese el título del anuncio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _precioController,
                          label: 'Precio Comercial *',
                          hintText: 'Ej: 85.000.000',
                          prefixIcon: Icons.attach_money,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Por favor ingrese el precio';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: AppTextField(
                          controller: _kilometrajeController,
                          label: 'Kilometraje *',
                          hintText: 'Ej: 32.000',
                          prefixIcon: Icons.speed,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Por favor ingrese el kilometraje';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _ubicacionController,
                          label: 'Ubicación / Ciudad *',
                          hintText: 'Ej: Cali, Valle del Cauca',
                          prefixIcon: Icons.location_on_outlined,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Por favor ingrese la ciudad o ubicación';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: AppDropdownField<String>(
                          label: 'Tipo de Publicador *',
                          value: _publicador,
                          items: _publicadores,
                          itemLabel: (p) => p,
                          prefixIcon: Icons.badge_outlined,
                          onChanged: (val) {
                            if (val != null) setState(() => _publicador = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: AppDropdownField<String>(
                          label: 'Transmisión *',
                          value: _transmision,
                          items: _transmisiones,
                          itemLabel: (t) => t,
                          prefixIcon: Icons.settings,
                          onChanged: (val) {
                            if (val != null) setState(() => _transmision = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: AppDropdownField<String>(
                          label: 'Combustible *',
                          value: _combustible,
                          items: _combustibles,
                          itemLabel: (c) => c,
                          prefixIcon: Icons.local_gas_station,
                          onChanged: (val) {
                            if (val != null) setState(() => _combustible = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _anoController,
                          label: 'Año del Modelo',
                          hintText: 'Ej: 2022',
                          prefixIcon: Icons.calendar_today,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: AppTextField(
                          controller: _colorController,
                          label: 'Color de Carrocería',
                          hintText: 'Ej: Blanco Perla',
                          prefixIcon: Icons.palette_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _descripcionController,
                    label: 'Descripción Adicional',
                    hintText: 'Detalles sobre equipamiento, estado de los neumáticos, mantenimiento...',
                    prefixIcon: Icons.description_outlined,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton(
                        label: 'Cancelar',
                        variant: AppButtonVariant.outlined,
                        onPressed: widget.onCancel,
                      ),
                      const SizedBox(width: 12),
                      AppButton(
                        label: 'Guardar y Publicar Anuncio',
                        icon: Icons.check,
                        variant: AppButtonVariant.primary,
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
