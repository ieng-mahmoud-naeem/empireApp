import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_app/model/firebaseauth_model.dart';
import 'package:empire_app/screens/teacher_search_screen.dart';
import 'package:empire_app/widget/loadig_screen.dart';
import 'package:empire_app/widget/toastedmessage.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class TeacherGropVeiw extends StatefulWidget {
  const TeacherGropVeiw({
    super.key,
    required this.name,
    required this.gradeName,
  });
  final String name, gradeName;
  @override
  State<TeacherGropVeiw> createState() => _TeacherGropVeiwState();
}

List<String> day1 = [];
List<String> day2 = [];
List<String> time1 = [];
List<String> time2 = [];
List<String> subName = [];
List<String> studentName = [];
bool isLoading = true;

class _TeacherGropVeiwState extends State<TeacherGropVeiw> {
  getStudentDetails() async {
    try {
      setState(() {
        isLoading = false;
      });
      await kFs
          .collection('users')
          .doc(widget.name)
          .collection('gardes')
          .doc(widget.gradeName)
          .collection('students')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          setState(() {
            day1.add(doc['day1']);
            day2.add(doc['day2']);
            subName.add(doc['subject']);
            studentName.add(doc['name']);
            time1.add(formatTime(doc['time1']));
            time2.add(formatTime(doc['time2']));
          });
        }
      });
      setState(() {
        isLoading = true;
      });
    } catch (e) {
      toastedmessage(msg: 'حاول مره اخري', backgroundColor: Colors.redAccent);
    }
  }

  clear() {
    setState(() {
      day1 = [];
      day2 = [];
      time1 = [];
      time2 = [];
      subName = [];
      studentName = [];
    });
  }

  @override
  void initState() {
    getStudentDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text('مجموعتي'),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    clear();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            ),
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: studentName.length,
              itemBuilder: (context, index) {
                return InfoRowStudent(
                    dayValu1: day1[index],
                    dayValu2: day2[index],
                    nameStudent: studentName[index],
                    subject: subName[index],
                    time1: time1[index],
                    time2: time2[index]);
              },
            ),
          )
        : const LoadigScreen();
  }
}
