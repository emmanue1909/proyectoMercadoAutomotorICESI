import 'package:flutter/material.dart';
import '../models/vehiculo.dart';
import '../widgets/widgets.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const demoVehiculo = VehiculoAnuncio(
      id: 'demo1',
      marca: 'Mazda',
      linea: '3 Grand Touring',
      ano: 2021,
      precio: 72000000.0,
      kilometraje: 35000,
      ciudad: 'Cali, Valle del Cauca',
      idVendedor: 'usr_part_01',
      publicador: 'Particular',
      transmision: 'Automática',
      combustible: 'Gasolina',
      color: 'Rojo Diamante',
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppTopBar(
            title: 'Galería de Componentes Reutilizables',
            subtitle: 'Catálogo de componentes UI construidos una sola vez para toda la aplicación',
          ),

          // 1. SECCIÓN DE BOTONES
          const _SectionTitle(title: '1. Botones (AppButton & AppIconButton)'),
          AppCard(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppButton(
                  label: 'Primary Button',
                  icon: Icons.check,
                  variant: AppButtonVariant.primary,
                  onPressed: () {},
                ),
                AppButton(
                  label: 'Secondary Button',
                  icon: Icons.star_border,
                  variant: AppButtonVariant.secondary,
                  onPressed: () {},
                ),
                AppButton(
                  label: 'Outlined Button',
                  variant: AppButtonVariant.outlined,
                  onPressed: () {},
                ),
                AppButton(
                  label: 'Danger Button',
                  icon: Icons.delete_outline,
                  variant: AppButtonVariant.danger,
                  onPressed: () {},
                ),
                AppButton(
                  label: 'Cargando...',
                  isLoading: true,
                  variant: AppButtonVariant.primary,
                  onPressed: () {},
                ),
                AppIconButton(
                  icon: Icons.favorite,
                  color: Colors.red,
                  backgroundColor: Colors.red.shade50,
                  tooltip: 'Favorito',
                  onPressed: () {},
                ),
                AppIconButton(
                  icon: Icons.delete_outline,
                  color: Colors.redAccent,
                  tooltip: 'Eliminar',
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. SECCIÓN DE CAMPOS DE TEXTO
          const _SectionTitle(title: '2. Campos de Texto y Selección (AppTextField, AppSearchField, AppDropdownField)'),
          AppCard(
            child: Column(
              children: [
                AppSearchField(
                  hintText: 'Buscador reutilizable...',
                  onChanged: (_) {},
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Expanded(
                      child: AppTextField(
                        label: 'Campo de Texto Estándar',
                        hintText: 'Ingrese información...',
                        prefixIcon: Icons.edit_outlined,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: AppDropdownField<String>(
                        label: 'Menú Desplegable Reutilizable',
                        value: 'Opción 1',
                        items: const ['Opción 1', 'Opción 2', 'Opción 3'],
                        itemLabel: (v) => v,
                        prefixIcon: Icons.list_alt,
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. SECCIÓN DE BARRAS Y BADGES
          const _SectionTitle(title: '3. Barras, Badges y Estados (AppStatusBadge, AppTopBar)'),
          const AppCard(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                AppStatusBadge(label: 'Scraping Activo', icon: Icons.sync, variant: AppBadgeVariant.success),
                AppStatusBadge(label: 'Particular', variant: AppBadgeVariant.info),
                AppStatusBadge(label: 'Concesionario', variant: AppBadgeVariant.purple),
                AppStatusBadge(label: 'En Favoritos', icon: Icons.favorite, variant: AppBadgeVariant.danger),
                AppStatusBadge(label: 'Atención Requerida', icon: Icons.warning_amber, variant: AppBadgeVariant.warning),
                AppStatusBadge(label: 'Estado Neutral', variant: AppBadgeVariant.neutral),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4. SECCIÓN DE TARJETAS
          const _SectionTitle(title: '4. Tarjetas Reutilizables (VehicleCard & AppCard)'),
          VehicleCard(
            vehiculo: demoVehiculo,
            isFavorite: true,
            onToggleFavorite: () {},
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // 5. PROPIOS DE LA APP
          const _SectionTitle(title: '5. Componentes Propios de AutoMarket (VehicleSpecTile)'),
          const Row(
            children: [
              Expanded(
                child: VehicleSpecTile(
                  icon: Icons.speed,
                  label: 'Kilometraje',
                  value: '35.000 km',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: VehicleSpecTile(
                  icon: Icons.settings,
                  label: 'Transmisión',
                  value: 'Automática',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: VehicleSpecTile(
                  icon: Icons.local_gas_station,
                  label: 'Combustible',
                  value: 'Gasolina',
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F2041),
        ),
      ),
    );
  }
}
