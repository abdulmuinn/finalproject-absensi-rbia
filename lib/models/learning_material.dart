import 'package:equatable/equatable.dart';

/// Model catatan materi pembelajaran untuk sebuah kelas.
///
/// Menggunakan [Equatable] agar perbandingan objek lebih mudah
/// ketika BLoC atau UI memeriksa perubahan state.
class LearningMaterial extends Equatable {
  final String id;
  final String className;
  final String title;
  final String? description;
  final DateTime date;

  LearningMaterial({
    required this.id,
    required this.className,
    required this.title,
    this.description,
    required this.date,
  });

  @override
  List<Object?> get props => [id, className, title, description, date];
}
