import 'package:flutter/material.dart';
import 'package:the_classroom/components/theme.dart';
import 'package:the_classroom/screens/result_screen/components/result_component.dart';
import 'package:the_classroom/screens/result_screen/data/result_data.dart';

import '../../constants.dart';
import 'package:collection/collection.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  static String routeName = "ResultScreen";

  @override
  Widget build(BuildContext context) {
    int oMarks = result.map((e) => e.obtainedMarks).sum.toInt();
    int tMarks = result.map((e) => e.totalMarks).sum.toInt();
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
                        .copyWith(
                        color: kTextWhiteColor,
                      fontSize: 20.0
                    ),
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
              'Your Name',
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
                child: ListView.builder(
                    padding: EdgeInsets.all(kDefaultPadding),
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: kDefaultPadding),
                        padding: EdgeInsets.all(kDefaultPadding / 2),
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
                                  result[index].subjectName,
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
                                      '${result[index].obtainedMarks} / ${result[index].totalMarks}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(color: kTextWhiteColor),
                                    ),
                                    Stack(
                                      children: [
                                        Container(
                                          width: result[index]
                                              .totalMarks
                                              .toDouble(),
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
                                          width: result[index]
                                              .obtainedMarks
                                              .toDouble(),
                                          height: 15.0,
                                          decoration: BoxDecoration(
                                            color: result[index].grade == 'D'
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
                                      result[index].grade,
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
