import 'package:flutter/material.dart';
import '../models/vehiculo.dart';
import '../widgets/widgets.dart';

class FavoritesPage extends StatelessWidget {
  final List<VehiculoAnuncio> favoritos;
  final ValueChanged<VehiculoAnuncio> onSelectVehicle;
  final ValueChanged<VehiculoAnuncio> onRemoveFavorite;
  final VoidCallback onExplore;

  const FavoritesPage({
    Key? key,
    required this.favoritos,
    required this.onSelectVehicle,
    required this.onRemoveFavorite,
    required this.onExplore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTopBar(
          title: 'Mis Vehículos Favoritos',
          subtitle: 'Vehículos guardados para seguimiento y compra (${favoritos.length} guardados)',
          actions: [
            if (favoritos.isNotEmpty)
              AppStatusBadge(
                label: '${favoritos.length} en Favoritos',
                icon: Icons.favorite,
                variant: AppBadgeVariant.danger,
              ),
          ],
        ),
        Expanded(
          child: favoritos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      const Text(
                        'Aún no tienes vehículos en favoritos.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F2041),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Ve a la pestaña "Explorar (Scraping)" y presiona el corazón de cualquier anuncio para guardarlo aquí.',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                      const SizedBox(height: 18),
                      AppButton(
                        label: 'Explorar Anuncios',
                        icon: Icons.search,
                        onPressed: onExplore,
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  itemCount: favoritos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final vehiculo = favoritos[index];
                    return VehicleCard(
                      vehiculo: vehiculo,
                      isFavorite: true,
                      onToggleFavorite: () => onRemoveFavorite(vehiculo),
                      onTap: () => onSelectVehicle(vehiculo),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
