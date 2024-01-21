import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:login_signup/utils/api.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  String _scanBarcode = '';
  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      debugPrint(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: 'Tiếp tục đăng nhập',
        confirmBtnText: 'Có',
        cancelBtnText: 'Không',
        confirmBtnColor: Colors.green,
        onConfirmBtnTap: () {
          loginToWeb();
          Navigator.pop(context);
        },
      );
    });
  }

  Future<void> loginToWeb() async {
    String url = "v1/oauth/login/byweb";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = await prefs.getString('token');
    var headers = {
      'Authorization': ' Bearer $value',
      'Content-Type':
          'application/x-www-form-urlencoded', // Điều này phụ thuộc vào yêu cầu cụ thể của máy chủ
    };
    final response = await http.post(
      Uri.parse(ApiEndPoints.baseUrl + url),
      headers: headers,
      body: _scanBarcode.toString(), // Truyền số trang cần tải
    );

    if (response.statusCode == 200) {
      QuickAlert.show(
          context: context,
          title: "Thành công",
          text: "Đăng nhập thành công",
          type: QuickAlertType.success);
    } else {
      QuickAlert.show(
          context: context,
          title: "Thất bại",
          text: "Qúa hạn đăng nhập!",
          type: QuickAlertType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "Destiny",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(50)),
                    child: Icon(
                      Icons.search,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(50)),
                      child: InkWell(
                        onTap: () {
                          scanQR();
                        },
                        child: Icon(
                          Icons.qr_code,
                          color: Colors.black87,
                        ),
                      )),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
