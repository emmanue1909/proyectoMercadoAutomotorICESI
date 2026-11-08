import 'package:flutter/material.dart';
import '../models/trabajador.dart';
import '../widgets/widgets.dart';

class WorkerListPage extends StatelessWidget {
  final List<Trabajador> trabajadores;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<Trabajador> onDeleteWorker;
  final VoidCallback onAddWorker;

  const WorkerListPage({
    Key? key,
    required this.trabajadores,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onDeleteWorker,
    required this.onAddWorker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTopBar(
          title: 'Gestión de Trabajadores',
          subtitle: 'Administra el equipo y personal registrado en AutoMarket (${trabajadores.length} registrados)',
          actions: [
            AppButton(
              label: 'Agregar Trabajador',
              icon: Icons.person_add_alt_1,
              variant: AppButtonVariant.primary,
              onPressed: onAddWorker,
            ),
          ],
        ),
        AppSearchField(
          hintText: 'Buscar por nombre, cédula, cargo o correo...',
          initialValue: searchQuery,
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: 18),
        Expanded(
          child: trabajadores.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        searchQuery.isEmpty
                            ? 'No hay trabajadores registrados en la base de datos.'
                            : 'No se encontraron resultados para "$searchQuery"',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 16),
                      if (searchQuery.isEmpty)
                        AppButton(
                          label: 'Agregar Trabajador Ahora',
                          icon: Icons.add,
                          onPressed: onAddWorker,
                        ),
                    ],
                  ),
                )
              : ListView.separated(
                  itemCount: trabajadores.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final t = trabajadores[index];
                    return WorkerCard(
                      trabajador: t,
                      onDelete: () => onDeleteWorker(t),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
