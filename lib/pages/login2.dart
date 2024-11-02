import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import '../common/CommonColors.dart';
import 'maintab.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool validate = false;
  bool circular = false;

  bool isPasswordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> _login() async {
    setState(() {
      circular = true;
    });

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('https://ultratopup.com/api/mobile/test/login'));
    request.body = json.encode({
      "Username": _usernameController.text,
      "Password": _passwordController.text
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();


    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      String token = json.decode(responseBody)['token'];

      try {
        await _storage.write(key: 'token', value: token);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainTabView2()),
        );
      } catch (e) {
        print('Error saving token: $e');
      }
    } else {
      print(response.reasonPhrase);
    }

    setState(() {
      circular = false;
    });
  }

  Future<void> _getToken() async {
    final token = await _storage.read(key: 'token');
    print('*********** \n retrieved token: $token');
  }

  bool _isUserNameObscured = false;
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(bottom: screenHeight * 0.02),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(0, 0.1),
                          radius: 0.70,
                          colors: <Color>[Commoncolors.c5, Commoncolors.c1],
                          stops: <double>[0, 0.88],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          screenWidth * 0.08,
                          screenHeight * 0.12,
                          screenWidth * 0.08,
                          screenHeight * 0.08,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.75,
                              height: screenHeight * 0.15,
                              child: Image.asset(
                                'assets/WhatsApp_Image_2024-07-28_at_2.48.13_PM-removebg-preview.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),

                    FractionallySizedBox(
                      widthFactor: 0.75,
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: Column(
                            children: [
                              TextField(
                                controller: _usernameController,
                                obscureText: _isUserNameObscured,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText: 'اسم المستخدم',
                                  labelStyle:  TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Commoncolors.c8,
                                    fontSize: screenHeight * 0.028,
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  icon: GestureDetector(

                                    child: Icon(
                                      Icons.check,
                                      color: Colors.grey,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              Center(
                              child: TextField(
                                controller: _passwordController,
                                obscureText: _isPasswordObscured,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText: 'رمز الدخول',
                                  labelStyle:  TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Commoncolors.c8,
                                    fontSize: screenHeight * 0.028,
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  icon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isPasswordObscured = !_isPasswordObscured;
                                      });
                                    },
                                    child: Icon(
                                      _isPasswordObscured
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                        ),
                              SizedBox(height: screenHeight * 0.05),

                              GestureDetector(
                                onTap: () async {
                                  await _login();
                                  await _getToken();
                                },
                                child: Container(
                                  height: screenHeight * 0.06,
                                  width: screenWidth * 0.50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
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
                                        :  Text(
                                      'تسجيل الدخول',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenHeight * 0.03,
                                        color: Commoncolors.c8,
                                      ),
                                    ),

                                  ),

                                ),

                              ),
                              SizedBox(height: screenHeight * 0.35),


                            ],
                          ),
                        ),
                      ),

                    ),

                  ],

                ),

              ),

              Positioned(
                left: 0,
                right: 0,
                top: screenHeight * 0.28,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: SizedBox(
                    width: screenWidth,
                    height: screenHeight * 0.1
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class ChangePasswordRequest {
  final String oldPassword;
  final String newPassword;

  ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    'OldPassword': oldPassword,
    'NewPassword': newPassword,
  };
}
