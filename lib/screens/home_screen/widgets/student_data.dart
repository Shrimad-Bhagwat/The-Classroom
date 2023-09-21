import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../extras/constants.dart';
import '../../my_profile/my_profile.dart';
import '../home_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User? _currentUser;

class StudentName extends StatelessWidget {
  const StudentName({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Hi ",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(
              fontWeight: FontWeight.w200,
              color: kTextWhiteColor,
              fontSize: 20.0),
        ),
        Text(
          // "User",
          user!.displayName.toString(), // get myName from database
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(
              fontWeight: FontWeight.w800,
              color: kTextWhiteColor,
              fontSize: 22.0),
        ),
      ],
    );
  }
}
class StudentClass extends StatelessWidget {
  const StudentClass({super.key, required this.studentClass});
  final String studentClass;
  @override
  Widget build(BuildContext context) {
    return Text(
      studentClass,
      style: Theme.of(context)
          .textTheme
          .titleSmall!
          .copyWith(
          fontSize: 16.0, color: kTextWhiteColor),
    );
  }
}
class StudentYear extends StatelessWidget {
  const StudentYear({super.key, required this.studentYear});
  final String studentYear;
  @override
  Widget build(BuildContext context) {
    return Text(
      studentYear,
      style: Theme.of(context)
          .textTheme
          .titleSmall!
          .copyWith(
          fontSize: 16.0, color: kTextWhiteColor),
    );
  }
}
class StudentProfile extends StatelessWidget {
  const StudentProfile({super.key, required this.profilePic, required this.onPress});
  final String profilePic;
  final VoidCallback onPress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: CircleAvatar(
        maxRadius: 80.0,
        minRadius: 60.0,
        backgroundColor: kSecondaryColor,
        backgroundImage:
        AssetImage(profilePic),
      ),
    );
  }
}
