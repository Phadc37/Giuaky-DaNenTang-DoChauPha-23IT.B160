import 'package:flutter/material.dart';

import '../services/user_service.dart';
import '../widgets/common_widgets.dart';
import 'user_list_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController(text: UserService.adminEmail);
  final _pass = TextEditingController(text: UserService.adminPass);

  bool _an = true;
  bool _dangXuLy = false;

  static const Color primary = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF7C3AED);

  Future<void> _login() async {
    if (_dangXuLy) return;

    setState(() => _dangXuLy = true);

    try {
      final ok = await UserService.dangNhap(
        _email.text.trim(),
        _pass.text,
      );

      if (!mounted) return;

      if (ok) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const UserListPage(),
          ),
        );
      } else {
        thongBao(context, 'Sai email hoặc mật khẩu');
      }
    } catch (e) {
      if (mounted) thongBao(context, 'Lỗi: $e');
    }

    if (mounted) {
      setState(() => _dangXuLy = false);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool password = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: password && _an,
      keyboardType: password
          ? TextInputType.text
          : TextInputType.emailAddress,
      onSubmitted: password ? (_) => _login() : null,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: primary),
        suffixIcon: password
            ? IconButton(
          onPressed: () {
            setState(() => _an = !_an);
          },
          icon: Icon(
            _an ? Icons.visibility_off : Icons.visibility,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Stack(
        children: [
          // Background gradient
          Container(
            height: MediaQuery.of(context).size.height * 0.48,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60),
              ),
            ),
          ),

          // Decorative circles
          Positioned(
            top: -70,
            right: -50,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            top: 180,
            left: -60,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),

          // Login content
          SafeArea(
            child: Center(
              child: ScrollConfiguration(
    behavior: const MaterialScrollBehavior().copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Logo
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: const Icon(
                            Icons.admin_panel_settings_rounded,
                            size: 52,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'Hệ Thống Quản Lí',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Hệ thống quản lý người dùng',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 36),

                        // Login card
                        Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 35,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Xin chào 👋',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),

                              const SizedBox(height: 8),

                              const Text(
                                'Đăng nhập để tiếp tục quản lý hệ thống.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                ),
                              ),

                              const SizedBox(height: 30),

                              const Text(
                                'EMAIL',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                  color: Color(0xFF475569),
                                ),
                              ),

                              const SizedBox(height: 10),

                              _input(
                                controller: _email,
                                label: 'Nhập email của bạn',
                                icon: Icons.email_outlined,
                              ),

                              const SizedBox(height: 22),

                              const Text(
                                'MẬT KHẨU',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                  color: Color(0xFF475569),
                                ),
                              ),

                              const SizedBox(height: 10),

                              _input(
                                controller: _pass,
                                label: 'Nhập mật khẩu',
                                icon: Icons.lock_outline_rounded,
                                password: true,
                              ),

                              const SizedBox(height: 30),

                              // Login button
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [primary, secondary],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primary.withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed:
                                    _dangXuLy ? null : _login,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      disabledBackgroundColor:
                                      Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: _dangXuLy
                                        ? const SizedBox(
                                      width: 23,
                                      height: 23,
                                      child:
                                      CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                        : const Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'ĐĂNG NHẬP',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight:
                                            FontWeight.w800,
                                            letterSpacing: 1,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shield_rounded,
                                    size: 16,
                                    color: Color(0xFF10B981),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Đăng nhập bảo mật dành cho quản trị viên',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        Text(
                          '© 2026 ADMIN PORTAL • ALL RIGHTS RESERVED',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 10,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}