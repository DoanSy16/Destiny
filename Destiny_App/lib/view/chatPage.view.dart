import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:login_signup/models/SocketManager%20.dart';
// import 'package:login_signup/models/SocketManager.dart';
import 'package:login_signup/models/UserModel.dart';
import 'package:login_signup/utils/gobal.colors.dart';
import 'package:login_signup/view/bottomnavbar.dart';
import 'package:login_signup/view/login_signup_screen.dart';
import 'package:login_signup/view/screens/message.view.dart';
import 'package:login_signup/view/widgets/ImageChat.dart';
import 'package:login_signup/view/widgets/chat/chat.dart';
import 'package:login_signup/view/widgets/chat/chatSample.dart';
import 'package:login_signup/view/widgets/chat/chatBottomSheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late SocketManager socketManager = SocketManager();
  late UserModel userModel = socketManager.userChatPage;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      userModel = socketManager.userChatPage;
      socketManager.selectedIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Padding(
          padding: EdgeInsets.only(top: 5),
          child: AppBar(
            leading: BackButton(
              onPressed: () {
                socketManager.userChatPage = new UserModel();
                runApp(GetMaterialApp(
                  home: BottomNavBar(),
                ));
              },
            ),
            leadingWidth: 30,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    userModel.avatar,
                    height: 45,
                    width: 45,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    userModel.fullname,
                    style: TextStyle(color: GlobalColors.mainColor),
                  ),
                )
              ],
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 25),
                child: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () {
                        socketManager.userIdImage = userModel.user_id;
                        runApp(GetMaterialApp(
                          home: ImageChat(),
                        ));
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text("Tất cả ảnh"),
                          ),
                        ],
                      ),
                    ),
                  ],
                  child: Icon(
                    Icons.more_vert,
                    color: GlobalColors.mainColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 80),
        child: ListView(
          children: [
            Expanded(
              child: ChatSample(),
            ),
          ],
        ),
      ),
      bottomSheet: ChatBottomSheet(),
    );
  }
}
