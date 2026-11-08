import 'package:flutter/material.dart';
import '../models/vehiculo.dart';
import '../widgets/widgets.dart';

class VehicleListPage extends StatelessWidget {
  final List<VehiculoAnuncio> vehiculos;
  final List<String> favoritosIds;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<VehiculoAnuncio> onSelectVehicle;
  final ValueChanged<VehiculoAnuncio> onToggleFavorite;
  final VoidCallback onNavigateToCreate;

  const VehicleListPage({
    Key? key,
    required this.vehiculos,
    required this.favoritosIds,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onSelectVehicle,
    required this.onToggleFavorite,
    required this.onNavigateToCreate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTopBar(
          title: 'Explorador de Anuncios (Tu Carro Ya)',
          subtitle: 'Catálogo de vehículos disponibles en tiempo real (${vehiculos.length} anuncios disponibles)',
          actions: [
            const AppStatusBadge(
              label: 'Scraping Activo',
              icon: Icons.sync,
              variant: AppBadgeVariant.success,
            ),
            const SizedBox(width: 12),
            AppButton(
              label: 'Publicar Vehículo',
              icon: Icons.add_circle_outline,
              variant: AppButtonVariant.primary,
              onPressed: onNavigateToCreate,
            ),
          ],
        ),
        AppSearchField(
          hintText: 'Buscar por modelo, marca, combustible o ciudad...',
          initialValue: searchQuery,
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: 18),
        Expanded(
          child: vehiculos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.directions_car_outlined, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        searchQuery.isEmpty
                            ? 'No hay vehículos registrados en el catálogo.'
                            : 'No se encontraron vehículos para "$searchQuery"',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        label: 'Crear Nuevo Anuncio',
                        icon: Icons.add,
                        onPressed: onNavigateToCreate,
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  itemCount: vehiculos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final vehiculo = vehiculos[index];
                    final isFavorite = favoritosIds.contains(vehiculo.id);

                    return VehicleCard(
                      vehiculo: vehiculo,
                      isFavorite: isFavorite,
                      onToggleFavorite: () => onToggleFavorite(vehiculo),
                      onTap: () => onSelectVehicle(vehiculo),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
