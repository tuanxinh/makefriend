


import 'package:flutter/material.dart';

class ProfileEvent {}

class ProfileEdit extends ProfileEvent{
  String hoten;
  String emailController;
  String ngaySinhController;
  String gioiTinhController;
  String truongController;
  String nganhHocController;
  String lopController;
  String kyNangController;
  String soThichController;
  String moTaController;
  String ngayTaoController;
  BuildContext context;
  ProfileEdit({required this.emailController,
  required this.gioiTinhController, required this.kyNangController, required this.lopController
  ,required this.moTaController, required this.nganhHocController,
  required this.ngaySinhController, required this.ngayTaoController, required this.soThichController,
  required this.truongController, required this.hoten, required this.context});
}

class ProfileLoad extends ProfileEvent{

}