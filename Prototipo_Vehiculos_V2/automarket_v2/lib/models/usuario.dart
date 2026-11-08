class Usuario {
  final String id;
  final String nombre;
  final String correo;
  final String rol; // 'Empleado' | 'Administrador' | 'Particular' | 'Concesionario'
  final String? telefono;
  final String? sucursal;
  final bool activo;

  const Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rol,
    this.telefono,
    this.sucursal,
    this.activo = true,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nombre': nombre,
    'correo': correo,
    'rol': rol,
    'telefono': telefono,
    'sucursal': sucursal,
    'activo': activo,
  };

  factory Usuario.fromMap(Map<String, dynamic> map) => Usuario(
    id: map['id']?.toString() ?? '',
    nombre: map['nombre']?.toString() ?? '',
    correo: map['correo']?.toString() ?? '',
    rol: map['rol']?.toString() ?? 'Empleado',
    telefono: map['telefono']?.toString(),
    sucursal: map['sucursal']?.toString(),
    activo: map['activo'] is bool ? map['activo'] : true,
  );

  /// Usuarios de ejemplo coherentes con el modelo relacional de la BD
  static const List<Usuario> usuariosSimulados = [
    Usuario(
      id: 'usr_emp_01',
      nombre: 'Carlos Rodríguez',
      correo: 'carlos.rodriguez@automarket.com',
      rol: 'Empleado',
      telefono: '3128901234',
      sucursal: 'Sede Cali Norte',
    ),
    Usuario(
      id: 'usr_adm_01',
      nombre: 'Administrador del Sistema',
      correo: 'admin@automarket.com',
      rol: 'Administrador',
      telefono: '3104567890',
      sucursal: 'Sede Principal',
    ),
    Usuario(
      id: 'usr_part_01',
      nombre: 'Juan Camilo Pérez',
      correo: 'juan.perez@gmail.com',
      rol: 'Particular',
      telefono: '3157891234',
    ),
    Usuario(
      id: 'usr_dealer_01',
      nombre: 'Madiautos Cali',
      correo: 'contacto@madiautos.com',
      rol: 'Concesionario',
      telefono: '6024891000',
      sucursal: 'Av. Pasoancho',
    ),
  ];
}
