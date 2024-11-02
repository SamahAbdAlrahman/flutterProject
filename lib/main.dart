import 'dart:io';
import 'package:flutter/material.dart';
import 'package:untitled1/pages/btns/my_http_overrides.dart';
import 'package:untitled1/pages/home.dart';
import 'package:untitled1/pages/login2.dart';
import 'package:untitled1/pages/maintab.dart';

import 'package:untitled1/pages/splash.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return client;
  }
}

void main() {

  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      home: Scaffold(
        // body: PrepaidCreditcards(),
        // body: LoginScreen(),
        // body: CarrierListPage(),
        // body: v(username: 'v',),
        // body: TestImagePage(),
        // body: Login(),
        body: SplashScreen(),
        // body: MainTabView2( username: 'test',),
      ),
    );
  }
}

