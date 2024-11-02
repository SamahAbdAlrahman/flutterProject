import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/io_client.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:untitled1/pages/btns/qr.dart';
import '../../common/CommonColors.dart';
import '../../common/tab.dart';
import '../maintab.dart';
import 'Products.dart';
import '../../common/drawer.dart';
import '../../common/CommonColors.dart';
import 'btn1.dart';
import 'btn2.dart';

class TopUpPage extends StatefulWidget {
  final Product product;
  final int carrierId;

  TopUpPage({required this.product, required this.carrierId});

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final TextEditingController _mobileController = TextEditingController();

  get selectTab => null;

  Future<void> performTopUp() async {
    final token = await _storage.read(key: 'token');
    if (token == null) {
      _showDialog('error', 'No token found');
      return;
    }

    final mobile = _mobileController.text.trim();
    final amount = widget.product.price;

    if (mobile.isEmpty || amount <= 0) {
      _showDialog('خطأ', 'يرجى إدخال رقم الهاتف وتأكيد المبلغ');
      return;
    }

    try {
      final ioc = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
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
          'ProdId': widget.product.id,
          'Amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final transactionDateTime = responseData['transactionDateTime'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 24),
                  SizedBox(width: 10),
                  Text('تمت العملية بنجاح',
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
                  child: Text(' QR Code عرض  ',
            style: TextStyle(
            color:Commoncolors.c5,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SuccessPage(
                          imageUrl: widget.product.imageName,
                          productName: widget.product.productName,
                          transactionDateTime: transactionDateTime,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
      else {
        print('Response body: ${response.body}');
        _showDialog('حطأ', 'فشلت العملية: ');
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
                                'شحن',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                  Icons.payment, size: 35, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // رقم الهاتف
                  SizedBox(height: 60.0),
                  SizedBox(
                    width: 220,
                    child: TextField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'رقم الهاتف ',
                        labelStyle: TextStyle(
                          color: Commoncolors.c8,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Commoncolors.c8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Commoncolors.c5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Commoncolors.c8),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  //  المبلغ
                  SizedBox(height: 25.0),
                  Text(
                    'المبلغ: ${widget.product.price} ₪',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Commoncolors.c5,
                    ),
                  ),
                  //  اتمام العملية
                  SizedBox(height: 25.0),
                  Center(
                    child: TextButton(
                      onPressed: performTopUp,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: Commoncolors
                            .c5,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle,
                              size: 30, color: Colors.lightGreenAccent),
                          SizedBox(width: 10.0),
                          Text(
                            'اتمام العملية',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //  الصورة
                  SizedBox(height: 55.0),
                  Container(
                    width: 350,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.9),
                          spreadRadius: 5,
                          blurRadius: 20,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        widget.product.imageName,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(Icons.error, size: 100),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          bottomNavigationBar: !isWideScreen
              ? Container(
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







