
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/nguoi_dung.dart';

class UserService {
  static final col =
  FirebaseFirestore.instance.collection('users');

  static const adminEmail = 'admin@gmail.com';
  static const adminPass = '123456';

  static Future<bool> dangNhap(
      String email, String pass) async {
    if (email == adminEmail && pass == adminPass) {
      return true;
    }

    final q = await col
        .where('email', isEqualTo: email)
        .where('matkhau', isEqualTo: pass)
        .limit(1)
        .get();

    return q.docs.isNotEmpty;
  }

  static Future<bool> emailTonTai(
      String email, {String? boQuaId}) async {
    final q = await col
        .where('email', isEqualTo: email)
        .get();

    return q.docs.any((d) => d.id != boQuaId);
  }

  static Future<void> them(NguoiDung u) =>
      col.add(u.toMap());

  static Future<void> sua(NguoiDung u) =>
      col.doc(u.id).update(u.toMap());

  static Future<void> xoa(String id) =>
      col.doc(id).delete();
}
