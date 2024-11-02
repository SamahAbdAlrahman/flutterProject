import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../common/CommonColors.dart';
import '../../common/drawer.dart';
import '../../common/tab.dart';
import '../home.dart';
import 'Products.dart';
import '../maintab.dart';
import 'btn1.dart';
import 'btn2.dart';
class GamesPage extends StatefulWidget {
  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  int selectTab = 0;
  late Widget currentTab;

  @override
  void initState() {
    super.initState();
    currentTab = this.widget;
  }

  Future<List<Carrier>> fetchCarriers() async {
    final token = await FlutterSecureStorage().read(key: 'token');
    if (token == null) {
      throw Exception('No token found');
    }

    try {
      final response = await http.get(
        Uri.parse('https://ultratopup.com/api/mobile/test/GetCarriers'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body) as List;
        var filteredData = jsonData.where((item) => item['category'] == 2).toList();
        return filteredData.map((item) => Carrier.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load carriers');
      }
    } catch (e) {
      throw Exception('Failed to load carriers: $e');
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
                        'العاب',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.videogame_asset, size: 35, color: Colors.white), //
                    ],
                  ),
                ),
                           ],
            ),

          ),
              Expanded(
                child: FutureBuilder<List<Carrier>>(
                  future: fetchCarriers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Failed to load carriers: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No carriers found'));
                    } else {
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 4,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var carrier = snapshot.data![index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsPage(carrier.carrierId),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      Commoncolors.c9,
                                      Commoncolors.c5,
                                      Commoncolors.c1
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          carrier.imageName,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(Icons.error, size: 50, color: Colors.redAccent);
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        carrier.carrierName,
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Spacer(),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProductDetailsPage(carrier.carrierId),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      ),
                                      child: Text(
                                        'عرض التفاصيل',
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12),
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

class Carrier {
  final int carrierId;
  final String imageName;
  final String carrierName;

  Carrier({
    required this.carrierId,
    required this.imageName,
    required this.carrierName,
  });

  factory Carrier.fromJson(Map<String, dynamic> json) {
    return Carrier(
      carrierId: json['carrierId'],
      imageName: json['imageName'],
      carrierName: json['carrierName'],
    );
  }
}
