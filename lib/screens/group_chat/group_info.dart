import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_classroom/components/theme.dart';
import 'package:the_classroom/components/toast.dart';
import 'package:the_classroom/extras/constants.dart';
import 'package:the_classroom/screens/group_chat/add_members.dart';

class GroupInfo extends StatefulWidget {
  final String groupChatId, groupChatName;

  const GroupInfo(
      {super.key, required this.groupChatId, required this.groupChatName});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List memberList = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroupMembers();
  }

  bool checkAdmin() {
    bool isAdmin = false;

    memberList.forEach((element) {
      if (element['uid'] == _auth.currentUser!.uid) {
        isAdmin = element['isAdmin'];
      }
    });
    return isAdmin;
  }

  void getGroupMembers() async {
    await _firestore
        .collection('groups')
        .doc(widget.groupChatId)
        .get()
        .then((value) {
      setState(() {
        memberList = value['members'];
        isLoading = false;
      });
    });
  }

  void showRemoveDialog(int index) {
    if(checkAdmin()){
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              backgroundColor: kTextWhiteColor,
              content: ListTile(
                onTap: () {
                  removeUser(index);

                  },
                title: Text("Remove this member"),
              ),
            );
          });
    }

  }

  void removeUser(int index) async {
    if (checkAdmin()) {
      if (_auth.currentUser!.uid != memberList[index]['uid']) {
        setState(() {
          isLoading = true;
        });
        String uid = memberList[index]['uid'];
        memberList.removeAt(index);

        await _firestore.collection('groups').doc(widget.groupChatId).update({
          "members": memberList,
        });

        await _firestore
            .collection('users')
            .doc(uid)
            .collection('groups')
            .doc(widget.groupChatId)
            .delete();
        setState(() {
          isLoading = false;
        });
      }
    } else {
      showToastError("Cannot remove Admin");
    }
  }

  void onLeaveGroup() async {
    if (!checkAdmin()) {
      setState(() {
        isLoading = true;
      });
      String uid = _auth.currentUser!.uid;

      for (int i = 0; i < memberList.length; i++) {
        if (memberList[i]['uid'] == uid) {
          memberList.removeAt(i);
        }
      }
      await _firestore.collection('groups').doc(widget.groupChatId).update({
        "members": memberList,
      });

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(widget.groupChatId)
          .delete();

      setState(() {
        isLoading = false;
      });
      var count = 0;
      Navigator.popUntil(context, (route) {
        return count++ == 2;
      });
    }
  }

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
              title: Text(""),
            ),
            body: Container(
              child: isLoading
                  ? Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
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
                                      shape: BoxShape.circle,
                                      color: Colors.grey),
                                  child: const Icon(
                                    Icons.group,
                                    color: Colors.white,
                                  ),
                                ),
                                kWidthSizedBox,
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      widget.groupChatName,
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
                                "${memberList.length} Members",
                                style: TextStyle(
                                    fontSize: size.width / 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          kHalfSizedBox,
                          ListTile(
                            onTap: () => checkAdmin() ? Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => AddMembers(
                                        groupId: widget.groupChatId,
                                        groupName: widget.groupChatName,
                                      membersList: memberList,
                                    ))) : null,
                            leading: const Icon(
                              Icons.add,
                              color: kTextLightColor,
                            ),
                            title: Text(
                              "Add Members",
                              style: TextStyle(
                                  fontSize: size.width / 22,
                                  fontWeight: FontWeight.w500,
                                  color: kTextLightColor),
                            ),
                          ),

                          // Members Names
                          Flexible(
                            child: ListView.builder(
                              itemCount: memberList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () => showRemoveDialog(index),
                                  leading: Icon(
                                    Icons.account_circle,
                                    color: kTextLightColor,
                                  ),
                                  title: Text(
                                    memberList[index]['name'],
                                    style: TextStyle(
                                        fontSize: size.width / 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(memberList[index]['email']),
                                  trailing: memberList[index]['isAdmin']
                                      ? Text('Admin')
                                      : Text(""),
                                );
                              },
                            ),
                          ),

                          ListTile(
                            onTap: onLeaveGroup,
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
