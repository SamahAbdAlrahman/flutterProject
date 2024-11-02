import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/io_client.dart';
import 'package:untitled1/pages/btns/topup.dart';
import '../../common/CommonColors.dart';
import '../../common/drawer.dart';
import '../../common/tab.dart';
import '../maintab.dart';
import 'btn1.dart';
import 'btn2.dart';

class ProductDetailsPage extends StatelessWidget {
  final int carrierId;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  ProductDetailsPage(this.carrierId);

  get selectTab => null;

  Future<List<Product>> fetchProducts() async {
    final token = await _storage.read(key: 'token');
    if (token == null) {
      throw Exception('No token found');
    }

    try {
      final ioc = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      final httpClient = IOClient(ioc);

      final response = await httpClient.get(
        Uri.parse('https://ultratopup.com/api/mobile/test/GetProducts?carrierID=$carrierId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized access: ${response.body}');
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load products: $e');
    }
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


          body:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Commoncolors.c1,
                      Commoncolors.c5,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(55)
                  ),
                ),
                padding: EdgeInsets.all(2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.78,
                      height: 80,
                      padding: EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'العروض',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.redeem, size: 35, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),

              ),
              Expanded(
                child: FutureBuilder<List<Product>>(
                  future: fetchProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('حدث خطأ ما: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('لا توجد منتجات'));
                    } else {
                      final products = snapshot.data!;
                      return ListView.builder(
                        padding: EdgeInsets.all(8.0),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TopUpPage(
                                    product: product,
                                    carrierId: carrierId,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 7.0,
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(18.0),
                                          child: Image.network(
                                            product.imageName,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.fitWidth,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Icon(Icons.error, size: 120);
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          ' ${product.price} ₪',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 19.0,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.productName,
                                            style: TextStyle(
                                              color: Commoncolors.c1,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 19.0,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          SizedBox(height: 12.0),
                                          Text(
                                            product.description,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 17.0,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 15.0),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),







            ],),





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
                      MaterialPageRoute(builder: (context) => MainTabView2()),
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

class Product {
  final int id;
  final int carrierId;
  final double cardAmount;
  final double price;
  final String description;
  final String productName;
  final String imageName;

  Product({
    required this.id,
    required this.carrierId,
    required this.cardAmount,
    required this.price,
    required this.description,
    required this.productName,
    required this.imageName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      carrierId: json['carrierId'],
      cardAmount: (json['cardAmount'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      productName: json['productName'],
      imageName: json['imageName'],
    );
  }
}
