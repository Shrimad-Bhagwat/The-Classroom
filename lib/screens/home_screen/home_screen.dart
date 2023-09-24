import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_classroom/screens/assignment_screen/assignment_screen.dart';
import 'package:the_classroom/screens/chat_app/chat_page.dart';
import 'package:the_classroom/screens/datesheet_screen/datesheet_screen.dart';
import 'package:the_classroom/screens/home_screen/widgets/student_data.dart';
import 'package:the_classroom/screens/my_profile/my_profile.dart';
import 'package:the_classroom/screens/result_screen/result_screen.dart';

import '../../components/notices.dart';
import '../../components/theme.dart';
import '../../extras/constants.dart';
import 'package:the_classroom/components/toast.dart';

import '../login_screen/registration_screen.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;
final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
String? degree=" ", course=" ", acadYear=" ";

// Custom UID
String myemail = user!.email.toString();
String? customUID = myemail.split("@")[0];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = 'HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ref = FirebaseDatabase.instance.ref('notices');

  String? degree=" ", course=" ", acadYear=" ";


  Future<void> updateText() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    if (user != null) {
      final snapshot =
          await ref.child('users/${user!.uid}_$customUID/data').get();
      if (snapshot.exists) {
        setState(() {
        acadYear = snapshot.child('acad_year').value.toString();
        degree = snapshot.child('degree').value.toString();
        course = snapshot.child('course').value.toString();
        });
        print('$acadYear $degree  $course');
      } else {
        showToastError('Data Not Found!');
      }
    } else {
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // storeNoticeData();
    fetchNoticeData();
    updateText();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: getAppTheme(context),
        home: Scaffold(
          body: Column(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                       Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          kHalfSizedBox,
                          StudentName(),
                          kHalfSizedBox,
                          StudentClass(
                              studentClass: 'VIT BHOPAL | $degree $course'),
                          kHalfSizedBox,
                          StudentYear(studentYear: "$acadYear"),
                        ],
                      ),
                      StudentProfile(
                          profilePic: 'assets/images/student_profile.jpg',
                          onPress: () {
                            // go to profile details screen
                            print('Profile clicked');

                            // showToast(user!.email.toString());
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const MyProfileScreen(),
                              ),
                            );
                          }),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
                child: Container(
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: kOtherColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(kDefaultPadding * 2),
                    topRight: Radius.circular(kDefaultPadding * 2),
                  ),
                ),
                child: Column(children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Text('Notifications',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w800,
                          color: kTextBlackColor,
                          fontSize: 22.0)),
                  const SizedBox(
                    height: 8,
                  ),
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        height: 160,
                        child: FirebaseAnimatedList(
                          scrollDirection: Axis.horizontal,
                          query: ref,
                          itemBuilder: (context, snapshot, animation, index) {
                            Set<String> uniqueKeys = Set();
                            return Row(
                              children: notices.where((notice) {
                                String key = snapshot.key.toString();
                                bool isUnique = uniqueKeys.add(key);
                                return isUnique;
                              }).map((notice) {
                                return Card(
                                  color: kSecondaryColor,
                                  margin: const EdgeInsets.all(16.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 2.6,
                                    height: 200,
                                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                                    child: ListTile(
                                      title: Text(snapshot
                                          .child('title')
                                          .value
                                          .toString()),
                                      subtitle: Text(snapshot
                                          .child('content')
                                          .value
                                          .toString()),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                      Container(
                          alignment: Alignment.topCenter,
                          height: MediaQuery.of(context).size.height / 2.5,
                          child: ListView(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  XCards(
                                      onPress: () {
                                        debugPrint('Assignment');
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                const AssignmentScreen(),
                                          ),
                                        );
                                      },
                                      icon: 'assets/icons/assignment.svg',
                                      xtext: 'Assignment'),
                                  XCards(
                                      onPress: () {
                                        debugPrint('Chats');
                                        // showToast("${user!.uid} ${_auth.currentUser!.email}");

                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) => ChatPage()));
                                      },
                                      icon: 'assets/icons/chat.svg',
                                      xtext: 'Chats'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  XCards(
                                      onPress: () {
                                        debugPrint('Datesheet');
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                            const DateSheetScreen(),
                                          ),
                                        );
                                      },
                                      icon: 'assets/icons/datesheet.svg',
                                      xtext: 'Datesheet'),
                                  XCards(
                                      onPress: () {
                                        debugPrint('Result');
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                const ResultScreen(),
                                          ),
                                        );
                                      },
                                      icon: 'assets/icons/result.svg',
                                      xtext: 'Result'),
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                ]),
              ),
            ))
          ]),
        ));
  }
}

class XCards extends StatelessWidget {
  const XCards(
      {Key? key,
      required this.onPress,
      required this.icon,
      required this.xtext})
      : super(key: key);
  final VoidCallback onPress;
  final String icon;
  final String xtext;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width / 2.5,
        height: MediaQuery.of(context).size.height / 7,
        decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            SvgPicture.asset(
              icon,
              height: 40,
              width: 40,
              color: kOtherColor,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              xtext,
              style: TextStyle(color: kOtherColor, fontSize: 24),
            )
          ],
        ),
      ),
    );
  }
}
