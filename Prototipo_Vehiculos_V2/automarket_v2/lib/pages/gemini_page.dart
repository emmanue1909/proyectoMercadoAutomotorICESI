import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class GeminiPage extends StatefulWidget {
  final bool isLoading;
  final Map<String, dynamic>? resultado;
  final ValueChanged<String> onConsultar;

  const GeminiPage({
    Key? key,
    required this.isLoading,
    required this.resultado,
    required this.onConsultar,
  }) : super(key: key);

  @override
  State<GeminiPage> createState() => _GeminiPageState();
}

class _GeminiPageState extends State<GeminiPage> {
  final TextEditingController _promptController = TextEditingController(
    text: 'Dime un precio estimado del Mazda 3 modelo 2019',
  );

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _triggerSearch() {
    final query = _promptController.text.trim();
    if (query.isNotEmpty) {
      widget.onConsultar(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppTopBar(
            title: 'Consulta y Estimación con IA (Gemini)',
            subtitle: 'Inteligencia artificial aplicada a la valoración de vehículos en tiempo real',
          ),
          AppCard(
            padding: const EdgeInsets.all(22.0),
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¿Sobre qué vehículo deseas consultar?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2041),
                  ),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _promptController,
                  label: 'Pregunta para la IA Gemini',
                  hintText: 'Ej: Dime un precio estimado del Mazda 3 modelo 2019',
                  prefixIcon: Icons.auto_awesome,
                  suffixIcon: _promptController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _promptController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  onChanged: (_) => setState(() {}),
                  onFieldSubmitted: (_) => _triggerSearch(),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Consultas rápidas:',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                    ActionChip(
                      label: const Text('Mazda 3 2019'),
                      avatar: const Icon(Icons.directions_car, size: 16),
                      onPressed: () {
                        _promptController.text = 'Dime un precio estimado del Mazda 3 modelo 2019';
                        _triggerSearch();
                      },
                    ),
                    ActionChip(
                      label: const Text('Tracker 2021'),
                      avatar: const Icon(Icons.directions_car, size: 16),
                      onPressed: () {
                        _promptController.text = 'Precio estimado Chevrolet Tracker 2021';
                        _triggerSearch();
                      },
                    ),
                    ActionChip(
                      label: const Text('Renault Duster 2020'),
                      avatar: const Icon(Icons.directions_car, size: 16),
                      onPressed: () {
                        _promptController.text = '¿Cuál es el valor comercial de una Renault Duster 2020?';
                        _triggerSearch();
                      },
                    ),
                    ActionChip(
                      label: const Text('Toyota Corolla'),
                      avatar: const Icon(Icons.directions_car, size: 16),
                      onPressed: () {
                        _promptController.text = 'Estimación Toyota Corolla modelo 2022';
                        _triggerSearch();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                AppButton(
                  label: widget.isLoading ? 'Analizando con IA...' : 'Calcular Estimación',
                  icon: Icons.analytics_outlined,
                  isLoading: widget.isLoading,
                  variant: AppButtonVariant.primary,
                  onPressed: widget.isLoading ? null : _triggerSearch,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (widget.isLoading)
            const AppCard(
              padding: EdgeInsets.all(32.0),
              elevation: 2,
              child: Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Gemini IA está procesando el análisis de mercado del vehículo...',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            )
          else if (widget.resultado != null)
            AIEstimationCard(data: widget.resultado!),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
