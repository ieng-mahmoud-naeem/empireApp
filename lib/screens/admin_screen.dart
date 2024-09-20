import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:empire_app/model/card_model.dart';
import 'package:empire_app/screens/delete_user.dart';
import 'package:empire_app/screens/edite_grop.dart';
import 'package:empire_app/screens/sign_up_screen.dart';
import 'package:empire_app/screens/student_search_screen.dart';
import 'package:empire_app/screens/teacher_search_screen.dart';
import 'package:empire_app/constants.dart';
import 'package:empire_app/screens/create_grop.dart';
import 'package:empire_app/widget/custom_card.dart';
import 'package:empire_app/widget/custom_click_butom.dart';
import 'package:empire_app/widget/loadig_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widget/toastedmessage.dart';
import 'login_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  static String id = '';

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String? email, rool, name, emailCheck;
  final List<String> getUserInfoList = [];
  bool isLoading = true;
  void getInfo() async {
    setState(() {
      isLoading = false;
    });
    try {
      await kFs.collection('users').get().then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (FirebaseAuth.instance.currentUser!.email == doc['email']) {
            emailCheck = doc['name'];
            setState(() {});
          }
        }
      });
      var info = await kFs.collection('users').doc(emailCheck).get();
      var info2 = info.data() as Map<String, dynamic>;
      setState(() {
        name = info2['name'];
        email = info2['email'];
        rool = info2['rool'];
      });
      setState(() {
        isLoading = true;
      });
    } catch (e) {
      setState(() {
        isLoading = true;
      });
      return null;
    }
  }

  List<Cardmodel> cardModel = [
    Cardmodel(
      colors: [
        const Color(0xff080202),
        const Color(0xff73BBC9),
      ],
      text: 'انشاء مجموعه ',
      onTap: const CreateGrop(),
    ),
    Cardmodel(
      colors: [
        const Color(0xff080202),
        const Color(0xff73BBC9),
      ],
      text: 'اضافة مستخدم جديد ',
      onTap: const SignUpScreen(),
    ),
    Cardmodel(
      colors: [
        const Color(0xff080202),
        const Color(0xff73BBC9),
      ],
      text: 'تعديل مجموعه ',
      onTap: const EditeGrop(),
    ),
    Cardmodel(
      colors: [
        const Color(0xff080202),
        const Color(0xff73BBC9),
      ],
      text: 'استعلام عن طالب',
      onTap: const StudentSearch(),
    ),
    Cardmodel(
      colors: [
        const Color(0xff080202),
        const Color(0xff73BBC9),
      ],
      text: 'استعلام عن معلم ',
      onTap: const TeacherSearch(),
    ),
    Cardmodel(
      colors: [
        const Color(0xff080202),
        const Color(0xff73BBC9),
      ],
      text: 'حذف المستخدمين',
      onTap: const DeleteUser(),
    ),
  ];
  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double hight = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            drawer: isLoading
                ? Drawer(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          SizedBox(
                            height: hight / 9,
                          ),
                          Container(
                            height: 110,
                            width: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(190),
                              color: Colors.blue,
                            ),
                            child: Image.asset('assets/image/logowight.png'),
                          ),
                          SizedBox(
                            height: hight / 12,
                          ),
                          const Divider(),
                          SizedBox(
                            height: hight / 30,
                          ),
                          Row(
                            textDirection: kText,
                            children: [
                              const Text(' : الاسم'),
                              SizedBox(
                                width: width / 2.4,
                                child: Text(
                                  name ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: hight / 25,
                          ),
                          Row(
                            textDirection: kText,
                            children: [
                              const Text(
                                ' : الايميل',
                              ),
                              SizedBox(
                                width: width / 2.4,
                                child: Text(
                                  email ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: hight / 22,
                          ),
                          Row(
                            textDirection: kText,
                            children: [
                              const Text(' : صلاحية الوصول'),
                              Text(rool ?? ''),
                            ],
                          ),
                          SizedBox(
                            height: hight / 9,
                          ),
                          GestureDetector(
                            onTap: () {
                              try {
                                setState(() {
                                  isLoading = false;
                                });
                                FirebaseAuth.instance.signOut();
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ));
                                setState(() {
                                  isLoading = true;
                                });
                              } catch (e) {
                                toastedmessage(
                                    msg: 'حاول مره اخري',
                                    backgroundColor: Colors.redAccent);
                                setState(() {
                                  isLoading = true;
                                });
                              }
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('تسجيل الخروج', textDirection: kText),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.logout)
                              ],
                            ),
                          ),
                          SizedBox(
                            height: hight / 20,
                          ),
                          CustomClickButom(
                            lable: 'اعادة ضبط الغياب',
                            onTap: () async {
                              try {
                                setState(() {
                                  isLoading = false;
                                });
                                await kFs.collection('users').get().then(
                                  (QuerySnapshot querySnapshot) {
                                    for (var doc in querySnapshot.docs) {
                                      getUserInfoList
                                          .add(doc['name'].toString());
                                    }
                                  },
                                );
                                for (int i = 0;
                                    i <= getUserInfoList.length;
                                    i++) {
                                  await kFs
                                      .collection('users')
                                      .doc(getUserInfoList[i])
                                      .update({'ubsent': 0});
                                }
                                setState(() {
                                  isLoading = true;
                                });
                              } catch (e) {
                                setState(() {
                                  isLoading = true;
                                });
                                return;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : const LoadigScreen(),
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                'Be the prince of our Empire',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: EasyDateTimeLine(
                    locale: 'ar',
                    initialDate: DateTime.now(),
                    onDateChange: (ss) {},
                    headerProps: const EasyHeaderProps(
                      showMonthPicker: false,
                      monthPickerType: MonthPickerType.switcher,
                      dateFormatter: DateFormatter.fullDateDMonthAsStrY(),
                    ),
                    dayProps: const EasyDayProps(
                      dayStructure: DayStructure.dayStrDayNum,
                      activeDayStyle: DayStyle(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xff080202),
                              Color(0xff73BBC9),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: cardModel.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 20),
                    itemBuilder: (context, index) {
                      return CustomCard(
                          colors: cardModel[index],
                          text: cardModel[index],
                          onTap: cardModel[index]);
                    },
                  ),
                ),
              ],
            ),
          )
        : const LoadigScreen();
  }
}
