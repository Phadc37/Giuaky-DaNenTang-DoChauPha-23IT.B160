
import 'package:cloud_firestore/cloud_firestore.dart';

class NguoiDung {
  final String id;
  final String email;
  final String matkhau;
  final String hoten;
  final String hinhanh;

  NguoiDung({
    this.id = '',
    required this.email,
    required this.matkhau,
    required this.hoten,
    required this.hinhanh,
  });

  factory NguoiDung.fromDoc(
      DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? {};

    return NguoiDung(
      id: d.id,
      email: m['email'] ?? '',
      matkhau: m['matkhau'] ?? '',
      hoten: m['hoten'] ?? '',
      hinhanh: m['hinhanh'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    'matkhau': matkhau,
    'hoten': hoten,
    'hinhanh': hinhanh,
  };
}
