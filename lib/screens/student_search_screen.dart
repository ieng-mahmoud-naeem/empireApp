import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_app/model/firebaseauth_model.dart';
import 'package:empire_app/constants.dart';
import 'package:empire_app/widget/custom_drop_search.dart';
import 'package:empire_app/widget/loadig_screen.dart';
import 'package:empire_app/widget/toastedmessage.dart';
import 'package:flutter/material.dart';

class StudentSearch extends StatefulWidget {
  const StudentSearch({super.key});

  @override
  State<StudentSearch> createState() => _StudentSearchState();
}

class _StudentSearchState extends State<StudentSearch> {
  TextEditingController? controller = TextEditingController();
  final List<String> getUserInfoList = [];
  List<String> selectedItemsStudent = [];
  List<String> subJects = [];
  List<String> teacher = [];
  List<String> day1List = [];
  List<String> day2List = [];
  List<String> subjectList = [];
  List<String> teacherNameList = [];
  List<String> time1List = [];
  List<String> time2List = [];
  bool isLoading = true;
  bool isHight = false;
  String? email, password, rool, name, grade;
  var studentNumber, parentNumber;
  late int? ubsent = 0;
  getUsersList() async {
    await kFs.collection('users').get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        getUserInfoList.add(doc['name'].toString());
      }
    });
    setState(() {});
  }

  void getStudentInfo() async {
    try {
      setState(() {
        isLoading = false;
      });
      var info =
          await kFs.collection('users').doc(selectedItemsStudent[0]).get();
      var info2 = info.data() as Map<String, dynamic>;
      setState(() {
        name = info2['name'];
        email = info2['email'];
        parentNumber = info2['parentNumber'];
        studentNumber = info2['studentNumber'];
        rool = info2['rool'];
        grade = info2['grade'];
        ubsent = info2['ubsent'];
      });
      setState(() {
        isLoading = true;
      });
    } catch (e) {
      toastedmessage(
          msg: 'حاول مره اخري في وقت لاحق', backgroundColor: Colors.orange);
    }
  }

  void getStudentSubject() async {
    setState(() {
      isLoading = false;
    });
    await kFs
        .collection('users')
        .doc(selectedItemsStudent[0])
        .collection('subInfo')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          day1List.add(doc['day1'].toString());
          day2List.add(doc['day2'].toString());
          subjectList.add(doc['subject'].toString());
          teacherNameList.add(doc['teacher'].toString());
          time1List.add(formatTime(doc['time1']));
          time2List.add(formatTime(doc['time1']));
          isHight = true;
          setState(() {
            isLoading = true;
            isHight = true;
          });
        }
      } else if (querySnapshot.docs.isEmpty) {
        setState(() {
          isLoading = true;
          isHight = false;
        });
      }
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
              title: const Text('استعلام عن طالب'),
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
                        selectedItems: selectedItemsStudent,
                        text: 'اسم الطالب',
                        onChanged: (p0) {},
                      ),
                    ),
                    SizedBox(
                      height: hight / 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        getStudentInfo();
                        getStudentSubject();
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
                        const Text(' : رقم ولي الامر'),
                        Text(parentNumber ?? ''),
                      ],
                    ),
                    SizedBox(
                      height: hight / 40,
                    ),
                    Row(
                      textDirection: kText,
                      children: [
                        const Text(' : رقم الطالب'),
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
                    Row(
                      textDirection: kText,
                      children: [
                        const Text(' :  السنة الدراسية'),
                        Text(grade ?? ''),
                      ],
                    ),
                    SizedBox(
                      height: hight / 40,
                    ),
                    const Text('   المواد الدراسية'),
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
                          try {
                            return InfoRowStudent(
                                dayValu1: day1List[index],
                                dayValu2: day2List[index],
                                subjectName: subjectList[index],
                                teacherName: teacherNameList[index],
                                time1: time1List[index],
                                time2: time2List[index]);
                          } catch (e) {
                            toastedmessage(
                                msg: 'حاول مره اخري في وقت لاحق',
                                backgroundColor: Colors.orange);
                          }
                          return null;
                        },
                      ),
                    ),
                    const Divider(
                      indent: 16,
                      endIndent: 16,
                    ),
                    SizedBox(
                      height: hight / 40,
                    ),
                    const Text('ادخل عدد مرات الحضور'),
                    SizedBox(
                      height: hight / 40,
                    ),
                    SizedBox(
                      width: width / 5,
                      child: TextField(
                        controller: controller,
                        onChanged: (value) {
                          setState(() {
                            ubsent = int.parse(value);
                          });
                        },
                        textDirection: TextDirection.ltr,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: false,
                          hintText: '$ubsent',
                          hintStyle: const TextStyle(
                            fontFamily: 'ElMessiri',
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          fillColor: Colors.grey,
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.black)),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: hight / 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        try {
                          kFs
                              .collection('users')
                              .doc(selectedItemsStudent[0])
                              .update({'ubsent': ubsent});
                          toastedmessage(
                              msg: 'تم حفظ البيانات بشكل سليم',
                              backgroundColor: Colors.greenAccent);
                          setState(() {
                            ubsent = 0;
                            selectedItemsStudent = [];
                            name = '';
                            parentNumber = '';
                            studentNumber = '';
                            rool = '';
                            email = '';
                            day1List = [];
                            day2List = [];
                            subjectList = [];
                            teacherNameList = [];
                            time1List = [];
                            time2List = [];
                          });
                        } catch (e) {
                          toastedmessage(
                              msg:
                                  'لم يتم حفظ البيانات بشكل سليم حاول مره اخري في وقت لاحق',
                              backgroundColor: Colors.orange);
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            'تأكيد',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
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
    required this.subjectName,
    required this.teacherName,
    required this.time1,
    required this.time2,
  });

  final String? dayValu1, dayValu2, subjectName, teacherName, time1, time2;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(subjectName ?? ''),
            const Text(': المادة'),
            SizedBox(
              width: width / 50,
            ),
            Text(teacherName ?? ''),
            const Text(': المعلم'),
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
