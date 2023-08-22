import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_classroom/screens/assignment_screen/assignment_screen.dart';
import 'package:the_classroom/screens/chat_screen/chat_screen.dart';
import 'package:the_classroom/screens/home_screen/widgets/student_data.dart';
import 'package:the_classroom/screens/my_profile/my_profile.dart';

import '../../components/theme.dart';
import '../../constants.dart';

final List<Notice> notices = [
  Notice(
    title: 'Notice 1',
    content: 'This is the content of Notice 1',
  ),
  Notice(
    title: 'Notice 2',
    content: 'This is the content of Notice 2.',
  ),
  Notice(
    title: 'Notice 3',
    content: 'This is the content of Notice 3.',
  ),
];
final FirebaseAuth _auth = FirebaseAuth.instance;
User? _currentUser;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = 'HomeScreen';

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
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          kHalfSizedBox,
                          StudentName(),
                          kHalfSizedBox,
                          StudentClass(
                              studentClass: 'VIT BHOPAL | B.TECH. CSE'),
                          kHalfSizedBox,
                          StudentYear(studentYear: '2020-2024'),
                        ],
                      ),
                      StudentProfile(
                          profilePic: 'assets/images/student_profile.jpg',
                          onPress: () {
                            // go to profile details screen
                            print('Profile clicked');
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => const MyProfileScreen(),),);

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
                    topLeft: Radius.circular(kDefaultPadding * 3),
                    topRight: Radius.circular(kDefaultPadding * 3),
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
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          // Set the desired scroll direction here
                          child: Row(
                            children: notices.map((notice) {
                              return Card(
                                color: kSecondaryColor,
                                margin: EdgeInsets.all(16.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.6,
                                  height: 200,
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 8, 4, 8),
                                  // Set the desired width here
                                  child: ListTile(
                                    title: Text(notice.title),
                                    subtitle: Text(notice.content),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
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
                                        Navigator.push(context, CupertinoPageRoute(builder: (context) => const AssignmentScreen(),),);

                                      },
                                      icon: 'assets/icons/assignment.svg',
                                      xtext: 'Assignment'),
                                  XCards(
                                      onPress: () {
                                        debugPrint('Chats');
                                        // Navigator.pushNamedAndRemoveUntil(
                                        //     context,
                                        //     ChatScreen.routeName,
                                        //     (route) => false);
                                        Navigator.push(context, CupertinoPageRoute(builder: (context) => const ChatScreen()));
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
                                      },
                                      icon: 'assets/icons/datesheet.svg',
                                      xtext: 'Datesheet'),
                                  XCards(
                                      onPress: () {
                                        debugPrint('Result');
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

class Notice {
  final String title;
  final String content;

  Notice({required this.title, required this.content});
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
