
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../common/tab.dart';
import '../maintab.dart';
import '../../common/drawer.dart';
import '../../common/CommonColors.dart';
import 'btn1.dart';
import 'btn2.dart';


class SuccessPage extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String transactionDateTime;

  SuccessPage({
    required this.imageUrl,
    required this.productName,
    required this.transactionDateTime,
  });

  get selectTab => null;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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
                              Icon(
                                  Icons.check, size: 28,
                                  color: Colors.white
                              ),
                              SizedBox(width: 5),

                              Text(
                                'تمت العملية بنجاح',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),


                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: screenWidth*0.85,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                     SizedBox(height: screenHeight*0.01),
                        Container(
                          child: Image.network(
                            imageUrl,
                            width: screenWidth*0.79,
                            height: screenHeight*0.22,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error, size: 100);
                            },
                          ),
                        ),
                        // Product Name
                        Text(
                          productName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Commoncolors.c8,
                            fontSize: screenHeight * 0.022,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight*0.02),
                        // QR Code
                        QrImageView(
                          data: transactionDateTime,
                          version: QrVersions.auto,
                          size: 250.0,
                        ),
                        Text(
                          "QR Code",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Commoncolors.c5,
                            fontSize: screenHeight * 0.02,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )

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
