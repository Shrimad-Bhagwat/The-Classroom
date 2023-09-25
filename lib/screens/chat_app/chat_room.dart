import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_classroom/components/toast.dart';
import 'package:the_classroom/extras/constants.dart';

import '../../components/theme.dart';
import '../assignment_screen/assignment_screen.dart';

class ChatRoom extends StatelessWidget {
  final Map<String, dynamic> userMap;
  final String chatRoomId;
  final FocusNode _messageFocusNode = FocusNode();

  ChatRoom({required this.chatRoomId, required this.userMap});

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void onSendMessage(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.email?.split('@')[0],
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      showToastError('Enter a message!');
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
          // title: Text(userMap['email']),
          title: StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection("users").doc(userMap['uid']).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return Container(
                color: kPrimaryColor,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userMap['name']),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: snapshot.data!['status'] == 'Online' ? Colors.green : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8), // Add some spacing between dot and status text
                            Text(
                              snapshot.data!['status'],
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
              } else {
                return Container();
              }
            },
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: size.height / 1.25,
                        width: size.width,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection('chatroom')
                              .doc(chatRoomId)
                              .collection('chats')
                              .orderBy("time", descending: false)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.data != null) {
                              return ListView.builder(
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    var data =
                                        snapshot.data?.docs[index].data();
                                    print(data);
                                    Map<String, dynamic> map =
                                        data as Map<String, dynamic>;
                                    return messages(size, map);
                                  });
                            } else {
                              return const LoadingMessages();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                // decoration: const BoxDecoration(
                //     color: kPrimaryColor,
                // ),
                height: size.height / 16,
                width: size.width,
                alignment: Alignment.center,

                // User Input
                child: Container(
                  height: size.height / 12,
                  width: size.width / 1.1,
                  child: Row(
                    children: [
                      Container(
                        height: size.height / 16,
                        width: size.width / 1.3,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: kTextLightColor, width: 1.5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: _message,
                          focusNode: _messageFocusNode,
                          decoration: const InputDecoration(
                            prefix: kHalfWidthSizedBox,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            onSendMessage(context);
                          },
                          icon: const Icon(
                            Icons.send,
                            color: kTextBlackColor,
                          ))
                    ],
                  ),
                ),
              ),
              kHalfSizedBox
            ],
          ),
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map) {
    var currUser = _auth.currentUser?.email?.split('@')[0];
    return Container(
      width: size.width,
      alignment: map['sendby'] == currUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
          margin: const EdgeInsets.all(kDefaultPadding / 3),
          padding: const EdgeInsets.symmetric(
              vertical: kDefaultPadding / 5, horizontal: kDefaultPadding / 1.5),
          decoration: BoxDecoration(
              color: map['sendby'] == currUser
                  ? kSecondaryColor
                  : Color.fromARGB(100, 168, 168, 168),
              borderRadius: BorderRadius.circular(kDefaultPadding / 1.5)),
          child: Text(
            map['message'],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          )),
    );
  }
}

class LoadingMessages extends StatelessWidget {
  const LoadingMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        kHalfSizedBox,
        LoadMessage(
          height: kDefaultPadding * 1.5,
          width: kDefaultPadding * 3,
        ),
        kHalfSizedBox,
        LoadMessage(
          height: kDefaultPadding * 1.5,
          width: kDefaultPadding * 6,
        ),
        kHalfSizedBox,
        LoadMessage(
          height: kDefaultPadding * 1.5,
          width: kDefaultPadding * 4,
        ),
      ],
    );
  }
}

class LoadMessage extends StatelessWidget {
  const LoadMessage({
    super.key,
    this.height,
    this.width,
  });

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius:
              const BorderRadius.all(Radius.circular(kDefaultPadding))),
    );
  }
}
