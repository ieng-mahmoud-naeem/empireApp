import 'package:empire_app/widget/toastedmessage.dart';
import 'package:empire_app/model/firebaseauth_model.dart';
import 'package:empire_app/widget/custom_bottom.dart';
import 'package:empire_app/widget/custom_text_form_field_a.dart';
import 'package:empire_app/widget/drop_down.dart';
import 'package:empire_app/widget/loadig_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static String id = '';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

bool isLoading = true;
String? email, password, rool;
dynamic studentNumber, parentNumber, name;
bool hidden = true;
dynamic dateTimePick;

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text('انشاء مستخدم جديد'),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 16, left: 16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 30,
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
                            setState(() {
                              email = p0;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 16,
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
                                      size: 20,
                                      color: Colors.black,
                                    )
                                  : const Icon(
                                      Icons.visibility_off,
                                      size: 20,
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
                          height: 16,
                        ),
                        CustomTextFormField(
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter valid name !';
                            }
                            return null;
                          },
                          hintText: 'Name',
                          onChanged: (p0) {
                            name = p0;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomTextFormField(
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter valid student\'s number !';
                            }
                            return null;
                          },
                          hintText: 'Student Number',
                          onChanged: (p0) {
                            studentNumber = p0;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomTextFormField(
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter valid parent\'s number !';
                            }
                            return null;
                          },
                          hintText: 'Parent Number',
                          onChanged: (p0) {
                            parentNumber = p0;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropDown(
                              width: 150,
                              selectItemName: 'Rool',
                              items: const ['Admin', 'Teacher', 'Student'],
                              value: rool,
                              onChanged: (p0) {
                                setState(() {
                                  rool = p0;
                                  setState(() {});
                                });
                              },
                            ),
                            TimePickerSpinnerPopUp(
                              mode: CupertinoDatePickerMode.date,
                              initTime: DateTime.now(),
                              minTime: DateTime(1950),
                              maxTime: DateTime.now(),
                              barrierColor: Colors
                                  .black12, //Barrier Color when pop up show
                              minuteInterval: 1,
                              padding:
                                  const EdgeInsets.fromLTRB(12, 10, 12, 10),
                              cancelText: 'Cancel',
                              confirmText: 'OK',
                              pressType: PressType.singlePress,
                              timeFormat: 'dd/MM/yyyy',
                              onChange: (dateTime) {
                                dateTimePick = dateTime;
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  CustomBottom(
                    width: double.infinity,
                    onTap: () async {
                      if (email == null && password == null) {
                        toastedmessage(
                            backgroundColor: Colors.red,
                            msg: 'تحقق من كتابة الايميل و الباسورد');
                      } else {
                        try {
                          isLoading = false;
                          setState(() {});
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email!,
                            password: password!,
                          );
                          FirestoreData().addData(
                            info: FirebaseInfoModel(
                              name: name!,
                              rool: rool,
                              studentNumber: studentNumber!,
                              parentNumber: parentNumber!,
                              email: email!,
                              password: password!,
                              birthday: dateTimePick,
                              ubsent: 0,
                            ),
                          );
                          isLoading = true;
                          setState(() {});
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) {
                              return const SignUpScreen();
                            },
                          ));
                          toastedmessage(
                              backgroundColor: Colors.greenAccent,
                              msg: 'تم التسجيل بنجاح');

                          setState(() {});
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            toastedmessage(
                                backgroundColor: Colors.red,
                                msg: 'The password provided is too weak.');
                            isLoading = true;
                            setState(() {});
                          } else if (e.code == 'email-already-in-use') {
                            toastedmessage(
                                backgroundColor: Colors.red,
                                msg:
                                    'The account already exists for that email.');
                            isLoading = true;
                            setState(() {});
                          } else {
                            toastedmessage(
                                backgroundColor: Colors.red,
                                msg:
                                    'يرجي التحقق من الاتصال بالانترنت لاكتمال التسجيل');
                            isLoading = true;
                            setState(() {});
                          }
                        }
                      }
                    },
                    color: Colors.black,
                    name: 'Sign Up',
                  ),
                ],
              ),
            ),
          )
        : const LoadigScreen();
  }
}
