import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_app/constants.dart';
import 'package:intl/intl.dart';

class FirestoreData {
  addData({FirebaseInfoModel? info}) async {
    CollectionReference users = kFs.collection('users');

    await users.doc(info!.name).set({
      'email': info.email,
      'password': info.password,
      'name': info.name,
      'studentNumber': info.studentNumber,
      'parentNumber': info.parentNumber,
      'rool': info.rool,
      'birthday': info.birthday,
      'ubsent': info.ubsent,
    });
  }

  addSubDataStudent(
      {FirebaseInfoModel? info, String? name, String? subject}) async {
    CollectionReference users = kFs.collection('users');
    await users.doc(name).collection('subInfo').doc(subject).set({
      'subject': info!.subject,
      'teacher': info.teacher,
      'day1': info.day1,
      'day2': info.day2,
      'time1': info.time1,
      'time2': info.time2,
      'image': info.imageNetwork,
    });
  }

  addTeacherGropStudentName(
      {FirebaseInfoModel? info, String? name, String? gropName}) async {
    CollectionReference users = kFs.collection('users');
    await users
        .doc(name)
        .collection('gardes')
        .doc(gropName)
        .collection('students')
        .add({
      'name': info!.name,
      'day1': info.day1,
      'day2': info.day2,
      'time1': info.time1,
      'time2': info.time2,
      'subject': info.subject,
    });
  }

  addTeacherGropIfo(
      {FirebaseInfoModel? info, String? name, String? gropName}) async {
    CollectionReference users = kFs.collection('users');
    await users.doc(name).collection('gardes').doc(gropName).set({
      'day1': info!.day1,
      'day2': info.day2,
      'time1': info.time1,
      'time2': info.time2,
      'garde': info.grade,
      'subject': info.subject,
    });
  }

  deleteTeacherGrop({String? name, String? gropName}) async {
    CollectionReference users = kFs.collection('users');
    await users
        .doc(name)
        .collection('gardes')
        .doc(gropName!)
        .collection('students')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  updateSubDataStudent(
      {FirebaseInfoModel? info, String? name, String? subject}) async {
    CollectionReference users = kFs.collection('users');
    await users.doc(name).collection('subInfo').doc(subject).update({
      'day1': info!.day1,
      'day2': info.day2,
      'time1': info.time1,
      'time2': info.time2,
    });
  }

  updateGropInfo(
      {FirebaseInfoModel? info, String? name, String? subject}) async {
    CollectionReference users = kFs.collection('users');
    await users.doc(name).collection('gardes').doc(subject).update({
      'day1': info!.day1,
      'day2': info.day2,
      'time1': info.time1,
      'time2': info.time2,
    });
  }
}

class FirebaseInfoModel {
  final String? email,
      password,
      rool,
      teacher,
      subject,
      grade,
      day1,
      day2,
      imageNetwork;
  final DateTime? time1, time2;

  final dynamic studentNumber, parentNumber, name;
  final int? ubsent;
  final dynamic birthday;

  FirebaseInfoModel({
    this.imageNetwork,
    this.ubsent,
    this.time1,
    this.time2,
    this.day1,
    this.day2,
    this.name,
    this.rool,
    this.studentNumber,
    this.parentNumber,
    this.email,
    this.password,
    this.birthday,
    this.teacher,
    this.subject,
    this.grade,
  });
  factory FirebaseInfoModel.fromJson(jsonData) {
    return FirebaseInfoModel(
      name: jsonData['name'],
      email: jsonData['email'],
      password: jsonData['password'],
      rool: jsonData['rool'],
      studentNumber: jsonData['studentNumber'],
      parentNumber: jsonData['parentNumber'],
      birthday: jsonData['birthday'],
      grade: jsonData['grade'],
      teacher: jsonData['teacher'],
      subject: jsonData['subject'],
    );
  }
}

String formatTime(timeStamp) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
  return DateFormat('hh:mm a').format(dateTime);
}
