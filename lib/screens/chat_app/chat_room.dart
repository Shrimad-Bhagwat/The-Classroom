import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_classroom/components/toast.dart';
import 'package:the_classroom/extras/constants.dart';

import '../../components/theme.dart';

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
          title: Text(userMap['email']),
        ),
        body: SingleChildScrollView(
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
                            var data = snapshot.data?.docs[index].data();
                            print(data);
                            Map<String, dynamic> map = data as Map<String, dynamic>;
                            return messages(size, map);
                          });
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    color: kTextWhiteColor,
                    borderRadius:
                        BorderRadius.all(Radius.circular(kDefaultPadding / 2))),
                height: size.height / 10,
                width: size.width,
                alignment: Alignment.center,
                child: Container(
                  height: size.height / 12,
                  width: size.width / 1.1,
                  child: Row(
                    children: [
                      Container(
                        height: size.height / 12,
                        width: size.width / 1.3,
                        child: TextField(
                          controller: _message,
                          focusNode: _messageFocusNode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(kDefaultPadding / 2),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed:(){ onSendMessage(context);},
                          icon: const Icon(
                            Icons.send,
                            color: kTextBlackColor,
                          ))
                    ],
                  ),
                ),
              )
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
          margin: EdgeInsets.all(kDefaultPadding/3),
          padding: EdgeInsets.symmetric(vertical: kDefaultPadding/5, horizontal: kDefaultPadding/1.5),
          decoration: BoxDecoration(
            color:map['sendby'] == currUser? Colors.white: kSecondaryColor,
            borderRadius: BorderRadius.circular(kDefaultPadding/1.5)
          ),
          child: Text(map['message'],style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)
      ),
    );
  }
}
