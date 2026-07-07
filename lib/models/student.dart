class Student {
  final String id;
  final String name;
  final String? nis;
  final String? parentContact;

  Student({
    required this.id,
    required this.name,
    this.nis,
    this.parentContact,
  });
}