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

  final _marcaController = TextEditingController();
  final _lineaController = TextEditingController();
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
    _marcaController.dispose();
    _lineaController.dispose();
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

    // Parseo numérico estricto acorde al modelo relacional de la BD
    final rawPrecio = _precioController.text.replaceAll(RegExp(r'[^\d.]'), '').trim();
    final double precioNum = double.tryParse(rawPrecio) ?? 0.0;

    final rawKm = _kilometrajeController.text.replaceAll(RegExp(r'[^\d]'), '').trim();
    final int kmNum = int.tryParse(rawKm) ?? 0;

    final rawAno = _anoController.text.replaceAll(RegExp(r'[^\d]'), '').trim();
    final int anoNum = int.tryParse(rawAno) ?? DateTime.now().year;

    final marca = _marcaController.text.trim();
    final linea = _lineaController.text.trim();

    // idVendedor actúa como llave foránea hacia la tabla de Usuarios / Vendedores
    final idVendedor = _publicador == 'Concesionario' ? 'usr_dealer_01' : 'usr_part_01';

    final nuevo = VehiculoAnuncio(
      id: 'v_${DateTime.now().millisecondsSinceEpoch}',
      marca: marca,
      linea: linea,
      ano: anoNum,
      precio: precioNum,
      kilometraje: kmNum,
      ciudad: _ubicacionController.text.trim(),
      idVendedor: idVendedor,
      publicador: _publicador,
      transmision: _transmision,
      combustible: _combustible,
      color: _colorController.text.trim().isNotEmpty ? _colorController.text.trim() : 'Gris',
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
            subtitle: 'Complete los datos normalizados para registrar el anuncio en la base de datos',
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

                  // Marca y Línea separadas (no concatenadas en un string)
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _marcaController,
                          label: 'Marca *',
                          hintText: 'Ej: Mazda, Chevrolet, Toyota',
                          prefixIcon: Icons.directions_car,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Por favor ingrese la marca';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: AppTextField(
                          controller: _lineaController,
                          label: 'Línea / Referencia *',
                          hintText: 'Ej: 3 Grand Touring, Tracker Turbo',
                          prefixIcon: Icons.local_offer_outlined,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Por favor ingrese la línea';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Precio y Kilometraje como números
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _precioController,
                          label: 'Precio Comercial (COP) *',
                          hintText: 'Ej: 65000000',
                          prefixIcon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Por favor ingrese el precio';
                            }
                            final limpio = val.replaceAll(RegExp(r'[^\d.]'), '');
                            if (double.tryParse(limpio) == null || double.parse(limpio) <= 0) {
                              return 'Ingrese un valor numérico válido';
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
                          hintText: 'Ej: 48500',
                          prefixIcon: Icons.speed,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Por favor ingrese el kilometraje';
                            }
                            final limpio = val.replaceAll(RegExp(r'[^\d]'), '');
                            if (int.tryParse(limpio) == null) {
                              return 'Ingrese un número entero';
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
                          label: 'Ciudad / Ubicación *',
                          hintText: 'Ej: Cali, Valle del Cauca',
                          prefixIcon: Icons.location_on_outlined,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Por favor ingrese la ciudad';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: AppDropdownField<String>(
                          label: 'Tipo de Publicador / Vendedor *',
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
                          label: 'Año / Modelo *',
                          hintText: 'Ej: 2022',
                          prefixIcon: Icons.calendar_today,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Por favor ingrese el año';
                            }
                            final year = int.tryParse(val.trim());
                            if (year == null || year < 1950 || year > 2030) {
                              return 'Ingrese un año válido (ej. 2021)';
                            }
                            return null;
                          },
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
