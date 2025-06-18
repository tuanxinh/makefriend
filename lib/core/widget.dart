import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showCustomSnackBar({required BuildContext context,String title = "Notification", required String message, required ContentType contentType}) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

DateTime? parseNgaySinh(String input) {
  try {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.parse(input);
  } catch (e) {
    print('Lỗi khi parse ngày sinh: $e');
    return null;
  }
}

String? convertToLocalDate(DateTime? dateTime) {
  if (dateTime == null) return null;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(dateTime);
}