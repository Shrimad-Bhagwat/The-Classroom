import 'package:flutter/material.dart';
import 'package:the_classroom/components/theme.dart';
import 'package:the_classroom/components/toast.dart';
import 'package:the_classroom/constants.dart';
import 'package:the_classroom/screens/assignment_screen/data/assignment_data.dart';

class AssignmentScreen extends StatelessWidget {
  const AssignmentScreen({super.key});

  static String routeName = "AssignmentScreen";

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
              child: Container(
                decoration: const BoxDecoration(
                  color: kTextWhiteColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(kDefaultPadding),
                    topLeft: Radius.circular(kDefaultPadding),
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  itemCount: assignment.length,
                  itemBuilder: (context, int index) {
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
                                      assignment[index].subjectName,
                                      style: const TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w400,
                                          color: kPrimaryColor),
                                    ),
                                  ),
                                ),
                                kHalfSizedBox,
                                Text(
                                  assignment[index].topicName,
                                  style: const TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                kHalfSizedBox,
                                AssignmentDetailsRow(
                                  title: 'Assign Date',
                                  statusValue: assignment[index].assignDate,
                                ),
                                kHalfSizedBox,
                                AssignmentDetailsRow(
                                  title: 'Lasr Date',
                                  statusValue: assignment[index].lastDate,
                                ),
                                kHalfSizedBox,
                                AssignmentDetailsRow(
                                  title: 'Status',
                                  statusValue: assignment[index].status,
                                ),
                                kHalfSizedBox,
                                if (assignment[index].status == 'Pending')
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
