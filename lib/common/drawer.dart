import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../pages/ChangePassword.dart';
import '../pages/home.dart';
import '../pages/login2.dart';
import '../pages/maintab.dart';
import 'CommonColors.dart';

class AccountInfo {
  final String userFullName;

  AccountInfo({
    required this.userFullName,

  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      userFullName: json['userFullName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userFullName': userFullName,
    };
  }
}

class CommonDrawer extends StatefulWidget {
  @override
  _CommonDrawerState createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  late Future<AccountInfo> _accountInfo;

  @override
  void initState() {
    super.initState();
    _fetchAccountInfo();
  }

  Future<AccountInfo> fetchAccountInfo(String token) async {
    final response = await http.get(
      Uri.parse('https://ultratopup.com/api/mobile/test/GetAccountInfo'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return AccountInfo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load account info');
    }
  }

  void _fetchAccountInfo() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');

    if (token != null) {
      setState(() {
        _accountInfo = fetchAccountInfo(token);
      });
    } else {
      setState(() {
        _accountInfo = Future.error("Token is missing");
      });
    }
  }

  Widget _buildDrawer() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Drawer(
      child: Container(
        color: Commoncolors.c9,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: FutureBuilder<AccountInfo>(
                future: _accountInfo,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else
                    if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final accountInfo = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Commoncolors.c1, Commoncolors.c5],
                              begin: Alignment.topRight,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Commoncolors.c5,
                                blurRadius: 15.0,
                                spreadRadius: 1,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              accountInfo.userFullName[0].toUpperCase(),
                              style: TextStyle(
                                color: Commoncolors.c9,
                                fontSize: screenHeight * 0.025,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 17),
                        Text(
                          accountInfo.userFullName,
                          style: TextStyle(
                            color: Commoncolors.c8,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  }
                  return Center(child: Text('No data available'));
                },
              ),
            ),
            _buildDrawerItem(Icons.home, "الرئيسية"),
            _buildDrawerItem(Icons.lock_reset, 'تغير رمز الدخول'),
            // _buildDrawerItem(Icons.shopping, "عمليات سابقة"),
            _buildDrawerItem(Icons.settings, "الاعدادات"),
            _buildDrawerItem(Icons.feedback, "تقييم"),
            _buildDrawerItem(Icons.logout_rounded, "تسجيل الخروج"),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Commoncolors.c1, Commoncolors.c5],
            begin: Alignment.bottomRight,
            end: Alignment.topRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Commoncolors.c5,
              blurRadius: 10.0,
              spreadRadius: 2,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Icon(icon, color: Commoncolors.c9, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Commoncolors.c8,
          fontSize: screenHeight * 0.02,
          fontWeight: FontWeight.w600,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
      tileColor: Commoncolors.c9,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      onTap: () async {
        if (title == 'تغير رمز الدخول') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                (Route<dynamic> route) => false,
          );
        } else if (title == 'الرئيسية') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainTabView2()),
                (Route<dynamic> route) => false,
          );
        } else if (title == 'تسجيل الخروج') {
          final storage = FlutterSecureStorage();
          await storage.delete(key: 'token');

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Login()),
                (Route<dynamic> route) => false,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDrawer();
  }
}
