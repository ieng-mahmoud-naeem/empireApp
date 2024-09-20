import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_app/constants.dart';
import 'package:empire_app/widget/toastedmessage.dart';
import 'package:empire_app/model/firebaseauth_model.dart';
import 'package:empire_app/screens/admin_screen.dart';
import 'package:empire_app/screens/teacher_screen.dart';
import 'package:empire_app/widget/custom_bottom.dart';
import 'package:empire_app/widget/custom_text_form_field_a.dart';
import 'package:empire_app/widget/loadig_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'student_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String loginScreenId = '';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = true;
  String? email, password;
  bool hidden = true;
  String? rool;
  FirebaseInfoModel firebaseInfoModel = FirebaseInfoModel();
  List<String> emailCheck = [];
  List<String> roolCheck = [];
  void roolCheckFirebase() async {
    setState(() {
      isLoading = false;
    });
    try {
      await kFs.collection('users').get().then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (FirebaseAuth.instance.currentUser!.email == doc['email'] &&
              doc['rool'] == 'Admin') {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const AdminScreen()));
          } else if (FirebaseAuth.instance.currentUser!.email == doc['email'] &&
              doc['rool'] == 'Teacher') {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const TeacherScreen()));
          } else if (FirebaseAuth.instance.currentUser!.email == doc['email'] &&
              doc['rool'] == 'Student') {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const StudentScreen()));
          }
        }
      });
    } catch (e) {
      return null;
    }
  }

  // var auth = FirebaseAuth.instance;
  // bool islogin = false;
  // checkLoginStatus() {
  //   auth.authStateChanges().listen((User? user) {
  //     if (user != null && mounted && rool == 'Admin') {
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(
  //           builder: (context) => const AdminScreen(),
  //         ),
  //       );
  //     } else if (user != null && mounted && rool == 'Teacher') {
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(
  //           builder: (context) => const TeacherScreen(),
  //         ),
  //       );
  //     } else if (user != null && mounted && rool == 'Student') {
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(
  //           builder: (context) => const StudentScreen(),
  //         ),
  //       );
  //     }
  //   });
  //   setState(() {});
  // }
  @override
  void initState() {
    roolCheckFirebase();
    setState(() {
      isLoading = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double hight = MediaQuery.sizeOf(context).height;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/image/Untitled-1.png'),
        ),
      ),
      child: isLoading
          ? Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: hight * .45,
                            ),
                            CustomTextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter valid e-mail !';
                                }
                                return null;
                              },
                              hintText: 'E-mail',
                              onChanged: (p0) {
                                email = p0;
                              },
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            CustomTextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: hidden,
                              icon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hidden = !hidden;
                                    });
                                  },
                                  icon: hidden
                                      ? const Icon(
                                          Icons.visibility_outlined,
                                          color: Colors.black,
                                        )
                                      : const Icon(
                                          Icons.visibility_off,
                                          color: Colors.black,
                                        )),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter right password !';
                                }
                                return null;
                              },
                              hintText: 'Password',
                              onChanged: (p0) {
                                password = p0;
                              },
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (email == null) {
                                      toastedmessage(
                                          msg: 'Please enter your e-mail.',
                                          backgroundColor: Colors.red);
                                    } else {
                                      FirebaseAuth.instance
                                          .sendPasswordResetEmail(
                                              email: email!);
                                      toastedmessage(
                                          msg: 'Password was sent.',
                                          backgroundColor: Colors.green);
                                    }
                                  },
                                  child: const Text(
                                    'forget password ?',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            CustomBottom(
                              width: double.infinity,
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  isLoading = false;
                                  setState(() {});
                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                      email: email!,
                                      password: password!,
                                    );
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'user-not-found') {
                                      toastedmessage(
                                          backgroundColor: Colors.red,
                                          msg: 'No user found for that email.');
                                      isLoading = true;
                                      setState(() {});
                                    } else if (e.code == 'wrong-password') {
                                      toastedmessage(
                                          backgroundColor: Colors.red,
                                          msg:
                                              'Wrong password provided for that user.');
                                      isLoading = true;
                                      setState(() {});
                                    } else {
                                      toastedmessage(
                                          backgroundColor: Colors.red,
                                          msg: 'Wrong email or password');

                                      isLoading = true;
                                      setState(() {});
                                    }
                                  }
                                  FirebaseAuth.instance
                                      .authStateChanges()
                                      .listen((User? user) {
                                    if (user != null && mounted) {
                                      roolCheckFirebase();
                                      setState(() {});
                                    } else {}
                                  });
                                }
                              },
                              color: Colors.black,
                              name: 'Login',
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const LoadigScreen(),
    );
  }
}
