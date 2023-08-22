import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_classroom/components/toast.dart';
import 'package:the_classroom/constants.dart';
import 'package:the_classroom/screens/login_screen/login_screen.dart';

import '../../components/theme.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  static String routeName = 'MyProfileScreen';

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
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  showToastSuccess('Logout Success!');
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
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
                          'Your Name',
                          style: TextStyle(
                            color: kTextWhiteColor,
                            fontSize: 20.0,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          'Class XII A | Roll no. : 10',
                          style: TextStyle(
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProfileDetailRow(
                      title: 'Registration no.', value: '20BCG10000'),
                  ProfileDetailRow(
                      title: 'Academic Year', value: '2020 - 2024'),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ProfileDetailRow(title: 'Degree', value: 'B.Tech.'),
                  ProfileDetailRow(title: 'Course', value: 'CSE'),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ProfileDetailRow(title: 'Specialization', value: 'Gaming'),
                  ProfileDetailRow(title: 'Date of Birth', value: '01-01-2002'),
                ],
              ),
              kHalfSizedBox,
              const ProfileDetailColumn(
                title: "Father's Name",
                value: 'Father Name',
              ),
              const ProfileDetailColumn(
                title: 'Phone',
                value: '888889684',
              ),
              const ProfileDetailColumn(
                title: 'Email',
                value: 'test@gmail.com',
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
