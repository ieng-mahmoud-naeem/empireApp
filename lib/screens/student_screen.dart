import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_app/constants.dart';
import 'package:empire_app/screens/login_screen.dart';
import 'package:empire_app/screens/qrcode_error.dart';
import 'package:empire_app/screens/scanner_screen.dart';
import 'package:empire_app/widget/custom_click_butom.dart';
import 'package:empire_app/widget/custom_click_card.dart';
import 'package:empire_app/widget/loadig_screen.dart';
import 'package:empire_app/widget/toastedmessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../model/firebaseauth_model.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});
  static String id = '';

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  String? email, rool, name, emailCheck, barcodeScanRes;
  int? qr, absence, upDateAbsence;
  final List<String> getUserInfoList = [];
  final List<String> day1 = [];
  final List<String> day2 = [];
  final List<String> time1 = [];
  final List<String> time2 = [];
  final List<String> image = [];
  final List<String> subName = [];
  final List<String> teacherName = [];
  final List<String> imageAssetList = kImageAssetList;
  final List<Color> color = kColor;
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
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
        absence = info2['ubsent'];
      });

      await kFs
          .collection('users')
          .doc(emailCheck)
          .collection('subInfo')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          setState(() {
            day1.add(doc['day1']);
            day2.add(doc['day2']);
            subName.add(doc['subject']);
            teacherName.add(doc['teacher']);
            image.add(doc['image']);
            time1.add(formatTime(doc['time1']));
            time2.add(formatTime(doc['time2']));
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

  reloadAbsence() async {
    var info = await kFs.collection('users').doc(emailCheck).get();
    var info2 = info.data() as Map<String, dynamic>;
    setState(() {
      absence = info2['ubsent'];
    });
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
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                child: const Icon(Icons.qr_code_rounded),
                onPressed: () async {
                  try {
                    if (absence! < 1) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const QrcodeError(),
                      ));
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ScannerScreen(
                            onDetect: (cap) async {
                              List<Barcode> barcodes = cap.barcodes;
                              for (var barcode in barcodes) {
                                barcodeScanRes = barcode.displayValue;
                              }
                              try {
                                setState(() {
                                  qr = int.parse(barcodeScanRes!);
                                });
                                setState(() {
                                  upDateAbsence = absence! - qr!;
                                });
                                await kFs
                                    .collection('users')
                                    .doc(emailCheck)
                                    .update({'ubsent': upDateAbsence});
                              } catch (e) {
                                toastedmessage(
                                    msg: 'حاول مره اخري',
                                    backgroundColor: Colors.redAccent);
                              }
                              toastedmessage(
                                  msg: 'عملية تسجيل دخول ناجحة',
                                  backgroundColor: Colors.greenAccent);
                              Navigator.pop(context);
                              reloadAbsence();
                            },
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    toastedmessage(
                        msg: 'حاول مره اخري',
                        backgroundColor: Colors.redAccent);
                  }
                },
              ),
            ),
            key: scaffoldkey,
            backgroundColor: Colors.grey[100],
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
                          CustomClickButom(
                            lable: 'اعادة ضبط كلمة السر',
                            onTap: () async {
                              setState(() {
                                isLoading = false;
                              });
                              try {
                                await FirebaseAuth.instance
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
                        borderRadius: BorderRadius.circular(51),
                      ),
                      child: const Icon(size: 30, Icons.menu),
                    ),
                  ),
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
                        borderRadius: BorderRadius.circular(51),
                      ),
                      child: const Icon(size: 30, Icons.notifications),
                    ),
                  ),
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
            body: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: subName.length,
                  itemBuilder: (context, index) {
                    return CustomCard(
                      onTap: () {},
                      color: color[index],
                      customCardTeacher: CustomCardTeacher(
                          day1: day1[index],
                          day2: day2[index],
                          time1: time1[index],
                          time2: time2[index]),
                      subject: subName[index],
                      teacherName: teacherName[index],
                      imageAsset: image[index],
                    );
                  },
                ),
              ],
            ),
          )
        : const LoadigScreen();
  }
}
