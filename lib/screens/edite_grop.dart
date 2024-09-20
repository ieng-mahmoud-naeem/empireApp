import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_app/widget/toastedmessage.dart';
import 'package:empire_app/model/firebaseauth_model.dart';
import 'package:empire_app/constants.dart';
import 'package:empire_app/widget/custom_drop_search.dart';
import 'package:empire_app/widget/drop_day_time.dart';
import 'package:empire_app/widget/drop_down.dart';
import 'package:empire_app/widget/loadig_screen.dart';
import 'package:flutter/material.dart';

class EditeGrop extends StatefulWidget {
  const EditeGrop({super.key});

  @override
  State<EditeGrop> createState() => _EditeGropState();
}

class _EditeGropState extends State<EditeGrop> {
  String? dayValu1,
      dayValu2,
      subjectName,
      teacherName,
      gradeName,
      gradeNameCheck;
  DateTime? time1, time2;
  List<String> selectedItemsTeacher = [];
  List<String> selectedItemsStudent = [];
  final List<String> getSubInfoList = [];
  final List<String> getUserInfoList = [];
  final List<String> grade = kGradeList;
  bool isLoading = true;
  getSubList() async {
    await kFs.collection('subject').get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        getSubInfoList.add(doc['sub'].toString());
      }
    });
    setState(() {});
  }

  getUsersList() async {
    await kFs.collection('users').get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        getUserInfoList.add(doc['name'].toString());
      }
    });

    setState(() {});
  }

  @override
  void initState() {
    getSubList();
    getUsersList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double hight = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    return isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text('تعديل مجموعه '),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomDropSearch(
                  width: width,
                  getUserInfoList: getUserInfoList,
                  selectedItems: selectedItemsStudent,
                  text: 'اسم الطالب',
                  onChanged: (p0) {},
                ),
                CustomDropSearch(
                  width: width,
                  getUserInfoList: getUserInfoList,
                  selectedItems: selectedItemsTeacher,
                  text: 'اسم المعلم',
                  onChanged: (p0) {},
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropDown(
                        items: getSubInfoList,
                        value: subjectName,
                        onChanged: (p0) {
                          subjectName = p0;
                          setState(() {});
                        },
                        selectItemName: 'المادة',
                        width: 125,
                      ),
                      DropDown(
                        items: grade,
                        value: gradeName,
                        onChanged: (p0) {
                          gradeName = p0;
                          setState(() {});
                        },
                        selectItemName: 'الصف الدراسي',
                        width: width / 2,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: hight / 20,
                ),
                DropDayTime(
                  onChangedTime1: (p0) {
                    setState(() {
                      time1 = p0;
                    });
                  },
                  onChangedTime2: (p0) {
                    setState(() {
                      time2 = p0;
                    });
                  },
                  onChangedDay1: (p0) {
                    setState(() {
                      dayValu1 = p0;
                    });
                  },
                  onChangedDay2: (p0) {
                    setState(() {
                      dayValu2 = p0;
                    });
                  },
                  initTime1: time1 ?? DateTime.now(),
                  initTime2: time2 ?? DateTime.now(),
                  valueDay1: dayValu1,
                  valueDay2: dayValu2,
                  timeDay1: time1 ?? DateTime.now(),
                  timeDay2: time2 ?? DateTime.now(),
                ),
                SizedBox(
                  height: hight / 20,
                ),
                GestureDetector(
                  onTap: () async {
                    await kFs
                        .collection('users')
                        .doc(selectedItemsTeacher[0])
                        .collection('gardes')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        setState(() {
                          gradeNameCheck = doc['garde'];
                        });
                      }
                    });

                    if (gradeNameCheck == gradeName) {
                      await FirestoreData().deleteTeacherGrop(
                        name: selectedItemsTeacher[0],
                        gropName: gradeName,
                      );
                      try {
                        setState(() {
                          isLoading = false;
                        });

                        FirestoreData().addTeacherGropIfo(
                          name: selectedItemsTeacher[0],
                          gropName: gradeName,
                          info: FirebaseInfoModel(
                            grade: gradeName,
                            subject: subjectName,
                            day1: dayValu1,
                            time1: time1,
                            day2: dayValu2,
                            time2: time2,
                          ),
                        );
                        for (int i = 0; i < selectedItemsStudent.length; i++) {
                          FirestoreData().updateSubDataStudent(
                            subject: subjectName,
                            name: selectedItemsStudent[i],
                            info: FirebaseInfoModel(
                              day1: dayValu1,
                              time1: time1,
                              day2: dayValu2,
                              time2: time2,
                            ),
                          );
                          FirestoreData().addTeacherGropStudentName(
                            name: selectedItemsTeacher[0],
                            gropName: gradeName,
                            info: FirebaseInfoModel(
                              name: selectedItemsStudent[i],
                              subject: subjectName,
                              day1: dayValu1,
                              time1: time1,
                              day2: dayValu2,
                              time2: time2,
                            ),
                          );
                        }
                        FirestoreData().updateGropInfo(
                          subject: subjectName,
                          name: selectedItemsTeacher[0],
                          info: FirebaseInfoModel(
                            day1: dayValu1,
                            time1: time1,
                            day2: dayValu2,
                            time2: time2,
                          ),
                        );
                        setState(() {
                          selectedItemsTeacher = [];
                          selectedItemsStudent = [];
                          isLoading = true;
                        });
                        toastedmessage(
                            backgroundColor: Colors.greenAccent,
                            msg: 'تم التعديل بنجاح');
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) {
                            return const EditeGrop();
                          },
                        ));
                      } catch (e) {
                        toastedmessage(
                            backgroundColor: Colors.red,
                            msg:
                                'يرجي التحقق من الاتصال بالانترنت لاكتمال التسجيل');
                        isLoading = true;
                        setState(() {});
                      }
                    } else {
                      toastedmessage(
                          backgroundColor: Colors.red,
                          msg: 'اختار مجموعة موجودة');
                    }
                  },
                  child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                          child: Text(
                        'تعديل المجموعة',
                        style: TextStyle(color: Colors.white),
                      ))),
                )
              ],
            ),
          )
        : const LoadigScreen();
  }
}
