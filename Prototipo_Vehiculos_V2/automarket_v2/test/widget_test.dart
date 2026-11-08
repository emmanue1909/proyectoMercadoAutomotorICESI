import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:automarket_v2/main.dart';
import 'package:automarket_v2/models/vehiculo.dart';
import 'package:automarket_v2/models/usuario.dart';
import 'package:automarket_v2/models/favorito.dart';
import 'package:automarket_v2/widgets/widgets.dart';
import 'package:automarket_v2/pages/vehicle_list_page.dart';
import 'package:automarket_v2/pages/vehicle_detail_page.dart';
import 'package:automarket_v2/pages/vehicle_create_page.dart';

void main() {
  test('0. Coherencia con modelo de BD relacional: tipos numéricos, llaves y modelos', () {
    const vehiculo = VehiculoAnuncio(
      id: 'v1',
      marca: 'Mazda',
      linea: '3 Grand Touring',
      ano: 2019,
      precio: 65000000.0,
      kilometraje: 48500,
      ciudad: 'Cali, Valle del Cauca',
      idVendedor: 'usr_part_01',
      publicador: 'Particular',
      transmision: 'Automática',
      combustible: 'Gasolina',
      color: 'Rojo Diamante',
    );

    // Tipos numéricos para la BD
    expect(vehiculo.precio, isA<double>());
    expect(vehiculo.precio, 65000000.0);
    expect(vehiculo.kilometraje, isA<int>());
    expect(vehiculo.kilometraje, 48500);
    expect(vehiculo.ano, isA<int>());
    expect(vehiculo.ano, 2019);

    // Campos separados
    expect(vehiculo.marca, 'Mazda');
    expect(vehiculo.linea, '3 Grand Touring');
    expect(vehiculo.titulo, 'Mazda 3 Grand Touring 2019');

    // Getters para UI
    expect(vehiculo.precioFormateado, '\$ 65.000.000 COP');
    expect(vehiculo.kilometrajeFormateado, '48.500 km');

    // Modelo Usuario y roles
    const usuario = Usuario(
      id: 'usr_emp_01',
      nombre: 'Carlos Rodríguez',
      correo: 'carlos@automarket.com',
      rol: 'Empleado',
    );
    expect(usuario.rol, 'Empleado');

    // Relación Favorito Usuario-Vehiculo
    final fav = Favorito(
      id: 'fav_1',
      idUsuario: usuario.id,
      idVehiculo: vehiculo.id,
      fechaAgregado: DateTime.now(),
    );
    expect(fav.idUsuario, usuario.id);
    expect(fav.idVehiculo, vehiculo.id);
  });

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
      marca: 'Toyota',
      linea: 'Hilux',
      ano: 2022,
      precio: 150000000.0,
      kilometraje: 25000,
      ciudad: 'Cali',
      idVendedor: 'usr_part_01',
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
      marca: 'Mazda',
      linea: 'CX-5',
      ano: 2020,
      precio: 88000000.0,
      kilometraje: 40000,
      ciudad: 'Medellín',
      idVendedor: 'usr_part_01',
      publicador: 'Particular',
      transmision: 'Automática',
      combustible: 'Gasolina',
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

    // Ingresar datos requeridos de forma normalizada
    await tester.enterText(find.widgetWithText(AppTextField, 'Marca *'), 'Renault');
    await tester.enterText(find.widgetWithText(AppTextField, 'Línea / Referencia *'), 'Logan');
    await tester.enterText(find.widgetWithText(AppTextField, 'Precio Comercial (COP) *'), '42000000');
    await tester.enterText(find.widgetWithText(AppTextField, 'Kilometraje *'), '30000');
    await tester.enterText(find.widgetWithText(AppTextField, 'Ciudad / Ubicación *'), 'Cali');
    await tester.enterText(find.widgetWithText(AppTextField, 'Año / Modelo *'), '2021');

    // Presionar guardar
    final guardarBtn = find.text('Guardar y Publicar Anuncio');
    await tester.ensureVisible(guardarBtn);
    await tester.tap(guardarBtn);
    await tester.pump();

    expect(creado, isNotNull);
    expect(creado!.marca, 'Renault');
    expect(creado!.linea, 'Logan');
    expect(creado!.ano, 2021);
    expect(creado!.titulo, 'Renault Logan 2021');
    expect(creado!.precio, 42000000.0);
    expect(creado!.precioFormateado, '\$ 42.000.000 COP');
    expect(creado!.kilometraje, 30000);
    expect(creado!.kilometrajeFormateado, '30.000 km');
    expect(creado!.idVendedor, isNotEmpty);

    // Probar cancelar
    final cancelBtn = find.text('Cancelar');
    await tester.ensureVisible(cancelBtn);
    await tester.tap(cancelBtn);
    await tester.pump();
    expect(cancelCalled, isTrue);
  });
}
