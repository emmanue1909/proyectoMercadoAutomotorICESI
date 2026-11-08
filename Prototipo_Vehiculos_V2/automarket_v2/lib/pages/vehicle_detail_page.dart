import 'package:flutter/material.dart';
import '../models/vehiculo.dart';
import '../widgets/widgets.dart';

class VehicleDetailPage extends StatelessWidget {
  final VehiculoAnuncio vehiculo;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onBack;
  final VoidCallback? onContactSeller;

  const VehicleDetailPage({
    Key? key,
    required this.vehiculo,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onBack,
    this.onContactSeller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra superior con botón volver
          AppTopBar(
            title: 'Detalle del Vehículo',
            subtitle: 'Ficha técnica y especificaciones completas',
            onBack: onBack,
            actions: [
              AppButton(
                label: isFavorite ? 'En Favoritos' : 'Añadir a Favoritos',
                icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                variant: isFavorite ? AppButtonVariant.danger : AppButtonVariant.outlined,
                onPressed: onToggleFavorite,
              ),
              const SizedBox(width: 12),
              if (onContactSeller != null)
                AppButton(
                  label: 'Contactar Vendedor',
                  icon: Icons.chat_bubble_outline,
                  variant: AppButtonVariant.primary,
                  onPressed: onContactSeller,
                ),
            ],
          ),

          // Tarjeta principal de resumen
          AppCard(
            padding: const EdgeInsets.all(24.0),
            elevation: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F2041).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.directions_car,
                      size: 64,
                      color: Color(0xFF0F2041),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              vehiculo.titulo,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F2041),
                              ),
                            ),
                          ),
                          AppStatusBadge(
                            label: vehiculo.publicador,
                            variant: vehiculo.publicador == 'Particular'
                                ? AppBadgeVariant.info
                                : AppBadgeVariant.purple,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        vehiculo.precioFormateado,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            vehiculo.ubicacion,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Ficha técnica (Grid de especificaciones)
          const Text(
            'Ficha Técnica y Características',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F2041),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: VehicleSpecTile(
                  icon: Icons.speed,
                  label: 'Kilometraje',
                  value: vehiculo.kilometrajeFormateado,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: VehicleSpecTile(
                  icon: Icons.settings,
                  label: 'Transmisión',
                  value: vehiculo.transmision,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: VehicleSpecTile(
                  icon: Icons.local_gas_station,
                  label: 'Combustible',
                  value: vehiculo.combustible,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: VehicleSpecTile(
                  icon: Icons.calendar_today,
                  label: 'Año / Modelo',
                  value: '${vehiculo.ano}',
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: VehicleSpecTile(
                  icon: Icons.palette_outlined,
                  label: 'Color de Carrocería',
                  value: vehiculo.color ?? 'Gris',
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: VehicleSpecTile(
                  icon: Icons.person_pin_outlined,
                  label: 'Publicado por',
                  value: vehiculo.publicador,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Tarjeta de Descripción
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.description_outlined, color: Color(0xFF0F2041), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Descripción del Anuncio',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F2041),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  vehiculo.descripcion != null && vehiculo.descripcion!.isNotEmpty
                      ? vehiculo.descripcion!
                      : 'Vehículo en óptimas condiciones mecánicas y de latonería. Mantenimientos preventivos al día. Documentación lista para traspaso sin multas ni pignoraciones.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Botón inferior para volver
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                label: 'Regresar a la Lista',
                icon: Icons.arrow_back,
                variant: AppButtonVariant.outlined,
                onPressed: onBack,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
