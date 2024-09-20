import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_app/widget/toastedmessage.dart';
import 'package:empire_app/model/firebaseauth_model.dart';
import 'package:empire_app/constants.dart';
import 'package:empire_app/widget/custom_drop_search.dart';
import 'package:empire_app/widget/drop_day_time.dart';
import 'package:empire_app/widget/drop_down.dart';
import 'package:empire_app/widget/loadig_screen.dart';
import 'package:flutter/material.dart';

class CreateGrop extends StatefulWidget {
  const CreateGrop({super.key});

  @override
  State<CreateGrop> createState() => _CreateGropState();
}

class _CreateGropState extends State<CreateGrop> {
  String? dayValu1, dayValu2, subjectName, teacherName, gradeName, imageAsset;
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
              title: const Text('انشاء مجموعه '),
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
                          switch (subjectName) {
                            case 'جغرافيا':
                              setState(() {
                                imageAsset = 'assets/image/geo.png';
                              });
                              break;
                            case 'لغة فرنسية':
                              setState(() {
                                imageAsset = 'assets/image/frinch.png';
                              });
                              break;
                            case 'فلسفة':
                              setState(() {
                                imageAsset = 'assets/image/flsafa.png';
                              });
                              break;
                            case 'لغة انجليزية':
                              setState(() {
                                imageAsset = 'assets/image/english.png';
                              });
                              break;
                            case 'لغة عربية':
                              setState(() {
                                imageAsset = 'assets/image/العربي.png';
                              });
                              break;
                            case 'تاريخ':
                              setState(() {
                                imageAsset = 'assets/image/history.png';
                              });
                              break;
                            case 'علوم':
                              setState(() {
                                imageAsset = 'assets/image/sc.png';
                              });
                              break;

                            case 'رياضيات':
                              setState(() {
                                imageAsset = 'assets/image/math.png';
                              });
                              break;
                            case 'علم نفس':
                              setState(() {
                                imageAsset = 'assets/image/mental_746964.png';
                              });
                              break;
                            case 'دراسات اجتماعية':
                              setState(() {
                                imageAsset = 'assets/image/studies.png';
                              });
                              break;
                            case 'فيزياء':
                              setState(() {
                                imageAsset = 'assets/image/physics.png';
                              });
                              break;
                            case 'كيمياء':
                              setState(() {
                                imageAsset = 'assets/image/chmistry.png';
                              });
                              break;
                            case 'أحياء':
                              setState(() {
                                imageAsset = 'assets/image/ahyaa.png';
                              });
                              break;
                            default:
                              setState(() {
                                imageAsset = 'assets/image/logowight.png';
                              });
                          }
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
                  onTap: () {
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
                        FirestoreData().addSubDataStudent(
                            subject: subjectName,
                            name: selectedItemsStudent[i],
                            info: FirebaseInfoModel(
                              subject: subjectName,
                              imageNetwork: imageAsset,
                              teacher: selectedItemsTeacher[0],
                              day1: dayValu1,
                              time1: time1,
                              day2: dayValu2,
                              time2: time2,
                            ));
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

                      setState(() {
                        selectedItemsTeacher = [];
                        selectedItemsStudent = [];
                        isLoading = true;
                      });
                      toastedmessage(
                          backgroundColor: Colors.greenAccent,
                          msg: 'تم التسجيل بنجاح');
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) {
                          return const CreateGrop();
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
                  },
                  child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                          child: Text(
                        'انشاء مجموعة جديدة',
                        style: TextStyle(color: Colors.white),
                      ))),
                )
              ],
            ),
          )
        : const LoadigScreen();
  }
}
