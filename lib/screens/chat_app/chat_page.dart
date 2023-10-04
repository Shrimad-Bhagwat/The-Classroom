import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_classroom/components/theme.dart';
import 'package:the_classroom/components/toast.dart';
import 'package:the_classroom/extras/constants.dart';
import 'package:the_classroom/screens/chat_app/chat_room.dart';
import 'package:the_classroom/screens/group_chat/group_chat.dart';
import 'package:the_classroom/screens/home_screen/home_screen.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    // Set User status Online once app starts
    setStatus("Online");
  }

  // Update Status
  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  // Create a Char Room Id for two users
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  // Search function for users
  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getAppTheme(context),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Chats"),
          leading: InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
        ),
        body: Container(
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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
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
              SizedBox(
                height: size.height / 30,
              ),
              userMap != null
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      decoration: const BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(kDefaultPadding / 2))),
                      child: ListTile(
                        onTap: () {
                        String roomId = chatRoomId(
                            _auth.currentUser!.email!,
                            userMap!['email']);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChatRoom(
                              chatRoomId: roomId,
                              userMap: userMap!,
                            ),
                          ),
                        );
                        },
                        leading: const Icon(Icons.account_box, color: Colors.white),
                        title: Text(
                          userMap!['email'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Icon(Icons.chat, color: Colors.white),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          child: const Icon(
            Icons.group,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => const GroupChatScreen()));
          }
        ),
      ),
    );
  }
}
