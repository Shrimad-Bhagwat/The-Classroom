import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_classroom/components/toast.dart';
import 'package:the_classroom/screens/group_chat/group_info.dart';

import '../../components/theme.dart';
import '../../extras/constants.dart';
import '../chat_app/chat_room.dart';

class GroupChatRoom extends StatelessWidget {
  final String groupChatId,groupChatName;

  GroupChatRoom({super.key, required this.groupChatId, required this.groupChatName});

  final FocusNode _messageFocusNode = FocusNode();
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void onSendMessage() async {
    Map<String, dynamic> chatData = {
      "sendBy" : _auth.currentUser!.displayName,
      "message" : _message.text,
      "type" : "text",
      "time" : FieldValue.serverTimestamp(),
    };
    print(chatData);

    if (_message.text.isNotEmpty) {
      await _firestore
          .collection('groups')
          .doc(groupChatId)
          .collection('chats')
          .add(chatData);
    }
    // showToast('Message Sent');
    _message.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      theme: getAppTheme(context),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
          title: Text(groupChatName),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => GroupInfo()));
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ))
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('groups')
                        .doc(groupChatId)
                        .collection('chats')
                        .orderBy('time')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> chatMap =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;
                              return messageTile(size, chatMap);
                            });
                      } else {
                        return Container(
                          child: Text("Start a Conversation"),
                        );
                      }
                    },
                  ),
                ),
              ),
              // Message Input Box
              Container(
                height: size.height / 16,
                width: size.width,
                alignment: Alignment.center,
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
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                // getImage();
                              },
                              icon: const Icon(
                                Icons.photo,
                                color: Colors.grey,
                              ),
                            ),
                            prefix: kHalfWidthSizedBox,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: onSendMessage,
                          icon: const Icon(
                            Icons.send,
                            color: Colors.grey,
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

  Widget messageTile(Size size, Map<String, dynamic> chatMap) {
    return Builder(builder: (_) {
      if (chatMap['type'] == "text") {
        return Container(
          width: size.width,
          alignment: chatMap['sendBy'] == _auth.currentUser!.displayName
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
                color: chatMap['sendBy'] == _auth.currentUser!.displayName
                    ? kSecondaryColor
                    : Color.fromARGB(100, 168, 168, 168),
                borderRadius: BorderRadius.circular(kDefaultPadding / 1.5)),
            margin: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding / 1.5,
                vertical: kDefaultPadding / 3),
            padding: const EdgeInsets.symmetric(
                vertical: kDefaultPadding / 5,
                horizontal: kDefaultPadding / 1.5),
            child: Column(
              crossAxisAlignment:
                  chatMap['sendBy'] != _auth.currentUser!.displayName
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
              children: [
                Text(chatMap['sendBy'],
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.normal)),
                Text(
                  chatMap['message'],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      } else if (chatMap['type'] == "notify") {
        return Container(
          width: size.width,
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(kDefaultPadding / 1.5)),
            margin: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding / 1.5,
                vertical: kDefaultPadding / 3),
            padding: const EdgeInsets.symmetric(
                vertical: kDefaultPadding / 5,
                horizontal: kDefaultPadding / 1.5),
            child: Text(
              chatMap['message'],
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        );
      } else if (chatMap['type'] == "img") {
        return Container(
          width: size.width,
          alignment: chatMap['sendBy'] == _auth.currentUser!.displayName
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding / 1.5,
                vertical: kDefaultPadding / 3),
            padding: const EdgeInsets.symmetric(
                vertical: kDefaultPadding / 5,
                horizontal: kDefaultPadding / 1.5),
            child: Image.network(
              chatMap['message'],
            ),
          ),
        );
      } else {
        return Container(
            width: kDefaultPadding,
            margin: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding / 1.5,
                vertical: kDefaultPadding / 3),
            padding: const EdgeInsets.symmetric(
                vertical: kDefaultPadding / 5,
                horizontal: kDefaultPadding / 1.5),
            alignment: chatMap['sendBy'] == _auth.currentUser!.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Text(
              'Error Loading Message !',
              style: TextStyle(color: Colors.red),
            ));
      }
    });
  }
}
