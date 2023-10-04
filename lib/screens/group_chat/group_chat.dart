

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

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
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

          body: Container(
            child: Container(

              decoration: const BoxDecoration(
                  color: kTextWhiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(kDefaultPadding * 1.5),
                      topRight: Radius.circular(kDefaultPadding * 1.5))),
            child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index){
                  return ListTile(
                    onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => GroupChatRoom()));
                  },
                    leading: Icon(Icons.group,color: kTextLightColor,),
                    title: Text("Group $index"),
                  );
            }),
          ),


        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          child: Icon(Icons.create,color: Colors.white,),
          onPressed: (){
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>  AddMembersInGroup()));

          },
          tooltip: "Create Group",
        ),
      ),
    );
  }
}
