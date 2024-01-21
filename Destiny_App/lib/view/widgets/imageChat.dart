import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_signup/utils/api.dart';
import 'package:login_signup/view/chatPage.view.dart';
import 'package:login_signup/view/screens/profile.view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ImageChat extends StatefulWidget {
  const ImageChat({super.key});

  @override
  State<ImageChat> createState() => _ImageChatState();
}

class _ImageChatState extends State<ImageChat> {
  @override
  void initState() {
    super.initState();
    loadAllImage();
  }

  List<dynamic>? imageList;
  void loadAllImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = await prefs.getString('token');

    var headers = {
      'Authorization': 'Bearer $value',
      'Content-Type':
          'application/x-www-form-urlencoded', // Điều này phụ thuộc vào yêu cầu cụ thể của máy chủ
    };

    var response = await http.post(
      Uri.parse(ApiEndPoints.baseUrl + "v1/user/messages/load/images"),
      headers: headers,
      body: {
        'to': socketManager.userIdImage.toString()
      }, // Truyền số trang cần tải
    );
    if (response.statusCode == 200) {
      List data = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      imageList = data;
      print("ảnh" + data.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
          title: Text('Tất cả ảnh'),
          leading: BackButton(
            onPressed: () {
              runApp(GetMaterialApp(
                home: ChatPage(),
              ));
            },
          )),
      body: imageList!.length == 0
          ? Center(
              child: Text(
                'Không có ảnh',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: imageList!.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ImageDetailScreen(imageUrl: imageList![index]),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.network(
                      imageList![index],
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
    ));
  }
}

class ImageDetailScreen extends StatelessWidget {
  final String imageUrl;

  ImageDetailScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xem chi tiết'),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
