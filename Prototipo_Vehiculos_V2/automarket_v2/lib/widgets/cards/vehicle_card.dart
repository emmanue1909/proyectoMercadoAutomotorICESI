import 'package:flutter/material.dart';
import '../../models/vehiculo.dart';
import '../bars/app_status_badge.dart';

class VehicleCard extends StatelessWidget {
  final VehiculoAnuncio vehiculo;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onTap;

  const VehicleCard({
    Key? key,
    required this.vehiculo,
    required this.isFavorite,
    required this.onToggleFavorite,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isFavorite ? Colors.red.shade200 : Colors.grey.shade200,
          width: isFavorite ? 1.5 : 1,
        ),
      ),
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icono / Visual del vehículo
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isFavorite
                      ? Colors.red.shade50
                      : const Color(0xFF0F2041).withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.directions_car,
                  size: 36,
                  color: isFavorite ? Colors.red.shade700 : const Color(0xFF0F2041),
                ),
              ),
              const SizedBox(width: 16),

              // Detalles del vehículo
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F2041),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        AppStatusBadge(
                          label: vehiculo.publicador,
                          variant: vehiculo.publicador == 'Particular'
                              ? AppBadgeVariant.info
                              : AppBadgeVariant.purple,
                        ),
                        if (isFavorite) ...[
                          const SizedBox(width: 8),
                          const AppStatusBadge(
                            label: 'En Favoritos',
                            icon: Icons.favorite,
                            variant: AppBadgeVariant.danger,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      runSpacing: 6,
                      children: [
                        Text(
                          'Precio: ${vehiculo.precioFormateado}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.speed, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              vehiculo.kilometrajeFormateado,
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.settings, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              vehiculo.transmision,
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_gas_station, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              vehiculo.combustible,
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              vehiculo.ubicacion,
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Botón de favorito con corazón
              Tooltip(
                message: isFavorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: onToggleFavorite,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isFavorite ? Colors.red.shade50 : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey.shade600,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Flecha para abrir detalle
              if (onTap != null)
                Tooltip(
                  message: 'Ver ficha técnica completa',
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 28,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
