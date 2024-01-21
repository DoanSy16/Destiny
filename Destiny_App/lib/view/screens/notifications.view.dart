import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:login_signup/models/NotifyModel.dart';
import 'package:login_signup/models/SocketManager%20.dart';
import 'package:login_signup/utils/gobal.colors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  bool hasFollower = true;
  late SocketManager socketManager = SocketManager();

  @override
  void initState() {
    super.initState();
    getConnectivity();
    setState(() {
      socketManager.updateListNotify(socketManager.listNotify);
    });

    // List<NotifyModel> list = socketManager.notifyStream;
  }

  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  Future<void> getConnectivity() async {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult event) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && !isAlertSet) {
        showDialogBox();
        setState(() => isAlertSet = true);
      } else if (isDeviceConnected && isAlertSet) {
        setState(() => isAlertSet = false);
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void showDialogBox() {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text("Không có kết nối"),
        content: const Text("Vui lòng kiểm tra kết nối internet"),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.pop(context, 'Cancel');
              isDeviceConnected =
                  await InternetConnectionChecker().hasConnection;
              if (!isDeviceConnected) {
                showDialogBox();
                setState(() => isAlertSet = true);
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thông báo",
          style: TextStyle(
            color: GlobalColors.mainColor,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: socketManager.listNotify.length,
        itemBuilder: (context, index) {
          NotifyModel notify = socketManager.listNotify[index];

          Widget subtitleWidget = Text(
            "Thông báo không xác định",
            style: TextStyle(color: Colors.grey),
          );

          if (notify.type == 'COMMENT') {
            subtitleWidget = Text(
              "đã bình luận vào bài viết của bạn",
              style: TextStyle(color: Colors.grey),
            );
          } else if (notify.type == 'REPCOMMENT') {
            subtitleWidget = Text(
              "đã trả lời bình luận của bạn",
              style: TextStyle(color: Colors.grey),
            );
          } else if (notify.type == 'MENTION') {
            subtitleWidget = Text(
              "đã nhắc đến bạn trong một bình luận",
              style: TextStyle(color: Colors.grey),
            );
          } else if (notify.type == 'INTERESTED') {
            subtitleWidget = Text(
              "đã thích bài viết của bạn",
              style: TextStyle(color: Colors.grey),
            );
          } else if (notify.type == 'SHARE') {
            subtitleWidget = Text(
              "đã chia sẻ bài viết của bạn",
              style: TextStyle(color: Colors.grey),
            );
          } else if (notify.type == 'FOLLOW' &&
              notify.following_status == true) {
            subtitleWidget = Text(
              "đã theo dõi bạn",
              style: TextStyle(color: Colors.grey),
            );
          } else if (notify.type == 'FOLLOW' &&
              notify.following_status == false) {
            subtitleWidget = Text(
              "và bạn đã trở thành bạn bè",
              style: TextStyle(color: Colors.grey),
            );
          }

          return ListTile(
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(notify.avatar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              notify.fullname,
              style: TextStyle(color: Colors.black),
            ),
            subtitle: subtitleWidget,
            trailing: notify.type == 'FOLLOW' && notify.following_status == true
                ? ElevatedButton(
                    // Button theo dõi
                    onPressed: () {
                      // Xử lý khi người dùng nhấn vào button theo dõi
                    },
                    child: Text(
                      'Theo dõi',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : null,
            onTap: () {
              // Xử lý khi người dùng nhấn vào thông báo
            },
            enabled: true,
          );
        },
      ),
    );
  }
}
