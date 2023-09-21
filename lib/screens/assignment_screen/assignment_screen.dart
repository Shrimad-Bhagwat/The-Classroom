import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:the_classroom/components/theme.dart';
import 'package:the_classroom/components/toast.dart';
import 'package:the_classroom/extras/constants.dart';
import 'package:the_classroom/screens/assignment_screen/data/assignment_data.dart';

import '../my_profile/my_profile.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final _currentUser = _auth.currentUser;

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  static String routeName = "AssignmentScreen";

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  final ref = FirebaseDatabase.instance
      .ref('users/${_currentUser!.uid}_$customUID/assignments');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getAppTheme(context),
      home: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
          title: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Assignments'),
                kHalfSizedBox,
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              // White space
              child: Container(
                decoration: const BoxDecoration(
                  color: kTextWhiteColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(kDefaultPadding),
                    topLeft: Radius.circular(kDefaultPadding),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: kDefaultPadding),
                  child: FirebaseAnimatedList(
                    query: ref,
                    padding: const EdgeInsets.all(kDefaultPadding),
                    duration: const Duration(milliseconds: 300),
                    // Skeleton Loading
                    defaultChild: const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        LoadingAssignment(),
                        LoadingAssignment(),
                        LoadingAssignment(),
                      ],
                    ),

                    // Actual data loading
                    itemBuilder: (context, snapshot, animation, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: kDefaultPadding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(kDefaultPadding),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(kDefaultPadding),
                                color: kOtherColor,
                                boxShadow: const [
                                  BoxShadow(
                                      color: kTextLightColor, blurRadius: 2.0)
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 30.0,
                                    decoration: BoxDecoration(
                                        color: kSecondaryColor.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(
                                            kDefaultPadding)),
                                    child: Center(
                                      child: Text(
                                        // assignment[index].subjectName,
                                        snapshot
                                            .child('subjectName')
                                            .value
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w400,
                                            color: kPrimaryColor),
                                      ),
                                    ),
                                  ),
                                  kHalfSizedBox,
                                  Text(
                                    // assignment[index].topicName,
                                    snapshot
                                        .child('topicName')
                                        .value
                                        .toString(),
                                    style: const TextStyle(
                                        color: kTextBlackColor,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  kHalfSizedBox,
                                  AssignmentDetailsRow(
                                    title: 'Assign Date',
                                    statusValue: snapshot
                                        .child('assignDate')
                                        .value
                                        .toString(),
                                  ),
                                  kHalfSizedBox,
                                  AssignmentDetailsRow(
                                    title: 'Last Date',
                                    statusValue: snapshot
                                        .child('lastDate')
                                        .value
                                        .toString(),
                                  ),
                                  kHalfSizedBox,
                                  AssignmentDetailsRow(
                                    title: 'Status',
                                    statusValue: snapshot
                                        .child('status')
                                        .value
                                        .toString(),
                                  ),
                                  kHalfSizedBox,
                                  if (snapshot
                                          .child('status')
                                          .value
                                          .toString() ==
                                      'Pending')
                                    AssignmentButton(
                                      title: 'To Be Submitted',
                                      onPress: () {
                                        // submit assignment
                                        showToast('Assignment Submitted');
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AssignmentDetailsRow extends StatelessWidget {
  const AssignmentDetailsRow(
      {super.key, required this.title, required this.statusValue});

  final String title, statusValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: kTextLightColor,
          ),
        ),
        Text(
          statusValue,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: kTextBlackColor,
          ),
        ),
      ],
    );
  }
}

class AssignmentButton extends StatelessWidget {
  const AssignmentButton(
      {super.key, required this.title, required this.onPress});

  final String title;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: double.infinity,
        height: 40.0,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(kDefaultPadding),
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: kOtherColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
          ),
        ),
      ),
    );
  }
}

class LoadingBox extends StatelessWidget {
  const LoadingBox({super.key, this.height, this.width});

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius:
              const BorderRadius.all(Radius.circular(kDefaultPadding))),
    );
  }
}

class LoadingAssignment extends StatelessWidget {
  const LoadingAssignment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(kDefaultPadding),
      padding: const EdgeInsets.all(kDefaultPadding),
      height: 180,
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(kDefaultPadding),
        color: kOtherColor,
        boxShadow: const [
          BoxShadow(color: kTextLightColor, blurRadius: 2.0)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingBox(height: 25.0, width: 120.0),
                kHalfSizedBox,
                LoadingBox(height: 25.0, width: 150.0),
                kHalfSizedBox,
                LoadingBox(
                    height: 60.0, width: double.infinity),
              ],
            ),
          ),
          kHalfSizedBox,
        ],
      ),
    );
  }
}
