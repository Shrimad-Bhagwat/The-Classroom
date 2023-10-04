import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_classroom/screens/chat_app/chat_page.dart';
import 'package:the_classroom/screens/chat_screen/chat_screen.dart';
import 'package:the_classroom/screens/home_screen/home_screen.dart';
import 'package:uuid/uuid.dart';

import '../../../components/theme.dart';
import '../../../extras/constants.dart';

class CreateGroup extends StatefulWidget {
  final List<Map<String, dynamic>> memberList;

  const CreateGroup({required this.memberList, super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  bool isLoading = false;
  final TextEditingController _groupName = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void createGroup() async {
    String groupId = Uuid().v1();
    setState(() {
      isLoading = true;
    });
    await _firestore.collection('groups').doc(groupId).set({
      "members": widget.memberList,
      "id": groupId,
      "groupName": _groupName.text,
    });

    for (int i = 0; i < widget.memberList.length; i++) {
      String uid = widget.memberList[i]['uid'];
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(groupId)
          .set({
        "name": _groupName.text,
        "id": groupId,
      });
    }

    await _firestore.collection('groups').doc(groupId).collection('chats').add({
      "message": "${_auth.currentUser!.displayName} Created this group.",
      "type": "notify",
      "time" : FieldValue.serverTimestamp(),
    });

    var count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getAppTheme(context),
      home: Scaffold(
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
          height: size.height,
          decoration: const BoxDecoration(
              color: kTextWhiteColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(kDefaultPadding * 1.5),
                  topRight: Radius.circular(kDefaultPadding * 1.5))),
          child: Column(
            children: [
              SizedBox(
                height: size.height / 20,
              ),
              Container(
                height: size.height / 14,
                width: size.width,
                alignment: Alignment.center,
                child: Container(
                  height: size.height / 14,
                  width: size.width / 1.15,
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _groupName,
                    style:
                        const TextStyle(color: kTextBlackColor, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: "Enter Group Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 50,
              ),
              ElevatedButton(
                onPressed: createGroup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSecondaryColor,
                  foregroundColor: kTextBlackColor,
                  elevation: 0,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    isLoading
                        ? const Positioned(
                            child: SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          )
                        : const Text(
                            "Create Group",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
