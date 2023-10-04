import 'package:flutter/material.dart';
import 'package:the_classroom/components/theme.dart';
import 'package:the_classroom/extras/constants.dart';

class GroupInfo extends StatelessWidget {
  const GroupInfo({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getAppTheme(context),
      home: SafeArea(
        child: Scaffold(
            backgroundColor: kTextWhiteColor,
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios_new_outlined),
              ),
              title: Text('Group Name'),
            ),
            body: Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: size.height / 8,
                      width: size.width / 1.1,
                      child: Row(
                        children: [
                          kWidthSizedBox,
                          Container(
                            height: size.height / 8,
                            width: size.width / 8,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.grey),
                            child: const Icon(
                              Icons.group,
                              color: Colors.white,
                            ),
                          ),
                          kWidthSizedBox,
                          Expanded(
                            child: Container(
                              child: Text(
                                "Group Name",
                                style: TextStyle(
                                    fontSize: size.width / 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    kHalfSizedBox,
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Text(
                          "60 Members",
                          style: TextStyle(
                              fontSize: size.width / 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    kHalfSizedBox,

                    // Members Names
                    Flexible(
                      child: ListView.builder(
                        itemCount: 20,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(
                              Icons.account_circle,
                              color: kTextLightColor,
                            ),
                            title: Text(
                              "User1",
                              style: TextStyle(
                                  fontSize: size.width / 22,
                                  fontWeight: FontWeight.w500),
                            ),
                          );
                        },
                      ),
                    ),

                    ListTile(
                      onTap: (){},
                      leading: const Icon(
                        Icons.logout_outlined,
                        color: Colors.redAccent,
                      ),
                      title: Text(
                        "Leave Group",
                        style: TextStyle(
                            fontSize: size.width / 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.redAccent),
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
