// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:absensi_rbia/main.dart';
import 'package:absensi_rbia/repository/attendance_repository.dart';

void main() {
  testWidgets('Attendance app smoke test', (WidgetTester tester) async {
    final repository = AttendanceRepository();

    await tester.pumpWidget(AttendanceApp(repository: repository));

    expect(find.text('Absensi RBIA'), findsOneWidget);
    expect(find.text('Kelas'), findsOneWidget);
    expect(find.text('Belum ada kelas'), findsOneWidget);
  });

  testWidgets('can add class from homepage form', (WidgetTester tester) async {
    final repository = AttendanceRepository();

    await tester.pumpWidget(AttendanceApp(repository: repository));

    await tester.tap(find.text('Tambah\nKelas'));
    await tester.pump();

    expect(find.text('Kelas Baru'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), '1a');
    await tester.enterText(find.byType(TextField).at(1), 'Semester genap');
    await tester.pump();

    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pump();

    expect(find.text('1a'), findsOneWidget);
    expect(find.text('Semester genap'), findsOneWidget);
    expect(find.text('Belum ada kelas'), findsNothing);
  });
}
