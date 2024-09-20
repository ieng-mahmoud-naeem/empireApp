import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_app/widget/toastedmessage.dart';
import 'package:empire_app/model/firebaseauth_model.dart';
import 'package:empire_app/constants.dart';
import 'package:empire_app/widget/custom_drop_search.dart';
import 'package:empire_app/widget/drop_down.dart';
import 'package:empire_app/widget/loadig_screen.dart';
import 'package:flutter/material.dart';

class TeacherSearch extends StatefulWidget {
  const TeacherSearch({super.key});

  @override
  State<TeacherSearch> createState() => _TeacherSearchState();
}

class _TeacherSearchState extends State<TeacherSearch> {
  List<String> getUserInfoList = [];
  List<String> selectedItemsTeacher = [];
  List<String> subJects = [];
  List<String> teacher = [];
  List<String> day1List = [];
  List<String> day2List = [];
  List<String> nameStudent = [];
  List<String> time1List = [];
  List<String> time2List = [];
  List<String> gradeList = kGradeList;

  bool isLoading = true;
  bool isHight = false;
  String? email, rool, name, subjectName, gradeName;

  var ubsent, studentNumber;

  getUsersList() async {
    await kFs.collection('users').get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        getUserInfoList.add(doc['name'].toString());
      }
    });
    setState(() {});
  }

  void getStudentInfo() async {
    var info = await kFs.collection('users').doc(selectedItemsTeacher[0]).get();
    var info2 = info.data() as Map<String, dynamic>;
    setState(() {
      name = info2['name'];
      email = info2['email'];
      studentNumber = info2['studentNumber'];
      rool = info2['rool'];
    });
  }

  Future<void> getGrop() async {
    setState(() {
      isLoading = false;
      isHight = true;
    });
    await kFs
        .collection('users')
        .doc(selectedItemsTeacher[0])
        .collection('gardes')
        .doc(gradeName!)
        .collection('students')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        toastedmessage(
            msg: 'اختار مجموعة موجوده', backgroundColor: Colors.redAccent);
        setState(() {
          day1List = [];
          day2List = [];
          nameStudent = [];
          time1List = [];
          time2List = [];
          isHight = true;
        });
      } else {
        for (var doc in querySnapshot.docs) {
          setState(() {
            day1List.add(doc['day1'].toString());
            day2List.add(doc['day2'].toString());
            nameStudent.add(doc['name'].toString());
            subJects.add(doc['subject'].toString());
            time1List.add(formatTime(doc['time1']));
            time2List.add(formatTime(doc['time1']));
          });
        }
      }
    });

    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
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
              title: const Text('استعلام عن معلم'),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomDropSearch(
                        width: width,
                        getUserInfoList: getUserInfoList,
                        selectedItems: selectedItemsTeacher,
                        text: 'اسم معلم',
                        onChanged: (p0) {},
                      ),
                    ),
                    SizedBox(
                      height: hight / 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        getStudentInfo();
                      },
                      child: Container(
                        height: 50,
                        width: width / 2,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            'عرض',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: hight / 40,
                    ),
                    const Divider(
                      indent: 16,
                      endIndent: 16,
                    ),
                    SizedBox(
                      height: hight / 40,
                    ),
                    Row(
                      textDirection: kText,
                      children: [
                        const Text(' : الاسم'),
                        Text(name ?? ''),
                      ],
                    ),
                    SizedBox(
                      height: hight / 40,
                    ),
                    Row(
                      textDirection: kText,
                      children: [
                        const Text(' : الايميل'),
                        Text(email ?? ''),
                      ],
                    ),
                    SizedBox(
                      height: hight / 40,
                    ),
                    Row(
                      textDirection: kText,
                      children: [
                        const Text(' : رقم المعلم'),
                        Text(studentNumber ?? ''),
                      ],
                    ),
                    SizedBox(
                      height: hight / 40,
                    ),
                    Row(
                      textDirection: kText,
                      children: [
                        const Text(' : صلاحية الوصول'),
                        Text(rool ?? ''),
                      ],
                    ),
                    SizedBox(
                      height: hight / 40,
                    ),
                    SizedBox(
                      height: hight / 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            getGrop();
                          },
                          child: Container(
                            height: 50,
                            width: width / 3,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                'عرض',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        DropDown(
                          items: gradeList,
                          value: gradeName,
                          onChanged: (p0) {
                            setState(() {
                              gradeName = p0;
                            });
                          },
                          selectItemName: 'الصف الدراسي',
                          width: width / 2.4,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: hight / 40,
                    ),
                    const Text(' المجموعات'),
                    SizedBox(
                      height: hight / 40,
                    ),
                    const Divider(
                      indent: 16,
                      endIndent: 16,
                    ),
                    SizedBox(
                      height: isHight ? 200 : 0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: day1List.length,
                        itemBuilder: (context, index) {
                          return InfoRowStudent(
                            dayValu1: day1List[index],
                            dayValu2: day2List[index],
                            nameStudent: nameStudent[index],
                            time1: time1List[index],
                            time2: time2List[index],
                            subject: subJects[index],
                          );
                        },
                      ),
                    ),
                    const Divider(
                      indent: 16,
                      endIndent: 16,
                    ),
                  ],
                ),
              ),
            ),
          )
        : const LoadigScreen();
  }
}

class InfoRowStudent extends StatelessWidget {
  const InfoRowStudent({
    super.key,
    required this.dayValu1,
    required this.dayValu2,
    required this.nameStudent,
    required this.time1,
    required this.time2,
    this.subject,
  });

  final String? dayValu1, dayValu2, nameStudent, time1, time2, subject;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(nameStudent ?? ''),
            const SizedBox(
              width: 10,
            ),
            const Text(': اسم الطالب'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(subject ?? ''),
            const SizedBox(
              width: 10,
            ),
            const Text(': المادة'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(dayValu2 ?? ''),
            const Text(': اليوم'),
            const SizedBox(
              width: 50,
            ),
            Text(dayValu1 ?? ''),
            const Text(': اليوم'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(time2 ?? ''),
            const Text(': الوقت'),
            const SizedBox(
              width: 50,
            ),
            Text(time1 ?? ''),
            const Text(': الوقت'),
          ],
        ),
        const Divider(
          indent: 100,
          endIndent: 100,
        ),
      ],
    );
  }
}
