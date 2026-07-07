import 'package:flutter/material.dart';

import '../models/learning_material.dart';

/// Halaman Catatan Materi Pembelajaran.
///
/// Menampilkan daftar catatan materi per kelas yang dibuat pengajar.
/// Data disimpan in-memory pada [_materials] mengikuti pola lokal
/// seperti [ClassDetailPage] (belum terhubung ke repository/BLoC).
class MaterialsPage extends StatefulWidget {
  final bool isDarkMode;

  const MaterialsPage({super.key, required this.isDarkMode});

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  static const _brandColor = Color(0xFF27B8B1);

  final List<LearningMaterial> _materials = [];
  var _nextId = 1;

  /// Data awal untuk demonstrasi.
  @override
  void initState() {
    super.initState();
    _materials.addAll([
      LearningMaterial(
        id: '${_nextId++}',
        className: '1A',
        title: 'Pengenalan Hijaiyah',
        description: 'Mengenal huruf hijaiyah dasar dan cara membacanya.',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      LearningMaterial(
        id: '${_nextId++}',
        className: '1A',
        title: 'Tajwid Dasar',
        description: 'Hukum Nun Mati dan Tanwin.',
        date: DateTime.now(),
      ),
    ]);
  }

  Color get _background => widget.isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
  Color get _surface => widget.isDarkMode ? const Color(0xFF222222) : const Color(0xFFF9FAFB);
  Color get _textColor => widget.isDarkMode ? const Color(0xFFF7F7F7) : const Color(0xFF151515);
  Color get _mutedTextColor => widget.isDarkMode ? const Color(0xFFA5A5B3) : const Color(0xFF5E6673);
  Color get _dividerColor => widget.isDarkMode ? const Color(0xFF333333) : const Color(0xFFEAECEF);

  void _showAddMaterialForm() {
    final classController = TextEditingController();
    final titleController = TextEditingController();
    final descController = TextEditingController();

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
            Text('Tambah Catatan Materi', style: TextStyle(color: _textColor, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTextField(classController, 'Kelas (Cth: 1A)', false),
            _buildTextField(titleController, 'Judul Materi', false),
            _buildTextField(descController, 'Deskripsi (Opsional)', false),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: _brandColor),
                onPressed: () {
                  final className = classController.text.trim();
                  final title = titleController.text.trim();
                  if (className.isNotEmpty && title.isNotEmpty) {
                    setState(() {
                      _materials.add(LearningMaterial(
                        id: '${_nextId++}',
                        className: className,
                        title: title,
                        description: descController.text.isEmpty ? null : descController.text.trim(),
                        date: DateTime.now(),
                      ));
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Simpan Materi', style: TextStyle(fontWeight: FontWeight.bold)),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _dividerColor)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _dividerColor)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _brandColor)),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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
              const Icon(Icons.menu_book_rounded, color: _brandColor, size: 28),
              const SizedBox(width: 12),
              Text(
                'Absensi RBIA - Materi',
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
            // TOMBOL KEMBALI KUSTOM
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: _mutedTextColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Kembali ke Beranda',
                    style: TextStyle(color: _mutedTextColor, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            _buildSectionHeader(
              icon: Icons.menu_book_rounded,
              title: 'Catatan Materi',
              count: _materials.length,
              onAdd: _showAddMaterialForm,
            ),
            const SizedBox(height: 16),
            if (_materials.isEmpty)
              Text('Belum ada catatan materi.', style: TextStyle(color: _mutedTextColor))
            else
              ..._materials.map((m) => _buildMaterialCard(m)),
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

  Widget _buildMaterialCard(LearningMaterial material) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                Text(material.title, style: TextStyle(color: _textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.school_outlined, color: _brandColor, size: 14),
                    const SizedBox(width: 6),
                    Text('Kelas ${material.className}', style: TextStyle(color: _brandColor, fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 12),
                    Icon(Icons.calendar_today_outlined, color: _mutedTextColor, size: 14),
                    const SizedBox(width: 6),
                    Text(_formatDate(material.date), style: TextStyle(color: _mutedTextColor, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
                if (material.description != null && material.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    material.description!,
                    style: TextStyle(color: _mutedTextColor, fontSize: 13, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: _mutedTextColor),
            onPressed: () => setState(() => _materials.removeWhere((m) => m.id == material.id)),
          ),
        ],
      ),
    );
  }
}
