import 'package:flutter/material.dart';
import 'class_detail_page.dart'; // Import halaman detail kelas
import 'materials_page.dart'; // Import halaman catatan materi

/// Halaman utama aplikasi dengan tampilan daftar kelas.
class AttendancePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const AttendancePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  static const _brandColor = Color(0xFF27B8B1);
  static const _lightText = Color(0xFF151515);
  static const _darkText = Color(0xFFF7F7F7);
  static const _lightMutedText = Color(0xFF5E6673);
  static const _darkMutedText = Color(0xFFA5A5B3);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _classNameController = TextEditingController();
  final _classDescriptionController = TextEditingController();
  final _classNameFocusNode = FocusNode();
  final _classDescriptionFocusNode = FocusNode();
  final List<_ClassRoom> _classes = [];
  var _isClassFormVisible = false;
  int? _editingClassId;
  var _nextClassId = 1;

  bool get _canSaveClass => _classNameController.text.trim().isNotEmpty;

  Color get _background =>
      widget.isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;

  Color get _surface =>
      widget.isDarkMode ? const Color(0xFF222222) : const Color(0xFFFFFFFF);

  Color get _textColor => widget.isDarkMode ? _darkText : _lightText;

  Color get _mutedTextColor =>
      widget.isDarkMode ? _darkMutedText : _lightMutedText;

  Color get _dividerColor =>
      widget.isDarkMode ? const Color(0xFF333333) : const Color(0xFFEAECEF);

  Color get _inputFillColor =>
      widget.isDarkMode ? const Color(0xFF191919) : const Color(0xFFF9FAFB);

  Color get _inputBorderColor =>
      widget.isDarkMode ? const Color(0xFF3A3A3A) : const Color(0xFFDDE3EA);

  @override
  void initState() {
    super.initState();
    _classNameController.addListener(_refreshFormActions);
  }

  @override
  void dispose() {
    _classNameController
      ..removeListener(_refreshFormActions)
      ..dispose();
    _classDescriptionController.dispose();
    _classNameFocusNode.dispose();
    _classDescriptionFocusNode.dispose();
    super.dispose();
  }

  void _refreshFormActions() {
    if (_isClassFormVisible) {
      setState(() {});
    }
  }

  void _showAddClassForm() {
    setState(() {
      _editingClassId = null;
      _isClassFormVisible = true;
    });
    _classNameController.clear();
    _classDescriptionController.clear();
    _focusClassNameField();
  }

  void _showEditClassForm(_ClassRoom classRoom) {
    setState(() {
      _editingClassId = classRoom.id;
      _isClassFormVisible = true;
    });
    _classNameController.text = classRoom.name;
    _classDescriptionController.text = classRoom.description;
    _focusClassNameField();
  }

  void _focusClassNameField() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _classNameFocusNode.requestFocus();
      }
    });
  }

  void _cancelClassForm() {
    setState(() {
      _editingClassId = null;
      _isClassFormVisible = false;
    });
    _classNameController.clear();
    _classDescriptionController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _saveClass() {
    final name = _classNameController.text.trim();
    final description = _classDescriptionController.text.trim();

    if (name.isEmpty) {
      _classNameFocusNode.requestFocus();
      return;
    }

    setState(() {
      final editingClassId = _editingClassId;
      if (editingClassId == null) {
        _classes.add(
          _ClassRoom(id: _nextClassId++, name: name, description: description),
        );
      } else {
        final index = _classes.indexWhere(
              (classRoom) => classRoom.id == editingClassId,
        );
        if (index != -1) {
          _classes[index] = _classes[index].copyWith(
            name: name,
            description: description,
          );
        }
      }

      _editingClassId = null;
      _isClassFormVisible = false;
    });

    _classNameController.clear();
    _classDescriptionController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _deleteClass(_ClassRoom classRoom) {
    setState(() {
      _classes.removeWhere((item) => item.id == classRoom.id);
      if (_editingClassId == classRoom.id) {
        _editingClassId = null;
        _isClassFormVisible = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _background,
      drawerScrimColor: Colors.black.withValues(alpha: 0.58),
      drawer: _HomeDrawer(
        isDarkMode: widget.isDarkMode,
        onClose: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final minHeight = constraints.maxHeight > 64
                      ? constraints.maxHeight - 64
                      : 0.0;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 36, 24, 28),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: minHeight),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildPageTitle(),
                          if (_isClassFormVisible) ...[
                            const SizedBox(height: 42),
                            _buildClassForm(),
                          ],
                          if (_classes.isEmpty)
                            _buildEmptyState()
                          else
                            _buildClassList(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: _background,
        border: Border(bottom: BorderSide(color: _dividerColor)),
      ),
      child: Row(
        children: [
          const _AppLogo(),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Absensi RBIA',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _textColor,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            tooltip: widget.isDarkMode ? 'Mode terang' : 'Mode gelap',
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.isDarkMode
                  ? Icons.wb_sunny_outlined
                  : Icons.dark_mode_outlined,
              color: _mutedTextColor,
              size: 29,
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            tooltip: 'Buka menu',
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: Icon(Icons.menu_rounded, color: _mutedTextColor, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildPageTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kelas',
                style: TextStyle(
                  color: _textColor,
                  fontSize: 34,
                  height: 1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Kelola kelas dan siswa\nAnda',
                style: TextStyle(
                  color: _mutedTextColor,
                  fontSize: 20,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 18),
        _PrimaryActionButton(
          width: 152,
          height: 78,
          label: 'Tambah\nKelas',
          onPressed: _showAddClassForm,
        ),
      ],
    );
  }

  Widget _buildClassForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _surface,
        border: Border.all(color: _dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _editingClassId == null ? 'Kelas Baru' : 'Edit Kelas',
            style: TextStyle(
              color: _textColor,
              fontSize: 23,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 26),
          _buildFieldLabel('Nama Kelas'),
          const SizedBox(height: 12),
          TextField(
            controller: _classNameController,
            focusNode: _classNameFocusNode,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            style: TextStyle(
              color: _textColor,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
            decoration: _inputDecoration('Contoh: Kelas 4A'),
            onSubmitted: (_) => _classDescriptionFocusNode.requestFocus(),
          ),
          const SizedBox(height: 24),
          _buildFieldLabel('Deskripsi ', mutedText: '(opsional)'),
          const SizedBox(height: 12),
          TextField(
            controller: _classDescriptionController,
            focusNode: _classDescriptionFocusNode,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            style: TextStyle(
              color: _textColor,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
            decoration: _inputDecoration('Contoh: Semester genap 2024'),
            onSubmitted: (_) => _saveClass(),
          ),
          const SizedBox(height: 26),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _FormActionButton(
                icon: Icons.save_outlined,
                label: 'Simpan',
                isPrimary: true,
                isEnabled: _canSaveClass,
                onPressed: _saveClass,
              ),
              _FormActionButton(
                icon: Icons.close_rounded,
                label: 'Batal',
                onPressed: _cancelClassForm,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String text, {String? mutedText}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: _textColor,
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
        children: [
          if (mutedText != null)
            TextSpan(
              text: mutedText,
              style: TextStyle(
                color: _mutedTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: _mutedTextColor.withValues(alpha: 0.86),
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: _inputFillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _inputBorderColor, width: 1.2),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: _brandColor, width: 2.6),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.only(top: _isClassFormVisible ? 112 : 168),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: widget.isDarkMode
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFF3F4F7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school_outlined,
                color: _mutedTextColor,
                size: 45,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Belum ada kelas',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _textColor,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Mulai dengan membuat kelas pertama Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _mutedTextColor,
                fontSize: 19,
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 26),
            _PrimaryActionButton(
              width: 238,
              height: 64,
              label: 'Tambah Kelas',
              onPressed: _showAddClassForm,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassList() {
    return Padding(
      padding: EdgeInsets.only(top: _isClassFormVisible ? 24 : 46, bottom: 24),
      child: Column(
        children: [
          for (final classRoom in _classes) ...[
            _ClassRoomCard(
              classRoom: classRoom,
              textColor: _textColor,
              mutedTextColor: _mutedTextColor,
              surfaceColor: _surface,
              dividerColor: _dividerColor,
              brandColor: _brandColor,
              onEdit: () => _showEditClassForm(classRoom),
              onDelete: () => _deleteClass(classRoom),
            ),
            if (classRoom != _classes.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _FormActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final bool isEnabled;
  final VoidCallback onPressed;

  const _FormActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8);

    if (isPrimary) {
      return SizedBox(
        width: 138,
        height: 58,
        child: FilledButton.icon(
          onPressed: isEnabled ? onPressed : null,
          style: FilledButton.styleFrom(
            backgroundColor: _AttendancePageState._brandColor,
            disabledBackgroundColor: _AttendancePageState._brandColor
                .withValues(alpha: 0.58),
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white.withValues(alpha: 0.62),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          icon: Icon(icon, size: 24),
          label: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      );
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 120,
      height: 58,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: isDarkMode
              ? _AttendancePageState._darkText
              : _AttendancePageState._lightText,
          side: BorderSide(
            color: isDarkMode
                ? const Color(0xFF3B3B3B)
                : const Color(0xFFDCE1E7),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        icon: Icon(icon, size: 24),
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  final double width;
  final double height;
  final String label;
  final VoidCallback onPressed;

  const _PrimaryActionButton({
    required this.width,
    required this.height,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: _AttendancePageState._brandColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, size: 24),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClassRoomCard extends StatelessWidget {
  final _ClassRoom classRoom;
  final Color textColor;
  final Color mutedTextColor;
  final Color surfaceColor;
  final Color dividerColor;
  final Color brandColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ClassRoomCard({
    required this.classRoom,
    required this.textColor,
    required this.mutedTextColor,
    required this.surfaceColor,
    required this.dividerColor,
    required this.brandColor,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Menggunakan Material agar efek ripple (animasi klik) berfungsi dan terlihat
    return Material(
      color: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: dividerColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          // Navigasi ke ClassDetailPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClassDetailPage(
                className: classRoom.name,
                isDarkMode: isDarkMode,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 17, 16, 17),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: brandColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.school_outlined, color: brandColor, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      classRoom.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (classRoom.description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        classRoom.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: mutedTextColor,
                          fontSize: 17,
                          height: 1.25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Edit kelas',
                onPressed: onEdit,
                icon: Icon(Icons.edit_outlined, color: mutedTextColor, size: 27),
              ),
              IconButton(
                tooltip: 'Hapus kelas',
                onPressed: onDelete,
                icon: Icon(Icons.delete_outline_rounded, color: mutedTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeDrawer extends StatelessWidget {
  static const _brandColor = _AttendancePageState._brandColor;

  final bool isDarkMode;
  final VoidCallback onClose;

  const _HomeDrawer({required this.isDarkMode, required this.onClose});

  Color get _background =>
      isDarkMode ? const Color(0xFF222222) : const Color(0xFFFFFFFF);

  Color get _textColor => isDarkMode
      ? _AttendancePageState._darkText
      : _AttendancePageState._lightText;

  Color get _mutedTextColor => isDarkMode
      ? _AttendancePageState._darkMutedText
      : _AttendancePageState._lightMutedText;

  Color get _dividerColor =>
      isDarkMode ? const Color(0xFF363636) : const Color(0xFFEAECEF);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Drawer(
      width: width * 0.8,
      backgroundColor: _background,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildDrawerHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
                children: [
                  _DrawerItem(
                    icon: Icons.grid_view_rounded,
                    title: 'Kelas',
                    subtitle: 'Kelola kelas & siswa',
                    isActive: true,
                  ),
                  SizedBox(height: 18),
                  _DrawerItem(
                    icon: Icons.menu_book_rounded,
                    title: 'Materi',
                    subtitle: 'Catatan materi pembelajaran',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MaterialsPage(
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 18),
                  _DrawerItem(
                    icon: Icons.calendar_today_outlined,
                    title: 'Jadwal',
                    subtitle: 'Jadwal mengajar',
                  ),
                  SizedBox(height: 18),
                  _DrawerItem(
                    icon: Icons.bar_chart_rounded,
                    title: 'Rekap',
                    subtitle: 'Lihat rekap absensi',
                  ),
                  SizedBox(height: 18),
                  _DrawerItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Profil',
                    subtitle: 'Pengaturan akun',
                  ),
                  SizedBox(height: 18),
                  _DrawerItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Panduan',
                    subtitle: 'Cara menggunakan',
                  ),
                ],
              ),
            ),
            _buildAccountFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _dividerColor)),
      ),
      child: Row(
        children: [
          const _AppLogo(),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Absensi RBIA',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _textColor,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Tutup menu',
            onPressed: onClose,
            icon: Icon(Icons.close_rounded, color: _textColor, size: 31),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: _dividerColor)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: _brandColor.withValues(alpha: 0.13),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: _brandColor,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ust.Aa',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'un35316@gmail.com',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _mutedTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Keluar'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFE86B73),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isActive;
  final VoidCallback? onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final homeDrawer = context.findAncestorWidgetOfExactType<_HomeDrawer>();
    final isDarkMode = homeDrawer?.isDarkMode ?? false;
    final textColor = isActive
        ? _AttendancePageState._brandColor
        : isDarkMode
        ? _AttendancePageState._darkMutedText
        : _AttendancePageState._lightMutedText;
    final subtitleColor = isActive
        ? _AttendancePageState._brandColor.withValues(alpha: 0.8)
        : isDarkMode
        ? _AttendancePageState._darkMutedText.withValues(alpha: 0.86)
        : _AttendancePageState._lightMutedText.withValues(alpha: 0.86);
    final activeColor = isDarkMode
        ? const Color(0xFF1E3834)
        : const Color(0xFFE7F7F5);

    final content = Container(
      height: 84,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isActive ? activeColor : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 30),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Bungkus dengan efek ripple hanya saat item dapat ditekan.
    if (onTap == null) return content;

    final handler = onTap!;
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: handler, child: content),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: const BoxDecoration(
        color: _AttendancePageState._brandColor,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.school_outlined, color: Colors.white, size: 31),
    );
  }
}

class _ClassRoom {
  final int id;
  final String name;
  final String description;

  const _ClassRoom({
    required this.id,
    required this.name,
    required this.description,
  });

  _ClassRoom copyWith({String? name, String? description}) {
    return _ClassRoom(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}