import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_classroom/components/theme.dart';
import 'package:the_classroom/extras/constants.dart';
import 'package:the_classroom/screens/group_chat/create_group/add_members.dart';
import 'package:the_classroom/screens/group_chat/group_chat_room.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  List groupList = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAvailableGroups();
  }

  void getAvailableGroups() async {
    String uid = _auth.currentUser!.uid;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
    print(groupList);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getAppTheme(context),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
          title: Text('Groups'),
        ),
        body: isLoading
            ? Container(
                decoration: const BoxDecoration(
                    color: kTextWhiteColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(kDefaultPadding * 1.5),
                        topRight: Radius.circular(kDefaultPadding * 1.5))),
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              )
            : Container(
                child: Container(
                  decoration: const BoxDecoration(
                      color: kTextWhiteColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(kDefaultPadding * 1.5),
                          topRight: Radius.circular(kDefaultPadding * 1.5))),
                  child: ListView.builder(

                      itemCount: groupList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Column(
                            children: [
                              kHalfSizedBox,
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => GroupChatRoom(
                                                  groupChatId: groupList[index]['id'],
                                                  groupChatName: groupList[index]
                                                      ['name'],
                                                )));
                                  },
                                  leading: Icon(
                                    Icons.group,
                                    color: kTextLightColor,
                                  ),
                                  title: Text(
                                    groupList[index]['name'],
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.w500),
                                  ),

                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:kDefaultPadding),
                                child: const Divider(thickness: 2,color: kTextLightColor,),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          child: Icon(
            Icons.create,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => AddMembersInGroup()));
          },
          tooltip: "Create Group",
        ),
      ),
    );
  }
}
