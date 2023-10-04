import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_classroom/screens/group_chat/create_group/create_group.dart';
import 'package:the_classroom/screens/home_screen/home_screen.dart';

import '../../../components/theme.dart';
import '../../../components/toast.dart';
import '../../../extras/constants.dart';

class AddMembersInGroup extends StatefulWidget {
  const AddMembersInGroup({super.key});

  @override
  State<AddMembersInGroup> createState() => _AddMembersInGroupState();
}

class _AddMembersInGroupState extends State<AddMembersInGroup> {
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _search = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Map<String, dynamic>> memberList = [];
  Map<String, dynamic>? userMap;

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
    print(memberList);
  }

  void getCurrentUserDetails() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((map) {
      setState(() {
        memberList.add({
          "name": map['name'],
          "email": map['email'],
          "uid": map['uid'],
          "isAdmin": true,
        });
      });
    });
  }

  // Search function for users
  void onSearch() async {
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text.toLowerCase())
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        setState(() {
          userMap = value.docs[0].data();
          isLoading = false;
        });
        print(userMap);
      } else {
        showToast('No User found!');
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void onResultTap() {
    bool isAlreadyMember = false;
    for (int i = 0; i < memberList.length; i++) {
      if (memberList[i]['uid'] == userMap!['uid']) {
        isAlreadyMember = true;
      }
    }
    if (!isAlreadyMember) {
      setState(() {
        memberList.add({
          "name": userMap!['name'],
          "email": userMap!['email'],
          "uid": userMap!['uid'],
          "isAdmin": false,
        });
        userMap = null;
      });
    } else {
      showToast("User already added!");
    }
  }

  void onRemoveMembers(int index) {
    if (memberList[index]['uid'] != _auth.currentUser!.uid) {
      setState(() {
        memberList.removeAt(index);
      });
    }
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
          title: const Text('Add Members'),
        ),
        body: Container(
          height: size.height,
          decoration: const BoxDecoration(
              color: kTextWhiteColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(kDefaultPadding * 1.5),
                  topRight: Radius.circular(kDefaultPadding * 1.5))),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                kHalfSizedBox,
                Flexible(
                  child: ListView.builder(
                    itemCount: memberList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () => onRemoveMembers(index),
                        leading: const Icon(
                          Icons.account_circle,
                          color: kTextLightColor,
                        ),
                        title: Text(memberList[index]['name']),
                        subtitle: Text(memberList[index]['email']),
                        trailing: const Icon(
                          Icons.close,
                          color: kTextLightColor,
                        ),
                      );
                    },
                  ),
                ),
                kHalfSizedBox,
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.15,
                    child: TextField(
                      focusNode: _focusNode,
                      controller: _search,
                      style:
                          const TextStyle(color: kTextBlackColor, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: "Search",
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
                  onPressed: onSearch,
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                            )
                          : const Text(
                              "Search",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ],
                  ),
                ),
                userMap != null
                    ? ListTile(
                        onTap: onResultTap,
                        leading: const Icon(
                          Icons.account_circle,
                          color: kTextLightColor,
                        ),
                        title: Text(userMap!['name']),
                        subtitle: Text(userMap!['email']),
                        trailing: const Icon(
                          Icons.add,
                          color: kTextLightColor,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
        floatingActionButton: memberList.length >= 2
            ? FloatingActionButton(
                backgroundColor: kPrimaryColor,
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => CreateGroup(memberList: memberList,)));
                },
                child: const Icon(
                  Icons.forward,
                  color: kTextWhiteColor,
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}
