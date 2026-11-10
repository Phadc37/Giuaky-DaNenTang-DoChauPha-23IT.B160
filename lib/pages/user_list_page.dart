
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/nguoi_dung.dart';
import '../services/user_service.dart';
import '../widgets/common_widgets.dart';
import 'login_page.dart';
import 'user_form_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  String _tuKhoa = '';
  final _searchController = TextEditingController();

  static const Color primary = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF7C3AED);

  // ================= XÓA NGƯỜI DÙNG =================

  Future<void> _xoa(NguoiDung u) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 10),
            Text('Xóa người dùng'),
          ],
        ),
        content: Text(
          'Bạn có chắc muốn xóa "${u.hoten}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (ok == true) {
      try {
        await UserService.xoa(u.id);

        if (mounted) {
          thongBao(context, 'Đã xóa người dùng');
        }
      } catch (e) {
        if (mounted) {
          thongBao(context, 'Lỗi xóa: $e');
        }
      }
    }
  }

  // ================= CHI TIẾT =================

  void _chiTiet(NguoiDung u) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [primary, secondary],
                  ),
                ),
                child: ClipOval(
                  child: SizedBox(
                    width: 95,
                    height: 95,
                    child: avatar(u.hinhanh, 47),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Text(
                u.hoten,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'NGƯỜI DÙNG',
                  style: TextStyle(
                    color: primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              _info(
                Icons.person_outline_rounded,
                'Họ tên',
                u.hoten,
              ),

              const SizedBox(height: 12),

              _info(
                Icons.email_outlined,
                'Email',
                u.email,
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Đóng'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= FORM =================

  void _moForm([NguoiDung? u]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserFormPage(user: u),
      ),
    );
  }

  // ================= ĐĂNG XUẤT =================

  Future<void> _dangXuat() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Đăng xuất'),
        content: const Text(
          'Bạn có muốn đăng xuất khỏi hệ thống?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Ở lại'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );

    if (ok == true && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
            (route) => false,
      );
    }
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ================= GIAO DIỆN =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),

      // APP BAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.dashboard_rounded, size: 25),
            SizedBox(width: 10),
            Text(
              'QUẢN LÍ NGƯỜI DÙNG',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Đăng xuất',
            icon: const Icon(Icons.logout_rounded),
            onPressed: _dangXuat,
          ),
          const SizedBox(width: 8),
        ],
      ),

      // FAB
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _moForm(),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 5,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text(
          'Thêm người dùng',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: Column(
        children: [
          // HEADER GRADIENT
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 35),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quản lý người dùng 👋',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Theo dõi và quản lý tài khoản hệ thống',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 22),

                // SEARCH
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) {
                      setState(() {
                        _tuKhoa = v.trim().toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Tìm họ tên hoặc email...',
                      hintStyle: const TextStyle(
                        color: Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: primary,
                      ),
                      suffixIcon: _tuKhoa.isNotEmpty
                          ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _tuKhoa = '');
                        },
                        icon: const Icon(Icons.close_rounded),
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LIST
          Expanded(
            child: StreamBuilder<
                QuerySnapshot<Map<String, dynamic>>>(
              stream: UserService.col.snapshots(),
              builder: (context, snap) {
                if (snap.hasError) {
                  return Center(
                    child: Text('Lỗi: ${snap.error}'),
                  );
                }

                if (!snap.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primary,
                    ),
                  );
                }

                final ds = snap.data!.docs
                    .map((d) => NguoiDung.fromDoc(d))
                    .where((u) =>
                u.hoten.toLowerCase().contains(_tuKhoa) ||
                    u.email.toLowerCase().contains(_tuKhoa))
                    .toList();

                if (ds.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_search_rounded,
                          size: 75,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          _tuKhoa.isEmpty
                              ? 'Chưa có người dùng nào'
                              : 'Không tìm thấy người dùng',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    // COUNTER
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20, 20, 20, 10,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.groups_rounded,
                            color: primary,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Danh sách tài khoản',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${ds.length} người',
                              style: const TextStyle(
                                color: primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // USER CARDS
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          16, 5, 16, 100,
                        ),
                        itemCount: ds.length,
                        itemBuilder: (context, i) {
                          final u = ds[i];

                          return Container(
                            margin: const EdgeInsets.only(
                              bottom: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    0.025,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: InkWell(
                              borderRadius:
                              BorderRadius.circular(20),
                              onTap: () => _chiTiet(u),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    // AVATAR
                                    Container(
                                      padding:
                                      const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: primary.withOpacity(
                                            0.25,
                                          ),
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: SizedBox(
                                          width: 52,
                                          height: 52,
                                          child: avatar(
                                            u.hinhanh,
                                            26,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 14),

                                    // INFO
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            u.hoten,
                                            maxLines: 1,
                                            overflow:
                                            TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight:
                                              FontWeight.w800,
                                              color: Color(
                                                0xFF0F172A,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.email_outlined,
                                                size: 14,
                                                color: Color(
                                                  0xFF94A3B8,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  u.email,
                                                  maxLines: 1,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  style:
                                                  const TextStyle(
                                                    fontSize: 12,
                                                    color: Color(
                                                      0xFF64748B,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 7),
                                          Container(
                                            padding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration:
                                            BoxDecoration(
                                              color: const Color(
                                                0xFFECFDF5,
                                              ),
                                              borderRadius:
                                              BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            child: const Text(
                                              'Đang hoạt động',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Color(
                                                  0xFF059669,
                                                ),
                                                fontWeight:
                                                FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // ACTIONS
                                    PopupMenuButton<String>(
                                      icon: const Icon(
                                        Icons.more_vert_rounded,
                                        color: Color(0xFF64748B),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                          16,
                                        ),
                                      ),
                                      onSelected: (value) {
                                        if (value == 'detail') {
                                          _chiTiet(u);
                                        } else if (value ==
                                            'edit') {
                                          _moForm(u);
                                        } else if (value ==
                                            'delete') {
                                          _xoa(u);
                                        }
                                      },
                                      itemBuilder: (_) => [
                                        const PopupMenuItem(
                                          value: 'detail',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .visibility_outlined,
                                                size: 20,
                                              ),
                                              SizedBox(width: 10),
                                              Text('Chi tiết'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .edit_outlined,
                                                size: 20,
                                                color: primary,
                                              ),
                                              SizedBox(width: 10),
                                              Text('Chỉnh sửa'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .delete_outline,
                                                size: 20,
                                                color: Colors.red,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'Xóa',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
