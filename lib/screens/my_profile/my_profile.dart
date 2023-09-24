import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_classroom/components/notices.dart';
import 'package:the_classroom/components/toast.dart';
import 'package:the_classroom/extras/constants.dart';
import 'package:the_classroom/screens/login_screen/login_screen.dart';
import 'package:the_classroom/screens/my_profile/data/profile_data.dart';

import '../../components/theme.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

final FirebaseAuth _auth = FirebaseAuth.instance;
final _currentUser = _auth.currentUser;
final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();



// Custom UID
String myemail = _currentUser!.email.toString();

// final pattern = RegExp(r'[!@#\$%^&*()_+{}\[\]:;<>,.?/~\\-]');
// String? customUID = myemail?.replaceAll(pattern, "_");
String? customUID = myemail.split("@")[0];

void storeData() {
  if (_currentUser != null) {
    // showToast(customUID.toString());
    // String assignmentId = DateTime.now().microsecondsSinceEpoch.toString();
    // String datesheetId = DateTime.now().microsecondsSinceEpoch.toString();

    // databaseReference.child('datesheet/$datesheetId').set({
    databaseReference.child('users/${_currentUser!.uid}_$customUID/data').set({
      // == DateSheet ==
      // 'id' :  DateTime.now().microsecondsSinceEpoch.toString(),
      // 'date' : 26,
      // 'monthName' : 'Sep',
      // 'subjectName' : 'Biology',
      // 'dayName' : 'Tuesday',
      // 'time' : '10:15 am'


      // == Result ==
      // 'id' : DateTime.now().microsecondsSinceEpoch.toString(),
      // 'subjectName' : 'Maths',
      // 'grade' : 'B',
      // 'totalMarks' : 100 ,
      // 'obtainedMarks' : 85,


      // == Assignment ==
      // 'id' : DateTime.now().microsecondsSinceEpoch.toString(),
      // 'subjectName' : 'Mathematics',
      // 'topicName' : 'Algebra',
      // 'assignDate' : '12 Aug 2023',
      // 'lastDate' : '19 Dec 2023',
      // 'status' : 'Pending',

      // == User ==
      'id': DateTime.now().microsecondsSinceEpoch.toString(),
      'email': _currentUser!.email.toString(),
      'name': 'Test',
      'class': 'XII-C',
      'roll_no': '25',
      'reg_no': '20BCE10001',
      'acad_year': '2023-24',
      'degree': 'B.TECH',
      'course': 'CS',
      'specialization': 'CORE',
      'dob': '04-05-2004',
      'father_name': 'XYZ',
      'phone': '7788996654',

    });
  }
}

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  static String routeName = 'MyProfileScreen';

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String nameText = '';
  String rollNoText = '';
  String regNoText = '';
  String acadYearText = '';
  String degreeText = '';
  String classText = '';
  String courseText = '';
  String specializationText = '';
  String dobText = '';
  String fatherNameText = '';
  String phoneText = '';
  String emailText = '';

  @override
  void initState() {
    super.initState();
    // getData();
    fetchData();
    // showToast(myemail);
  }

  bool isLoading = true;

  clearData() {
    setState(() {
      nameText = '';
      classText = '';
      rollNoText = '';
      regNoText = '';
      acadYearText = '';
      degreeText = '';
      courseText = '';
      specializationText = '';
      dobText = '';
      fatherNameText = '';
      phoneText = '';
      emailText = '';
    });
  }
  //  Future<void> getData() async{
  //    Map<dynamic, dynamic> data = fetchData() as Map;
  //   nameText = data['name'];
  //   showToast("Data $nameText");
  //   classText = data['class'];
  //   rollNoText = data['roll_no'];
  //   regNoText = data['reg_no'];
  //   acadYearText = data['acad_year'];
  //   degreeText = data['degree'];
  //   courseText = data['course'];
  //   specializationText =
  //       data['specialization'];
  //   dobText = data['dob'];
  //   fatherNameText = data['father_name'];
  //   phoneText = data['phone'];
  //   emailText = data['email'];
  // }
  Future<void> fetchData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    if (_currentUser != null) {
      final snapshot =
          await ref.child('users/${_currentUser!.uid}_$customUID/data').get();
      if (snapshot.exists) {
        setState(() {
          nameText = snapshot.child('name').value.toString();
          // print("User name $nameText");
          _currentUser?.updateDisplayName(nameText);
          classText = snapshot.child('class').value.toString();
          rollNoText = snapshot.child('roll_no').value.toString();
          regNoText = snapshot.child('reg_no').value.toString();
          acadYearText = snapshot.child('acad_year').value.toString();

          degreeText = snapshot.child('degree').value.toString();

          courseText = snapshot.child('course').value.toString();

          specializationText =
              snapshot.child('specialization').value.toString();
          dobText = snapshot.child('dob').value.toString();
          fatherNameText = snapshot.child("father_name").value.toString();
          phoneText = snapshot.child('phone').value.toString();
          emailText = snapshot.child('email').value.toString();

          isLoading = false;
        });
      } else {
        showToastError('No data available!');
        isLoading = false;
      }
    } else {
      showToastError('User not found!');
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getAppTheme(context),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('My Profile'),
              InkWell(
                child: const Icon(Icons.logout_rounded),
                onTap: () {
                  // retrieveUserData();
                  clearData();
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  showToastSuccess('Logout Success!');
                  // storeData();
                  // storeNoticeData();
                },
              )
            ],
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
        ),
        body: Container(
          color: kOtherColor,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(kDefaultPadding * 2),
                      bottomLeft: Radius.circular(kDefaultPadding * 2),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      maxRadius: 50.0,
                      minRadius: 50.0,
                      backgroundColor: kSecondaryColor,
                      backgroundImage:
                          AssetImage('assets/images/student_profile.jpg'),

                    ),
                    kWidthSizedBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          nameText,
                          style: const TextStyle(
                            color: kTextWhiteColor,
                            fontSize: 20.0,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          'Class $classText | Roll no. : $rollNoText',
                          style: const TextStyle(
                            color: kTextWhiteColor,
                            fontSize: 14.0,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w100,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              sizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProfileDetailRow(title: 'Registration no.', value: regNoText),
                  ProfileDetailRow(title: 'Academic Year', value: acadYearText),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ProfileDetailRow(title: 'Degree', value: degreeText),
                  ProfileDetailRow(title: 'Course', value: courseText),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ProfileDetailRow(
                      title: 'Specialization', value: specializationText),
                  ProfileDetailRow(title: 'Date of Birth', value: dobText),
                ],
              ),
              kHalfSizedBox,
              ProfileDetailColumn(
                title: "Father's Name",
                value: fatherNameText,
              ),
              ProfileDetailColumn(
                title: 'Phone',
                value: phoneText,
              ),
              ProfileDetailColumn(
                title: 'Email',
                value: emailText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  const ProfileDetailRow({super.key, required this.title, required this.value});

  final String title, value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          right: kDefaultPadding / 4,
          left: kDefaultPadding / 4,
          top: kDefaultPadding / 2),
      width: MediaQuery.of(context).size.width / 2,
      // color: kPrimaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: kTextLightColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0),
              ),
              kHalfSizedBox,
              Text(
                value,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: kTextBlackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0),
              ),
              kHalfSizedBox,
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: const Divider(
                  thickness: 1.0,
                  color: kTextLightColor,
                ),
              )
            ],
          ),
          const Icon(
            Icons.lock_outline_rounded,
            color: kTextLightColor,
            size: 20.0,
          )
        ],
      ),
    );
  }
}

class ProfileDetailColumn extends StatelessWidget {
  const ProfileDetailColumn({super.key, this.title, this.value});

  final title, value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: kDefaultPadding / 4, horizontal: kDefaultPadding),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: kTextLightColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0),
              ),
              kHalfSizedBox,
              Text(
                value,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: kTextBlackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0),
              ),
              // kHalfSizedBox,
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: const Divider(
                  thickness: 1.0,
                  color: kTextLightColor,
                ),
              )
            ],
          ),
          const Icon(
            Icons.lock_outline_rounded,
            color: kTextLightColor,
            size: 20.0,
          )
        ],
      ),
    );
  }
}
