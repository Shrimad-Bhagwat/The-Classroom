import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_classroom/screens/group_chat/create_group/create_group.dart';

import '../../../components/theme.dart';
import '../../../extras/constants.dart';

class AddMembersInGroup extends StatefulWidget {
  const AddMembersInGroup({super.key});

  @override
  State<AddMembersInGroup> createState() => _AddMembersInGroupState();
}

class _AddMembersInGroupState extends State<AddMembersInGroup> {
  bool isLoading = false;

  final TextEditingController _search = TextEditingController();

  final FocusNode _focusNode = FocusNode();

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
          title: Text('Add Members'),
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
                    itemCount: 3,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {},
                        leading: const Icon(
                          Icons.account_circle,
                          color: kTextLightColor,
                        ),
                        title: const Text("User2"),
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
                  onPressed: () {},
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
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>  CreateGroup()));

          },
          child: Icon(
            Icons.forward,
            color: kTextWhiteColor,
          ),
        ),
      ),
    );
  }
}
