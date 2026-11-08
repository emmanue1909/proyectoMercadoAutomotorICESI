class Trabajador {
  final String id;
  final String nombre;
  final String cedula;
  final String correo;
  final String telefono;
  final String rol;
  final String sucursal;
  final String fechaIngreso;

  Trabajador({
    required this.id,
    required this.nombre,
    required this.cedula,
    required this.correo,
    required this.telefono,
    required this.rol,
    required this.sucursal,
    required this.fechaIngreso,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'cedula': cedula,
      'correo': correo,
      'telefono': telefono,
      'rol': rol,
      'sucursal': sucursal,
      'fechaIngreso': fechaIngreso,
    };
  }

  factory Trabajador.fromMap(Map<String, dynamic> map) {
    return Trabajador(
      id: map['id']?.toString() ?? '',
      nombre: map['nombre']?.toString() ?? '',
      cedula: map['cedula']?.toString() ?? '',
      correo: map['correo']?.toString() ?? '',
      telefono: map['telefono']?.toString() ?? '',
      rol: map['rol']?.toString() ?? 'Empleado',
      sucursal: map['sucursal']?.toString() ?? 'Sede Principal',
      fechaIngreso: map['fechaIngreso']?.toString() ?? '',
    );
  }
}
