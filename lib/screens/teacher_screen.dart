import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_app/constants.dart';
import 'package:empire_app/model/firebaseauth_model.dart';
import 'package:empire_app/screens/login_screen.dart';
import 'package:empire_app/screens/teacher_grop_veiw.dart';
import 'package:empire_app/widget/custom_click_butom.dart';
import 'package:empire_app/widget/custom_click_card.dart';
import 'package:empire_app/widget/loadig_screen.dart';
import 'package:empire_app/widget/toastedmessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});
  static String id = '';

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  String? email, rool, name, emailCheck;
  final List<String> getUserInfoList = [];
  final List<String> gardeNameList = [];
  final List<String> day1 = [];
  final List<String> day2 = [];
  final List<String> time1 = [];
  final List<String> time2 = [];
  final List<String> subName = [];
  final List<String> imageAssetList = kImageAssetList;
  final List<Color> color = kColor;
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();

  bool isLoading = true;
  getInfo() async {
    setState(() {
      isLoading = false;
    });
    try {
      await kFs.collection('users').get().then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (FirebaseAuth.instance.currentUser!.email == doc['email']) {
            setState(() {
              emailCheck = doc['name'];
            });
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
      await kFs
          .collection('users')
          .doc(emailCheck)
          .collection('gardes')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          setState(() {
            day1.add(doc['day1']);
            day2.add(doc['day2']);
            subName.add(doc['subject']);
            time1.add(formatTime(doc['time1']));
            time2.add(formatTime(doc['time2']));
            gardeNameList.add(doc['garde']);
          });
        }
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
            key: scaffoldkey,
            backgroundColor: Colors.grey[100],
            drawer: isLoading
                ? Drawer(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 60),
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
                              setState(() {
                                isLoading = false;
                              });
                              try {
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
                            lable: 'اعادة ضبط كلمة السر',
                            onTap: () {
                              try {
                                setState(() {
                                  isLoading = false;
                                });
                                FirebaseAuth.instance
                                    .sendPasswordResetEmail(email: email!);
                                setState(() {
                                  isLoading = true;
                                });
                                toastedmessage(
                                    msg: 'راجع حسابك لتعين كلمة السر',
                                    backgroundColor: Colors.green);
                              } catch (e) {
                                toastedmessage(
                                    msg: 'حاول مره اخري',
                                    backgroundColor: Colors.redAccent);
                                setState(() {
                                  isLoading = true;
                                });
                              }
                            },
                          ),
                          SizedBox(
                            height: hight / 9,
                          ),
                        ],
                      ),
                    ),
                  )
                : const LoadigScreen(),
            appBar: AppBar(
              backgroundColor: Colors.grey[100],
              toolbarHeight: 90,
              leading: GestureDetector(
                onTap: () {
                  scaffoldkey.currentState!.openDrawer();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 25,
                      child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(51)),
                          child: const Icon(size: 30, Icons.menu))),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 9.0),
                  child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(51)),
                          child: const Icon(size: 30, Icons.notifications))),
                )
              ],
              centerTitle: true,
              title: Column(
                textDirection: TextDirection.rtl,
                children: [
                  const Text(
                    'مرحبا بعودتك',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    name ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: gardeNameList.length,
              itemBuilder: (context, index) {
                return CustomCard(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return TeacherGropVeiw(
                            gradeName: gardeNameList[index],
                            name: emailCheck!,
                          );
                        },
                      ));
                    },
                    color: color[index],
                    customCardTeacher: CustomCardTeacher(
                        day1: day1[index],
                        day2: day2[index],
                        time1: time1[index],
                        time2: time2[index]),
                    subject: subName[index],
                    teacherName: name,
                    imageAsset: imageAssetList[index],
                    gardeText: gardeNameList[index]);
              },
            ),
          )
        : const LoadigScreen();
  }
}
