import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.customCardTeacher,
    this.teacherName,
    required this.imageAsset,
    this.gardeText,
    required this.subject,
    required this.color,
    required this.onTap,
  });
  final CustomCardTeacher customCardTeacher;
  final String? teacherName, imageAsset, gardeText, subject;
  final Color? color;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    double hight = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 24,
        left: 16.0,
        right: 16.0,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: hight / 3,
          width: width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: width / 15),
                    child: Container(
                      height: hight / 6.5,
                      width: width / 3.5,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset(
                          imageAsset!,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: width / 20,
              ),
              Column(
                children: [
                  SizedBox(
                    height: hight / 50,
                  ),
                  Text(
                    gardeText ?? '',
                    style: const TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: hight / 40,
                  ),
                  Text(
                    subject ?? '',
                    style: const TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: hight / 40,
                  ),
                  Text(
                    teacherName ?? '',
                    style: const TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: hight / 40,
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        width: 80,
                        height: 28,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            customCardTeacher.day1 ?? '',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width / 15,
                      ),
                      Container(
                        width: 80,
                        height: 28,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            customCardTeacher.day2 ?? '',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: hight / 70,
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        width: 80,
                        height: 28,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            customCardTeacher.time1 ?? '',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width / 15,
                      ),
                      Container(
                        width: 80,
                        height: 28,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            customCardTeacher.time2 ?? '',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCardTeacher {
  final String? day1, day2, time1, time2;

  CustomCardTeacher({
    required this.day1,
    required this.day2,
    required this.time1,
    required this.time2,
  });
}
