
import 'package:flutter/material.dart';
import '../common/CommonColors.dart';
import '../common/tab.dart';
import 'btns/btn1.dart';
import 'btns/btn2.dart';
import 'home.dart';

class MainTabView2 extends StatefulWidget {
  const MainTabView2({super.key});

  @override
  State<MainTabView2> createState() => _MainTabView2State();
}

class _MainTabView2State extends State<MainTabView2> {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  late Widget currentTab;

  @override
  void initState() {
    super.initState();
    currentTab = Home();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 800;

        return Scaffold(
          backgroundColor: Colors.white,
          body: PageStorage(bucket: pageBucket, child: currentTab),
          floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked,
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
                      MaterialPageRoute(builder: (context) => MainTabView2()), // home
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
              color:Commoncolors.c9,
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
                          MaterialPageRoute(builder: (contexts) => GamesPage()),

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
