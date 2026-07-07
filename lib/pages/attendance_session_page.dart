import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/student.dart';

class AttendanceSessionPage extends StatefulWidget {
  final Subject subject;
  final List<Student> students;
  final String topic;
  final String date;
  final bool isDarkMode;

  const AttendanceSessionPage({
    super.key,
    required this.subject,
    required this.students,
    required this.topic,
    required this.date,
    required this.isDarkMode,
  });

  @override
  State<AttendanceSessionPage> createState() => _AttendanceSessionPageState();
}

class _AttendanceSessionPageState extends State<AttendanceSessionPage> {
  static const _brandColor = Color(0xFF27B8B1);
  static const _dangerColor = Color(0xFFE86B73);

  final Map<String, String> _attendanceState = {};

  Color get _background => widget.isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
  Color get _surface => widget.isDarkMode ? const Color(0xFF222222) : const Color(0xFFF9FAFB);
  Color get _textColor => widget.isDarkMode ? const Color(0xFFF7F7F7) : const Color(0xFF151515);
  Color get _mutedTextColor => widget.isDarkMode ? const Color(0xFFA5A5B3) : const Color(0xFF5E6673);
  Color get _dividerColor => widget.isDarkMode ? const Color(0xFF333333) : const Color(0xFFEAECEF);

  void _markAllPresent() {
    setState(() {
      for (var student in widget.students) {
        _attendanceState[student.id] = 'Hadir';
      }
    });
  }

  Widget _buildStatusChip(String studentId, String status, Color activeColor) {
    final isSelected = _attendanceState[studentId] == status;
    return GestureDetector(
      onTap: () => setState(() => _attendanceState[studentId] = status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: isSelected ? Colors.white : _mutedTextColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _mutedTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Kembali', style: TextStyle(color: _mutedTextColor, fontSize: 16)),
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: _dividerColor, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.topic, style: TextStyle(color: _textColor, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('${widget.subject.name} · ${widget.date}', style: TextStyle(color: _mutedTextColor, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(color: _brandColor, borderRadius: BorderRadius.circular(3)),
                  ),
                ),
                const SizedBox(width: 12),
                Text('${widget.students.length}/${widget.students.length}', style: TextStyle(color: _mutedTextColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                FilledButton.icon(
                  onPressed: _markAllPresent,
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFF28C76F)),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Hadir Semua'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    // Logika simpan sementara tanpa menutup halaman bisa ditaruh di sini
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tersimpan!')));
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _textColor,
                    side: BorderSide(color: _dividerColor),
                  ),
                  icon: const Icon(Icons.save_outlined, size: 18),
                  label: const Text('Simpan'),
                ),
                const Spacer(),
                FilledButton.icon(
                  // PERBAIKAN DI SINI: Return "true" saat tombol Selesai dipencet
                  onPressed: () => Navigator.pop(context, true),
                  style: FilledButton.styleFrom(backgroundColor: _brandColor),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Selesai'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            ...widget.students.map((student) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: _brandColor.withOpacity(0.2),
                        child: Icon(Icons.person, color: _brandColor, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Text(student.name, style: TextStyle(color: _textColor, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: _background,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatusChip(student.id, 'Hadir', const Color(0xFF28C76F)),
                        _buildStatusChip(student.id, 'Sakit', const Color(0xFFFF9F43)),
                        _buildStatusChip(student.id, 'Izin', const Color(0xFF00CFE8)),
                        _buildStatusChip(student.id, 'Alpa', _dangerColor),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}