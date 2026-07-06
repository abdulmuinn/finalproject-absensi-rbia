import 'dart:async';

import '../models/attendance_record.dart';

/// Repository sederhana untuk membaca dan menulis data absensi.
///
/// Menyimpan data dalam memori dan menyiapkan [Stream] agar UI dapat
/// bereaksi otomatis saat data berubah.
class AttendanceRepository {
  final _controller = StreamController<List<AttendanceRecord>>.broadcast();

  final List<AttendanceRecord> _records = [
    AttendanceRecord(
      id: 1,
      studentName: 'Ahmad',
      status: 'Hadir',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    AttendanceRecord(
      id: 2,
      studentName: 'Siti',
      status: 'Izin',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    AttendanceRecord(
      id: 3,
      studentName: 'Budi',
      status: 'Sakit',
      date: DateTime.now(),
    ),
  ];

  AttendanceRepository() {
    // Langsung kirim data awal saat repository dibuat.
    _controller.add(List.from(_records));
  }

  /// Simulasi pengambilan data dari API atau database.
  Future<List<AttendanceRecord>> fetchRecords() async {
    await Future.delayed(const Duration(milliseconds: 900));
    return List.from(_records);
  }

  /// Memberikan stream data sehingga UI bisa memperbarui secara real time.
  Stream<List<AttendanceRecord>> watchRecords() => _controller.stream;

  /// Menambahkan record baru dan menerbitkan update ke semua pendengar.
  void addRecord(AttendanceRecord record) {
    _records.add(record);
    _controller.add(List.from(_records));
  }

  /// Tutup stream saat repository tidak diperlukan lagi.
  void dispose() {
    _controller.close();
  }
}
