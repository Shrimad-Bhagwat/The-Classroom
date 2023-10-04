import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_classroom/screens/home_screen/home_screen.dart';

import '../../components/theme.dart';
import '../../components/toast.dart';
import '../../extras/constants.dart';
import 'create_group/add_members.dart';
import 'create_group/create_group.dart';


// Search page for Adding the user
class AddMembers extends StatefulWidget {
  final String groupId, groupName;
  final List membersList;

  const AddMembers(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.membersList});

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _search = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List memberList = [];
  Map<String, dynamic>? userMap;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    memberList = widget.membersList;
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

  void onAddMembers() async {

    memberList.add({
      "name": userMap!['name'],
      "email": userMap!['email'],
      "uid": userMap!['uid'],
      "isAdmin": false,
    });
    await _firestore.collection('groups').doc(widget.groupId).update({
      "members": memberList,
    });

    await _firestore
        .collection('users')
        .doc(userMap!['uid'])
        .collection('groups')
        .doc(widget.groupId)
        .set({"name": widget.groupName, "id": widget.groupId});

    await _firestore.collection('groups').doc(widget.groupId).collection('chats').add(
        {
          "message" : "${_auth.currentUser!.displayName} added ${userMap!['name']}",
          "type" : "notify",
          "time" : FieldValue.serverTimestamp(),
        });

    var count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == 3;
    });

    showToast("User added");
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
                        onTap: onAddMembers,
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
      ),
    );
  }
}
