import 'package:flutter/material.dart';

import '../models/attendance_record.dart';

/// Widget untuk menampilkan satu baris data absensi.
class AttendanceRecordTile extends StatelessWidget {
  final AttendanceRecord record;

  const AttendanceRecordTile({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: record.status == 'Hadir'
              ? Colors.green
              : record.status == 'Izin'
                  ? Colors.orange
                  : Colors.red,
          child: Text(record.studentName[0].toUpperCase()),
        ),
        title: Text(record.studentName),
        subtitle: Text('Tanggal: ${record.date.day}/${record.date.month}/${record.date.year}'),
        trailing: Text(
          record.status,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: record.status == 'Hadir'
                ? Colors.green
                : record.status == 'Izin'
                    ? Colors.orange
                    : Colors.red,
          ),
        ),
      ),
    );
  }
}
