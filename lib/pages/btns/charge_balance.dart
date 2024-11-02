import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/io_client.dart';

import '../../common/CommonColors.dart';
import '../../common/drawer.dart';

class ChargeBalance extends StatefulWidget {
  final int carrierId;
  final String img;

  ChargeBalance({required this.carrierId, required this.img});

  @override
  _ChargeBalanceState createState() => _ChargeBalanceState();
}

class _ChargeBalanceState extends State<ChargeBalance> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final TextEditingController _mobileController = TextEditingController();
  final List<int> amounts = [10, 15, 20, 25, 30, 40, 50, 150, 200];
  int? selectedAmount;

  void _chargeBalance() async {
    final mobile = _mobileController.text.trim();
    final amount = selectedAmount ;


    final token = await _storage.read(key: 'token');
    if (token == null) {
      _showDialog('Error', 'No token found');
      return;
    }

    try {
      final ioc = HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final httpClient = IOClient(ioc);

      final response = await httpClient.post(
        Uri.parse('https://ultratopup.com/api/mobile/test/topup'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'CarrierId': widget.carrierId,
          'Mobile': mobile,
          'Amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        _showDialog('', 'تمت العملية بنجاح');
      } else {
        print('Response body: ${response.body}');
        _showDialog('خطأ', 'فشلت العملية: ');
      }
    } catch (e) {
      print('Error: $e');
      _showDialog('خطأ', 'حدث خطأ: ');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('موافق'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 800;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Commoncolors.c1,
            iconTheme: IconThemeData(
              color: Colors.white70,
              size: 24,
            ),
            elevation: 0,
          ),
          drawer: !isWideScreen ? CommonDrawer() : null,
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
            height: screenHeight,
            child: Column(
              children: [
                Container(

                  width: double.infinity,
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
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.78,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'شحن الرصيد',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.account_balance_wallet, size: 35, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
// SizedBox(height:screenHeight *0.01 ,),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(44.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Carrier image
                        Center(
                          child: Image.network(
                            widget.img,
                            height: 110,
                            width: 110,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error, size: 50, color: Colors.redAccent);
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Phone number input
                        const Text(
                          'رقم الهاتف',
                          style: TextStyle(
                              fontSize: 20,
                              color: Commoncolors.c8,
                              fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'أدخل رقم هاتفك',
                            contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Select amount
                        const Text(
                          'اختر باقة ',
                          style: TextStyle(
                              fontSize: 20,
                              color: Commoncolors.c8,
                              fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  'مرر لليمين واليسار لرؤية المزيد',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: amounts.map((amount) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 7),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: selectedAmount == amount ? Commoncolors.c5 : Colors.grey[200],
                                            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),

                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              selectedAmount = amount;
                                            });
                                          },
                                          child: Text(
                                            '$amount ₪',
                                            style: TextStyle(
                                              color: selectedAmount == amount ? Colors.white : Colors.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),


                        //  اتمام العملية
                        SizedBox(height: 30.0),
                        Center(
                          child: TextButton(
                            onPressed: _chargeBalance,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              backgroundColor: Commoncolors.c5,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'شحن',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 12.0),

                                Icon(Icons.check_circle, size: 30, color: Colors.lightGreenAccent),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ),
        );
      },
    );
  }

}
