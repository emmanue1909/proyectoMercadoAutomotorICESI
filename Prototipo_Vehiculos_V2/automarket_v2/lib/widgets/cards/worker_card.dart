import 'package:flutter/material.dart';
import '../../models/trabajador.dart';
import '../bars/app_status_badge.dart';
import '../buttons/app_button.dart';

class WorkerCard extends StatelessWidget {
  final Trabajador trabajador;
  final VoidCallback onDelete;

  const WorkerCard({
    Key? key,
    required this.trabajador,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFF0F2041),
              child: Text(
                trabajador.nombre.isNotEmpty ? trabajador.nombre[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        trabajador.nombre,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F2041),
                        ),
                      ),
                      const SizedBox(width: 10),
                      AppStatusBadge(
                        label: trabajador.rol,
                        variant: AppBadgeVariant.info,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 4,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.badge_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('Cédula: ${trabajador.cedula}', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.email_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(trabajador.correo, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.phone_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(trabajador.telefono, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(trabajador.sucursal, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppIconButton(
              icon: Icons.delete_outline,
              color: Colors.redAccent,
              tooltip: 'Eliminar trabajador',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
