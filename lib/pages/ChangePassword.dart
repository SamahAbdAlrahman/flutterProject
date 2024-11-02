import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../common/CommonColors.dart';
import '../common/drawer.dart';
import '../common/tab.dart';
import 'btns/btn1.dart';
import 'btns/btn2.dart';
import 'maintab.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _isOldPasswordObscured = true;
  bool _isNewPasswordObscured = true;
  bool circular = false;

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  get selectTab => null;
  Future<void> _changePassword() async {
    setState(() {
      circular = true;
    });

    final token = await _storage.read(key: 'token');
    print('Retrieved token: $token');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var request = http.Request('POST', Uri.parse('https://ultratopup.com/api/mobile/test/ChangePassword'));
    request.body = json.encode({
      "OldPassword": _oldPasswordController.text,
      "NewPassword": _newPasswordController.text,
    });
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 24),
                  SizedBox(width: 10),
                  Text('تمت تغير رمز الدخول',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Commoncolors.c8,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),

              actions: <Widget>[
                TextButton(
                  onPressed: () {  },
                  child: Text('تم',
                    style: TextStyle(
                      color:Commoncolors.c5,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }

    setState(() {
      circular = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context)        .size        .width;
    double screenHeight = MediaQuery        .of(context)        .size        .height;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 800;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Commoncolors.c1,
            iconTheme: IconThemeData(color: Colors.white70),
            elevation: 0,
          ),
          drawer: !isWideScreen ? CommonDrawer() : null,
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
height:screenHeight ,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // راس الصفحة
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Commoncolors.c1, Commoncolors.c5],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(55),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 80,
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'تغير رمز الدخول',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenHeight * 0.028,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                  Icons.lock_reset, size: 35, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight*0.134),


                  FractionallySizedBox(
                    widthFactor: 0.75,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.25),
                            spreadRadius: 2,
                            blurRadius: 15,
                            offset: Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      // color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical:screenHeight*0.05,horizontal: screenWidth * 0.05),
                        child: Column(
                          children: [
                            TextField(
                              controller: _oldPasswordController,
                              obscureText: _isOldPasswordObscured,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                labelText: 'رمز الدخول الحالي',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  // color: Commoncolors.c8,
                                  fontSize: screenHeight * 0.023,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                prefixIcon: IconButton(
                                  icon: Icon(
                                    _isOldPasswordObscured ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isOldPasswordObscured = !_isOldPasswordObscured;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Center(
                              child: TextField(
                                controller: _newPasswordController,
                                obscureText: _isNewPasswordObscured,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                  labelText: 'رمز الدخول الجديد',
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                    fontSize: screenHeight * 0.023,
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  prefixIcon: IconButton(
                                    icon: Icon(
                                      _isNewPasswordObscured ? Icons.visibility_off : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isNewPasswordObscured = !_isNewPasswordObscured;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.05),

                            GestureDetector(
                              onTap: () async {
                                await _changePassword();
                              },
                              child: Container(
                                height: screenHeight * 0.06,
                                width: screenWidth * 0.50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  gradient: const LinearGradient(
                                    colors: [Commoncolors.c9, Commoncolors.c9],
                                  ),
                                  border: Border.all(
                                    color: Commoncolors.c5,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: circular
                                      ? const CircularProgressIndicator(
                                    color: Commoncolors.c8,
                                  )
                                      : Text(
                                    'تغير الرمز',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenHeight * 0.028,
                                      color: Commoncolors.c8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),


                ],
              ),

            ),

          ),

          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: !isWideScreen
              ? SizedBox(
            width: 82,
            height: 85,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Commoncolors.c1,
                    Commoncolors.c5,
                  ],
                  begin: Alignment.bottomRight,
                  end: Alignment.topRight,
                ),
                borderRadius: BorderRadius.circular(40),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.home, color: Colors.white, size: 43),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainTabView2()), // Home
                    );
                  },
                ),
              ),
            ),
          )
              : null,
          bottomNavigationBar: !isWideScreen
              ? Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 8.0,
                  spreadRadius: 0.0,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: BottomAppBar(
              color: Commoncolors.c9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 35.0),
                    child: TabButton2(
                      icon: Icons.shopping_bag,
                      selectIcon: Icons.shopping_bag_outlined,
                      isActive: selectTab == 1,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GamesPage2()),
                        );
                      },
                    ),
                  ),
                  Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainTabView2()),
                      );
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    child: Icon(
                      Icons.home,
                      color: Colors.transparent,
                      size: 28,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0, top: 10),
                    child: TabButton2(
                      icon: Icons.videogame_asset,
                      selectIcon: Icons.videogame_asset_outlined,
                      isActive: selectTab == 2,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GamesPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
              : null,

        );
      },
    );
  }
}
