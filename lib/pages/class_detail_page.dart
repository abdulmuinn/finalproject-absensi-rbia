import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/student.dart';
import 'subject_detail_page.dart';

class ClassDetailPage extends StatefulWidget {
  final String className;
  final bool isDarkMode;

  const ClassDetailPage({
    super.key,
    required this.className,
    required this.isDarkMode,
  });

  @override
  State<ClassDetailPage> createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage> {
  static const _brandColor = Color(0xFF27B8B1);

  final List<Subject> _subjects = [];
  final List<Student> _students = [];

  Color get _background => widget.isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
  Color get _surface => widget.isDarkMode ? const Color(0xFF222222) : const Color(0xFFF9FAFB);
  Color get _textColor => widget.isDarkMode ? const Color(0xFFF7F7F7) : const Color(0xFF151515);
  Color get _mutedTextColor => widget.isDarkMode ? const Color(0xFFA5A5B3) : const Color(0xFF5E6673);
  Color get _dividerColor => widget.isDarkMode ? const Color(0xFF333333) : const Color(0xFFEAECEF);

  void _showAddSubjectForm() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final dayController = TextEditingController();
    final timeController = TextEditingController();

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
            Text('Tambah Mata Pelajaran', style: TextStyle(color: _textColor, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTextField(nameController, 'Nama Mata Pelajaran', false),
            _buildTextField(descController, 'Deskripsi (Opsional)', false),
            Row(
              children: [
                Expanded(child: _buildTextField(dayController, 'Hari (Cth: Senin)', false)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField(timeController, 'Jam (Cth: 08:00)', false)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: _brandColor),
                onPressed: () {
                  if (nameController.text.isNotEmpty && dayController.text.isNotEmpty && timeController.text.isNotEmpty) {
                    setState(() {
                      _subjects.add(Subject(
                        id: DateTime.now().toString(),
                        name: nameController.text,
                        description: descController.text.isEmpty ? null : descController.text,
                        schedule: '${dayController.text}, ${timeController.text}',
                      ));
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Simpan Mata Pelajaran', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showAddStudentForm() {
    final nameController = TextEditingController();
    final nisController = TextEditingController();
    final contactController = TextEditingController();

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
            Text('Tambah Siswa', style: TextStyle(color: _textColor, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTextField(nameController, 'Nama Lengkap', false),
            _buildTextField(nisController, 'NIS (Opsional)', false),
            _buildTextField(contactController, 'Kontak Ortu (Opsional)', false),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: _brandColor),
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    setState(() {
                      _students.add(Student(
                        id: DateTime.now().toString(),
                        name: nameController.text,
                        nis: nisController.text.isEmpty ? null : nisController.text,
                        parentContact: contactController.text.isEmpty ? null : contactController.text,
                      ));
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Simpan Siswa', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, bool isNumber) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: TextStyle(color: _textColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: _mutedTextColor),
          filled: true,
          fillColor: _surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: _dividerColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: _dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: _brandColor),
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
        leadingWidth: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.school_outlined, color: _brandColor, size: 28),
              const SizedBox(width: 12),
              Text(
                'Absensi RBIA - ${widget.className}',
                style: TextStyle(color: _textColor, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
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
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: _mutedTextColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Kembali ke Daftar Kelas',
                    style: TextStyle(color: _mutedTextColor, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            _buildSectionHeader(
              icon: Icons.menu_book_rounded,
              title: 'Mata Pelajaran',
              count: _subjects.length,
              onAdd: _showAddSubjectForm,
            ),
            const SizedBox(height: 16),
            if (_subjects.isEmpty)
              Text('Belum ada mapel.', style: TextStyle(color: _mutedTextColor))
            else
              ..._subjects.map((sub) => _buildSubjectCard(sub)),

            const SizedBox(height: 40),

            _buildSectionHeader(
              icon: Icons.people_outline_rounded,
              title: 'Siswa',
              count: _students.length,
              onAdd: _showAddStudentForm,
            ),
            const SizedBox(height: 16),
            if (_students.isEmpty)
              Text('Belum ada siswa.', style: TextStyle(color: _mutedTextColor))
            else
              _buildStudentTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title, required int count, required VoidCallback onAdd}) {
    return Row(
      children: [
        Icon(icon, color: _brandColor, size: 24),
        const SizedBox(width: 12),
        Text(title, style: TextStyle(color: _textColor, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(12)),
          child: Text('$count', style: TextStyle(color: _mutedTextColor, fontWeight: FontWeight.bold)),
        ),
        const Spacer(),
        FilledButton.icon(
          onPressed: onAdd,
          style: FilledButton.styleFrom(
            backgroundColor: _brandColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Tambah'),
        ),
      ],
    );
  }

  // DI SINI LETAK PERBAIKANNYA
  Widget _buildSubjectCard(Subject subject) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubjectDetailPage(
              subject: subject,
              students: _students, // Passing list siswa ke halaman detail
              isDarkMode: widget.isDarkMode,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _dividerColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: _background, shape: BoxShape.circle),
              child: const Icon(Icons.menu_book, color: _brandColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject.name, style: TextStyle(color: _textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, color: _brandColor, size: 14),
                      const SizedBox(width: 6),
                      Text(subject.schedule, style: TextStyle(color: _brandColor, fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: _mutedTextColor),
              onPressed: () => setState(() => _subjects.removeWhere((s) => s.id == subject.id)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStudentTable() {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _dividerColor),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('Nama', style: TextStyle(color: _textColor, fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('NIS', style: TextStyle(color: _textColor, fontWeight: FontWeight.bold))),
                const SizedBox(width: 40),
              ],
            ),
          ),
          Divider(color: _dividerColor, height: 1),
          ..._students.map((student) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: _brandColor.withOpacity(0.2),
                        child: Icon(Icons.person, size: 18, color: _brandColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(student.name, style: TextStyle(color: _textColor, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
                Expanded(flex: 1, child: Text(student.nis ?? '-', style: TextStyle(color: _mutedTextColor))),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: _mutedTextColor, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => setState(() => _students.removeWhere((s) => s.id == student.id)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}