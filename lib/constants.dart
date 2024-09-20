import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const String kPageName = 'dadda';
const TextDirection kText = TextDirection.rtl;
const List<String> kDayList = [
  'الجمعة',
  'السبت',
  'الاحد',
  'الاثنين',
  'الثلاثاء',
  'الاربعاء',
  'الخميس',
];
const List<String> kGradeList = [
  'الاول الاعدادي',
  'الثاني الاعدادي',
  'الثالث الاعدادي',
  'الاول الثانوي',
  'الثالي الثانوي',
  'الثالث الثانوي',
];
FirebaseFirestore kFs = FirebaseFirestore.instance;
List<Color> kColor = const [
  Color(0xff89a3d5),
  Color(0xffb1bacf),
  Color(0xffeebe35),
  Color(0xffdde1ed),
  Color(0xffB0D2DB),
  Color(0xff6b7ea4),
  Color(0xffffb7b0),
  Color(0xffe8dac0),
  Color(0xfff36870),
];
final List<String> kImageAssetList = [
  'assets/image/1sec.png',
  'assets/image/2sec.png',
  'assets/image/3sec.png',
  'assets/image/first p.png',
  'assets/image/secp.png',
  'assets/image/3p.png',
];
