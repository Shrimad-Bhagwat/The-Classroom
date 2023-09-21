import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:the_classroom/screens/datesheet_screen/datesheet_data/datesheet_data.dart';

import '../../components/notices.dart';
import '../../components/theme.dart';
import '../../extras/constants.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final _currentUser = _auth.currentUser;

// Future<void> fetchDateSheetData() async {
//   final ref = FirebaseDatabase.instance
//       .ref('users/${_currentUser!.uid}_$customUID/datesheet');
//
//   final dataSnapshot = await ref.get();
//
//   // Clear the existing data in the result list.
//   dateSheet.clear();
//
//   if (dataSnapshot.value != null) {
//     // Convert the Firebase data to a Map.
//     Map<dynamic, dynamic> data = dataSnapshot.value as Map<dynamic, dynamic>;
//     print(data);
//     // Loop through the data and create ResultData objects.
//     data.forEach((key, value) {
//       ResultData resultData = ResultData(
//         value['subjectName'],
//         value['totalMarks'],
//         value['obtainedMarks'],
//         value['grade'],
//       );
//       result.add(resultData);
//     });
//
//   }
// }

class DateSheetScreen extends StatefulWidget {
  static String routeName = "DateSheetScreen";

  const DateSheetScreen({super.key});

  @override
  State<DateSheetScreen> createState() => _DateSheetScreenState();
}

class _DateSheetScreenState extends State<DateSheetScreen> {
  final ref = FirebaseDatabase.instance.ref('datesheet');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchDateSheetData();
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
                Text('DateSheet'),
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
                  color: kOtherColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(kDefaultPadding),
                      topRight: Radius.circular(kDefaultPadding)),
                ),
                child: FirebaseAnimatedList(
                    scrollDirection: Axis.vertical,
                    query: ref,
                    itemBuilder: (context, snapshot, animation, index) {
                      return DateSheetData(
                        date: snapshot.child('date').value.toString(),
                        monthName: snapshot.child('monthName').value.toString(),
                        subjectName: snapshot.child('subjectName').value.toString(),
                        dayName: snapshot.child('dayName').value.toString(),
                        time: snapshot.child('time').value.toString(),

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

class DateSheetData extends StatefulWidget {
  const DateSheetData({super.key, required this.date, required this.monthName, required this.subjectName, required this.dayName, required this.time});
  final String date;
  final String monthName, subjectName, dayName, time;

  @override
  State<DateSheetData> createState() => _DateSheetDataState();
}

class _DateSheetDataState extends State<DateSheetData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(kDefaultPadding / 3),
      margin: const EdgeInsets.only(
          left: kDefaultPadding, right: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: kDefaultPadding,
            child: Divider(
              thickness: 1.0,
              color: Color.fromARGB(100, 190, 190, 190),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Date Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.date.toString(),
                    style: const TextStyle(
                        color: kTextBlackColor,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.monthName,
                    style: const TextStyle(
                        color: kTextBlackColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),

              // Subject Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.subjectName,
                    style: const TextStyle(
                        color: kTextBlackColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    widget.dayName,
                    style: const TextStyle(
                        color: kTextLightColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),

              // Time Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.time,
                    style: const TextStyle(
                        color: kTextLightColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: kDefaultPadding,
            child: Divider(
              thickness: 1.0,
              color: Color.fromARGB(100, 190, 190, 190),
            ),
          ),
        ],
      ),
    );
  }
}
