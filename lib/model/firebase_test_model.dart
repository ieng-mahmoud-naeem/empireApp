// import '../constants.dart';

// class FirebaseTestModel {
//   final String? email, name, rool;
//   final dynamic parentNumber, studentNumber;
//   final dynamic password;

//   FirebaseTestModel({
//     required this.email,
//     required this.name,
//     required this.rool,
//     this.parentNumber,
//     this.studentNumber,
//     this.password,
//   });
//   factory FirebaseTestModel.fromJson(jsonData) {
//     return FirebaseTestModel(
//       email: jsonData['email'],
//       name: jsonData['name'],
//       rool: jsonData['rool'],
//       parentNumber: jsonData['parentNumber'],
//       studentNumber: jsonData['parentNumber'],
//       password: jsonData['password'],
//     );
//   }
// }

// class GetFirebaseDataTesting {
//   Future<List<FirebaseTestModel>> getData() async {
//     var get1 = await kFs.collection('users').get();
//     List<FirebaseTestModel> firebaseModel = [];
//     for (var doc in get1.docs) {
//       FirebaseTestModel addlist = FirebaseTestModel.fromJson(doc);
//       firebaseModel.add(addlist);
//     }

//     return firebaseModel;
//   }
// }
