import 'package:equatable/equatable.dart';

/// Model data absensi yang menyimpan informasi setiap siswa.
///
/// Menggunakan [Equatable] agar perbandingan objek lebih mudah, terutama
/// ketika BLoC memeriksa perubahan state.
class AttendanceRecord extends Equatable {
  final int id;
  final String studentName;
  final String status;
  final DateTime date;

  const AttendanceRecord({
    required this.id,
    required this.studentName,
    required this.status,
    required this.date,
  });

  @override
  List<Object?> get props => [id, studentName, status, date];
}
