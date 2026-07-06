part of 'attendance_bloc.dart';

/// Base state untuk [AttendanceBloc].
///
/// State ini akan berubah saat BLoC memproses event absensi.
abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

/// State awal sebelum data dimuat.
class AttendanceInitial extends AttendanceState {}

/// State yang menunjukkan bahwa data absensi sedang dimuat.
class AttendanceLoading extends AttendanceState {}

/// State yang menunjukkan bahwa data berhasil dimuat.
class AttendanceLoadSuccess extends AttendanceState {
  final List<AttendanceRecord> records;

  const AttendanceLoadSuccess(this.records);

  @override
  List<Object?> get props => [records];
}

/// State yang menunjukkan terjadinya kegagalan saat memuat data.
class AttendanceLoadFailure extends AttendanceState {
  final String message;

  const AttendanceLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
