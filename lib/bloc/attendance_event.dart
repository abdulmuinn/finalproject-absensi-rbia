part of 'attendance_bloc.dart';

/// Base event untuk [AttendanceBloc].
///
/// Semua event BLoC absensi mewarisi kelas ini.
abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

/// Event untuk memicu pemuatan data awal absensi.
class AttendanceLoadRequested extends AttendanceEvent {}

/// Event untuk menambahkan sebuah record absensi baru.
class AttendanceAddRequested extends AttendanceEvent {
  final AttendanceRecord record;

  const AttendanceAddRequested(this.record);

  @override
  List<Object?> get props => [record];
}

/// Event internal yang dikirim ketika data repository berubah.
///
/// Event ini digunakan agar BLoC dapat memperbarui state ketika [Stream]
/// repository menerbitkan data baru.
class AttendanceRecordsUpdated extends AttendanceEvent {
  final List<AttendanceRecord> records;

  const AttendanceRecordsUpdated(this.records);

  @override
  List<Object?> get props => [records];
}
