
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/nguoi_dung.dart';
import '../services/user_service.dart';
import '../widgets/common_widgets.dart';

class UserFormPage extends StatefulWidget {
  final NguoiDung? user;

  const UserFormPage({super.key, this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _key = GlobalKey<FormState>();

  late final _email =
  TextEditingController(text: widget.user?.email);
  late final _pass =
  TextEditingController(text: widget.user?.matkhau);
  late final _ten =
  TextEditingController(text: widget.user?.hoten);

  late String _anh = widget.user?.hinhanh ?? '';

  bool _an = true;
  bool _luu = false;

  static const Color primary = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF7C3AED);

  // ================= CHỌN ẢNH =================

  Future<void> _chonAnh(ImageSource nguon) async {
    try {
      final f = await ImagePicker().pickImage(
        source: nguon,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 75,
      );

      if (f == null) return;

      final bytes = await f.readAsBytes();

      if (mounted) {
        setState(() => _anh = base64Encode(bytes));
      }
    } catch (e) {
      if (mounted) {
        thongBao(context, 'Không thể chọn ảnh: $e');
      }
    }
  }

  void _menuAnh() {
    if (kIsWeb) {
      _chonAnh(ImageSource.gallery);
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ảnh đại diện',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              _itemAnh(
                Icons.photo_library_rounded,
                'Chọn từ thư viện',
                'Chọn ảnh có sẵn trên thiết bị',
                    () {
                  Navigator.pop(context);
                  _chonAnh(ImageSource.gallery);
                },
              ),
              _itemAnh(
                Icons.camera_alt_rounded,
                'Chụp ảnh',
                'Sử dụng camera thiết bị',
                    () {
                  Navigator.pop(context);
                  _chonAnh(ImageSource.camera);
                },
              ),
              if (_anh.isNotEmpty)
                _itemAnh(
                  Icons.delete_outline_rounded,
                  'Xóa ảnh',
                  'Đưa avatar về mặc định',
                      () {
                    Navigator.pop(context);
                    setState(() => _anh = '');
                  },
                  color: Colors.red,
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemAnh(
      IconData icon,
      String title,
      String subtitle,
      VoidCallback onTap, {
        Color color = primary,
      }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool password = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: password && _an,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primary),
        suffixIcon: password
            ? IconButton(
          onPressed: () {
            setState(() => _an = !_an);
          },
          icon: Icon(
            _an
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
            color: Colors.grey,
          ),
        )
            : null,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFE2E8F0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // ================= LƯU DỮ LIỆU =================

  Future<void> _luuLai() async {
    if (_luu) return;

    if (!_key.currentState!.validate()) return;

    setState(() => _luu = true);

    try {
      final email = _email.text.trim();

      if (await UserService.emailTonTai(
        email,
        boQuaId: widget.user?.id,
      )) {
        if (mounted) {
          thongBao(context, 'Email đã tồn tại');
        }
        return;
      }

      final u = NguoiDung(
        id: widget.user?.id ?? '',
        email: email,
        matkhau: _pass.text,
        hoten: _ten.text.trim(),
        hinhanh: _anh,
      );

      if (widget.user == null) {
        await UserService.them(u);
      } else {
        await UserService.sua(u);
      }

      if (mounted) {
        thongBao(
          context,
          widget.user == null
              ? 'Đã thêm người dùng'
              : 'Đã cập nhật người dùng',
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        thongBao(context, 'Lỗi: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _luu = false);
      }
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    _ten.dispose();
    super.dispose();
  }

  // ================= GIAO DIỆN =================

  @override
  Widget build(BuildContext context) {
    final them = widget.user == null;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: Text(
          them ? 'Thêm người dùng' : 'Cập nhật người dùng',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
        // Background gradient

          Container(
            height: 190,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(45),
                bottomRight: Radius.circular(45),
              ),
            ),
          ),


          SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  children: [
                    // Avatar
                    GestureDetector(
                      onTap: _menuAnh,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: SizedBox(
                                width: 110,
                                height: 110,
                                child: _anh.isNotEmpty
                                    ? Image.memory(
                                  base64Decode(_anh),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _avatarMacDinh(),
                                )
                                    : _avatarMacDinh(),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [primary, secondary],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      them ? 'Tạo hồ sơ mới' : 'Chỉnh sửa hồ sơ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Nhấn vào ảnh để thay đổi avatar',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Form card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _key,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.person_outline_rounded,
                                  color: primary,
                                  size: 25,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Thông tin người dùng',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 25),

                            _input(
                              controller: _ten,
                              label: 'Họ và tên',
                              icon: Icons.person_outline_rounded,
                              validator: (v) =>
                              v == null || v.trim().isEmpty
                                  ? 'Vui lòng nhập họ tên'
                                  : null,
                            ),

                            const SizedBox(height: 18),

                            _input(
                              controller: _email,
                              label: 'Email',
                              icon: Icons.email_outlined,
                              keyboardType:
                              TextInputType.emailAddress,
                              validator: (v) {
                                final s = v?.trim() ?? '';

                                if (s.isEmpty) {
                                  return 'Vui lòng nhập email';
                                }

                                if (!RegExp(
                                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                ).hasMatch(s)) {
                                  return 'Email không hợp lệ';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 18),

                            _input(
                              controller: _pass,
                              label: 'Mật khẩu',
                              icon: Icons.lock_outline_rounded,
                              password: true,
                              validator: (v) =>
                              v == null || v.length < 6
                                  ? 'Mật khẩu tối thiểu 6 ký tự'
                                  : null,
                            ),

                            const SizedBox(height: 28),

                            // Save button
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [primary, secondary],
                                  ),
                                  borderRadius:
                                  BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primary.withOpacity(0.25),
                                      blurRadius: 14,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  onPressed:
                                  _luu ? null : _luuLai,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    disabledBackgroundColor:
                                    Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(16),
                                    ),
                                  ),
                                  icon: _luu
                                      ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child:
                                    CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                      : const Icon(
                                    Icons.save_rounded,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    _luu
                                        ? 'ĐANG LƯU...'
                                        : them
                                        ? 'THÊM NGƯỜI DÙNG'
                                        : 'LƯU THAY ĐỔI',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.7,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: OutlinedButton(
                                onPressed: _luu
                                    ? null
                                    : () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                  const Color(0xFF64748B),
                                  side: const BorderSide(
                                    color: Color(0xFFE2E8F0),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  'Hủy bỏ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified_user_rounded,
                          size: 15,
                          color: Color(0xFF64748B),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'ADMIN PORTAL • USER MANAGEMENT',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }

  Widget _avatarMacDinh() {
    return Container(
      color: const Color(0xFFEEF2FF),
      child: const Icon(
        Icons.person_rounded,
        size: 65,
        color: primary,
      ),
    );
  }
}
