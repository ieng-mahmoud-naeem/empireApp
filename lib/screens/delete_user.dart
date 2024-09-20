import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_app/constants.dart';
import 'package:empire_app/widget/custom_drop_search.dart';
import 'package:empire_app/widget/toastedmessage.dart';
import 'package:flutter/material.dart';

class DeleteUser extends StatefulWidget {
  const DeleteUser({super.key});

  @override
  State<DeleteUser> createState() => _DeleteUserState();
}

class _DeleteUserState extends State<DeleteUser> {
  List<String> getUserInfoList = [];
  List<String> selectedItemsStudent = [];

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
    getUsersList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double hight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('حذف مستخدم'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomDropSearch(
              width: width,
              getUserInfoList: getUserInfoList,
              selectedItems: selectedItemsStudent,
              text: 'اسم المستخدم',
              onChanged: (p0) {},
            ),
          ),
          SizedBox(
            height: hight / 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  try {
                    for (int i = 0; i < selectedItemsStudent.length; i++) {
                      kFs
                          .collection('users')
                          .doc(selectedItemsStudent[i])
                          .delete();
                    }
                    toastedmessage(
                        backgroundColor: Colors.greenAccent,
                        msg: 'تم الحذف بنجاح');
                    setState(() {
                      selectedItemsStudent = [];
                    });
                  } catch (e) {
                    toastedmessage(
                        msg: 'حاول مره اخري في وقت لاحق',
                        backgroundColor: Colors.orange);
                  }
                },
                child: Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: Text(
                      'حذف المستخدم',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
