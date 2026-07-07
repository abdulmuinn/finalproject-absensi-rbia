class Subject {
  final String id;
  final String name;
  final String? description;
  final String schedule;

  Subject({
    required this.id,
    required this.name,
    this.description,
    required this.schedule,
  });
}