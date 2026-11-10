
import 'dart:convert';

import 'package:flutter/material.dart';

Widget avatar(String b64, double r) {
  if (b64.isEmpty) {
    return CircleAvatar(
      radius: r,
      child: Icon(Icons.person, size: r),
    );
  }

  return CircleAvatar(
    radius: r,
    backgroundImage: MemoryImage(base64Decode(b64)),
  );
}

void thongBao(BuildContext context, String s) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(s)),
  );
}
