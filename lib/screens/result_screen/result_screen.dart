import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:the_classroom/components/theme.dart';
import 'package:the_classroom/components/toast.dart';
import 'package:the_classroom/screens/assignment_screen/assignment_screen.dart';
import 'package:the_classroom/screens/result_screen/components/result_component.dart';
import 'package:the_classroom/screens/result_screen/data/result_data.dart';

import '../../extras/constants.dart';
import 'package:collection/collection.dart';

import '../my_profile/my_profile.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final _currentUser = _auth.currentUser;

Future<void> fetchResultData() async {
  final ref = FirebaseDatabase.instance
      .ref('users/${_currentUser!.uid}_$customUID/result');

  final dataSnapshot = await ref.get();

  // Clear the existing data in the result list.
  result.clear();

  if (dataSnapshot.value != null) {
    // Convert the Firebase data to a Map.
    Map<dynamic, dynamic> data = dataSnapshot.value as Map<dynamic, dynamic>;
    print(data);
    // Loop through the data and create ResultData objects.
    data.forEach((key, value) {
      ResultData resultData = ResultData(
        value['subjectName'],
        value['totalMarks'],
        value['obtainedMarks'],
        value['grade'],
      );
      result.add(resultData);
    });

  }
}


class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  static String routeName = "ResultScreen";

  @override
  State<ResultScreen> createState() => _ResultScreenState();

}
// List<ResultData> result= [];
int oMarks=-1, tMarks=-1;
class _ResultScreenState extends State<ResultScreen> {
  final ref = FirebaseDatabase.instance
      .ref('users/${_currentUser!.uid}_$customUID/result');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchResultData();
    oMarks = result.map((e) => e.obtainedMarks).sum.toInt();
    tMarks = result.map((e) => e.totalMarks).sum.toInt();
  }

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
                Text('Result'),
                kHalfSizedBox,
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            // Circle

            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              margin: EdgeInsets.all(10.0),
              child: CustomPaint(
                foregroundPainter: CircularPainter(
                    backgroundColor: kPrimaryColor,
                    lineColor: kOtherColor,
                    width: 20.0),
                child: Center(
                  child: Text(
                    '$oMarks / $tMarks',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: kTextWhiteColor, fontSize: 20.0),
                  ),
                ),
              ),
            ),
            sizedBox,
            Text(
              'You are excellent',
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: kTextWhiteColor,
                  ),
            ),
            Text(
              _currentUser!.displayName.toString(),
              // 'Your Name',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: kTextWhiteColor),
            ),
            sizedBox,
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(kDefaultPadding),
                      topRight: Radius.circular(kDefaultPadding),
                    ),
                    color: kOtherColor),
                child: FirebaseAnimatedList(
                    query: ref,
                    padding: const EdgeInsets.all(kDefaultPadding),
                    duration: const Duration(milliseconds: 300),
                    // Skeleton Loading
                    defaultChild: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(kDefaultPadding),
                            topRight: Radius.circular(kDefaultPadding),
                          ),
                          color: kOtherColor),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: kTextWhiteColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(kDefaultPadding),
                            topLeft: Radius.circular(kDefaultPadding),
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            kHalfSizedBox,
                            ResultSkeleton(),
                            ResultSkeleton(),
                            ResultSkeleton(),
                          ],
                        ),
                      ),
                    ),
                    itemBuilder: (context, snapshot, animation, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: kDefaultPadding),
                        padding: const EdgeInsets.all(kDefaultPadding / 2),
                        decoration: const BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(kDefaultPadding)),
                            boxShadow: [
                              BoxShadow(color: kTextLightColor, blurRadius: 2.0)
                            ]),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  snapshot
                                      .child('subjectName')
                                      .value
                                      .toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: kTextWhiteColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${snapshot.child('obtainedMarks').value.toString()} / ${snapshot.child('totalMarks').value.toString()}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(color: kTextWhiteColor),
                                    ),
                                    Stack(
                                      children: [
                                        Container(
                                          width: double.parse(snapshot
                                              .child('totalMarks')
                                              .value
                                              .toString()),
                                          height: 15.0,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[700],
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(kDefaultPadding),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.parse(snapshot
                                              .child('obtainedMarks')
                                              .value
                                              .toString()),
                                          height: 15.0,
                                          decoration: BoxDecoration(
                                            color: snapshot
                                                        .child('grade')
                                                        .value
                                                        .toString() ==
                                                    'D'
                                                ? kErrorBorderColor
                                                : kTextWhiteColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(kDefaultPadding),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      snapshot.child('grade').value.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(color: kTextWhiteColor),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultSkeleton extends StatelessWidget {
  const ResultSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      margin: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: const BorderRadius.all(Radius.circular(kDefaultPadding)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LoadingBox(height: 25, width: 100),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              LoadingBox(height: 20, width: 60),
              kHalfSizedBox,
              LoadingBox(height: 20, width: 120),
              kHalfSizedBox,
              LoadingBox(height: 20, width: 30),
            ],
          )
        ],
      ),
    );
  }
}
