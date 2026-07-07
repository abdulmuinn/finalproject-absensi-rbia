import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/student.dart';
import 'attendance_session_page.dart';

class SubjectDetailPage extends StatefulWidget {
  final Subject subject;
  final List<Student> students;
  final bool isDarkMode;

  const SubjectDetailPage({
    super.key,
    required this.subject,
    required this.students,
    required this.isDarkMode,
  });

  @override
  State<SubjectDetailPage> createState() => _SubjectDetailPageState();
}

class _SubjectDetailPageState extends State<SubjectDetailPage> {
  static const _brandColor = Color(0xFF27B8B1);

  // 1. KOSONGKAN DUMMY DATA (Mulai dari list kosong)
  final List<Map<String, dynamic>> _meetings = [];

  Color get _background => widget.isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
  Color get _surface => widget.isDarkMode ? const Color(0xFF222222) : const Color(0xFFF9FAFB);
  Color get _textColor => widget.isDarkMode ? const Color(0xFFF7F7F7) : const Color(0xFF151515);
  Color get _mutedTextColor => widget.isDarkMode ? const Color(0xFFA5A5B3) : const Color(0xFF5E6673);
  Color get _dividerColor => widget.isDarkMode ? const Color(0xFF333333) : const Color(0xFFEAECEF);

  void _showAddMeetingForm() {
    final topicController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: _background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mulai Pertemuan Baru', style: TextStyle(color: _textColor, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: topicController,
              style: TextStyle(color: _textColor),
              decoration: InputDecoration(
                hintText: 'Topik Pertemuan (Cth: Pengenalan Flutter)',
                hintStyle: TextStyle(color: _mutedTextColor),
                filled: true,
                fillColor: _surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _dividerColor)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _dividerColor)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _brandColor)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: _brandColor),
                // 2. JADIKAN ASYNC
                onPressed: () async {
                  if (topicController.text.isNotEmpty) {
                    final topic = topicController.text;
                    Navigator.pop(context); // Tutup dialog

                    // 3. TUNGGU HASIL DARI HALAMAN ABSENSI
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AttendanceSessionPage(
                          subject: widget.subject,
                          students: widget.students,
                          topic: topic,
                          date: 'Baru saja', // Tanggal real-nya nanti bisa pakai DateTime.now()
                          isDarkMode: widget.isDarkMode,
                        ),
                      ),
                    );

                    // 4. JIKA KEMBALI BAWA RESULT "TRUE" (Artinya Selesai diklik)
                    if (result == true) {
                      setState(() {
                        // Tambahkan ke riwayat pertemuan
                        _meetings.insert(0, { // insert(0, ...) biar yang terbaru di atas
                          'topic': topic,
                          'date': 'Baru saja',
                          'isFinished': true
                        });
                      });
                    }
                  }
                },
                child: const Text('Simpan & Mulai', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
          ],
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
        title: Text('Kembali ke Kelas', style: TextStyle(color: _mutedTextColor, fontSize: 16)),
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _dividerColor),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: _background, shape: BoxShape.circle),
                    child: const Icon(Icons.menu_book, color: _brandColor, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.subject.name, style: TextStyle(color: _textColor, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, color: _brandColor, size: 14),
                            const SizedBox(width: 6),
                            Text(widget.subject.schedule, style: TextStyle(color: _brandColor, fontSize: 14, fontWeight: FontWeight.w500)),
                            const SizedBox(width: 12),
                            Icon(Icons.notifications_off_outlined, color: _mutedTextColor, size: 14),
                            const SizedBox(width: 6),
                            Text('Pengingat off', style: TextStyle(color: _mutedTextColor, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.settings_outlined, color: _mutedTextColor),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Icon(Icons.calendar_month_outlined, color: _brandColor),
                const SizedBox(width: 12),
                Expanded(child: Text('Riwayat\nPertemuan', style: TextStyle(color: _textColor, fontSize: 20, fontWeight: FontWeight.bold, height: 1.2))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(12)),
                  child: Text('${_meetings.length}', style: TextStyle(color: _mutedTextColor, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                FilledButton.icon(
                  onPressed: _showAddMeetingForm,
                  style: FilledButton.styleFrom(
                    backgroundColor: _brandColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Mulai\nPertemuan', textAlign: TextAlign.center, style: TextStyle(height: 1.1)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // KONDISI JIKA KOSONG / ADA ISINYA
            if (_meetings.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text('Belum ada pertemuan', style: TextStyle(color: _mutedTextColor)),
                ),
              )
            else
              ..._meetings.map((meeting) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: _dividerColor)),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: _brandColor, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(meeting['topic'], style: TextStyle(color: _textColor, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(meeting['date'], style: TextStyle(color: _mutedTextColor, fontSize: 14)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: _brandColor.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                      child: const Text('Selesai', style: TextStyle(color: _brandColor, fontWeight: FontWeight.w600)),
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