import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:automarket_v2/main.dart';
import 'package:automarket_v2/models/vehiculo.dart';
import 'package:automarket_v2/widgets/widgets.dart';
import 'package:automarket_v2/pages/vehicle_list_page.dart';
import 'package:automarket_v2/pages/vehicle_detail_page.dart';
import 'package:automarket_v2/pages/vehicle_create_page.dart';

void main() {
  testWidgets('1. Entrar: Muestra login inicial con botones reutilizables', (WidgetTester tester) async {
    await tester.pumpWidget(const AutoMarketApp());
    expect(find.text('AutoMarket V2'), findsOneWidget);
    expect(find.text('Ingresar como Empleado'), findsOneWidget);
    expect(find.text('Ingresar como Administrador'), findsOneWidget);
  });

  testWidgets('2. Ver la lista: VehicleListPage muestra vehículos y reporta callbacks', (WidgetTester tester) async {
    bool selectedCalled = false;
    bool favoriteCalled = false;
    bool createCalled = false;

    const testVehiculo = VehiculoAnuncio(
      id: 'test_1',
      titulo: 'Toyota Hilux 2022',
      precio: '\$ 150.000.000 COP',
      kilometraje: '25.000 km',
      ubicacion: 'Cali',
      publicador: 'Particular',
      transmision: 'Automática',
      combustible: 'Diésel',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VehicleListPage(
            vehiculos: const [testVehiculo],
            favoritosIds: const [],
            searchQuery: '',
            onSearchChanged: (_) {},
            onSelectVehicle: (v) => selectedCalled = true,
            onToggleFavorite: (v) => favoriteCalled = true,
            onNavigateToCreate: () => createCalled = true,
          ),
        ),
      ),
    );

    expect(find.text('Toyota Hilux 2022'), findsOneWidget);
    expect(find.text('Publicar Vehículo'), findsOneWidget);

    // Tocar el botón de publicar (crear algo)
    await tester.tap(find.text('Publicar Vehículo'));
    await tester.pump();
    expect(createCalled, isTrue);

    // Tocar la tarjeta para abrir detalle
    await tester.tap(find.text('Toyota Hilux 2022'));
    await tester.pump();
    expect(selectedCalled, isTrue);

    // Tocar botón de favorito
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();
    expect(favoriteCalled, isTrue);
  });

  testWidgets('3. Abrir un detalle: VehicleDetailPage muestra ficha técnica y reporta volver', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    bool backCalled = false;
    bool toggleFavCalled = false;

    const testVehiculo = VehiculoAnuncio(
      id: 'test_2',
      titulo: 'Mazda CX-5 2020',
      precio: '\$ 88.000.000 COP',
      kilometraje: '40.000 km',
      ubicacion: 'Medellín',
      publicador: 'Particular',
      transmision: 'Automática',
      combustible: 'Gasolina',
      ano: '2020',
      color: 'Rojo',
      descripcion: 'Excelente camioneta familiar con todo al día.',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VehicleDetailPage(
            vehiculo: testVehiculo,
            isFavorite: false,
            onToggleFavorite: () => toggleFavCalled = true,
            onBack: () => backCalled = true,
          ),
        ),
      ),
    );

    expect(find.text('Detalle del Vehículo'), findsOneWidget);
    expect(find.text('Mazda CX-5 2020'), findsOneWidget);
    expect(find.text('Ficha Técnica y Características'), findsOneWidget);
    expect(find.text('Excelente camioneta familiar con todo al día.'), findsOneWidget);

    // Tocar botón de volver
    final volverBtn = find.text('Regresar a la Lista');
    await tester.ensureVisible(volverBtn);
    await tester.tap(volverBtn);
    await tester.pump();
    expect(backCalled, isTrue);

    // Tocar añadir a favoritos
    final favBtn = find.text('Añadir a Favoritos');
    await tester.ensureVisible(favBtn);
    await tester.tap(favBtn);
    await tester.pump();
    expect(toggleFavCalled, isTrue);
  });

  testWidgets('4. Crear algo: VehicleCreatePage valida y reporta creación hacia la screen anfitriona', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    VehiculoAnuncio? creado;
    bool cancelCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VehicleCreatePage(
            onCreate: (v) => creado = v,
            onCancel: () => cancelCalled = true,
          ),
        ),
      ),
    );

    expect(find.text('Publicar Nuevo Vehículo'), findsOneWidget);

    // Ingresar datos requeridos
    await tester.enterText(find.widgetWithText(AppTextField, 'Título del Anuncio *'), 'Renault Logan 2021');
    await tester.enterText(find.widgetWithText(AppTextField, 'Precio Comercial *'), '42.000.000');
    await tester.enterText(find.widgetWithText(AppTextField, 'Kilometraje *'), '30.000');
    await tester.enterText(find.widgetWithText(AppTextField, 'Ubicación / Ciudad *'), 'Cali');

    // Presionar guardar
    final guardarBtn = find.text('Guardar y Publicar Anuncio');
    await tester.ensureVisible(guardarBtn);
    await tester.tap(guardarBtn);
    await tester.pump();

    expect(creado, isNotNull);
    expect(creado!.titulo, 'Renault Logan 2021');
    expect(creado!.precio, '\$ 42.000.000 COP');

    // Probar cancelar
    final cancelBtn = find.text('Cancelar');
    await tester.ensureVisible(cancelBtn);
    await tester.tap(cancelBtn);
    await tester.pump();
    expect(cancelCalled, isTrue);
  });
}
