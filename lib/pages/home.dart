import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../common/CommonColors.dart';
import '../common/drawer.dart';
import 'btns/btn1.dart';
import 'btns/btn2.dart';
import 'btns/btn3.dart';
import 'login2.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<AccountInfo> _accountInfo ;
  late Future<List<TransactionReport>> _transactionReports;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _fetchAccountInfo();
    _fetchTransactionReports();

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

  void _fetchTransactionReports() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');

    if (token != null) {
      setState(() {
        _transactionReports = fetchTransactionReports(token);
      });
    } else {
      setState(() {
        _transactionReports = Future.error("Token is missing");
      });
    }
  }

  void _fetchReports() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');

    if (token != null) {
      final startDateStr = _startDate != null ? DateFormat('yyyyMMdd').format(_startDate!) : null;
      final endDateStr = _endDate != null ? DateFormat('yyyyMMdd').format(_endDate!) : null;

      if (startDateStr != null && endDateStr != null) {
        setState(() {
          _transactionReports = fetchTransactionReports2(token, startDateStr, endDateStr);
        });
      }
    }
  }
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 800;

          return Row(
            children: [
              if (isWideScreen)
                SizedBox(
                  width: 200,
                  child: CommonDrawer(),
                ),
              Expanded(
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: Commoncolors.c1,
                    iconTheme: IconThemeData(
                      color: Colors.white70,
                      size: 24,
                    ),
                    elevation: 0,
                  ),
                  drawer: !isWideScreen ? CommonDrawer() : null,
                  body: SafeArea(
                    child: FutureBuilder<AccountInfo>(
                      future: _accountInfo,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          final accountInfo = snapshot.data!;
                          return Column(
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
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'اهلاَ بك ${accountInfo.userFullName}',
                                            style: TextStyle(
                                              // color: c.c9,
                                              color: Colors.white,
                                              fontSize: screenHeight * 0.035,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: Card(
                                              elevation: 10,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      // c.c9,
                                                      // c.c9,
                                                      Commoncolors.c1,
                                                      Commoncolors.c5,
                                                    ],
                                                  ),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(0,10,0,10),
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        'assets/ee.png',
                                                        height: 70,
                                                        width: 66,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            'الدين',
                                                            style: TextStyle(
                                                              color: Colors.deepOrangeAccent,
                                                              fontSize: screenHeight * 0.03,
                                                              fontWeight: FontWeight.w900,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${accountInfo.refillLimit.toStringAsFixed(1)}',
                                                            style: TextStyle(
                                                              color: Colors.deepOrangeAccent,
                                                              fontSize: screenHeight * 0.03,
                                                              fontWeight: FontWeight.w800,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          SizedBox(width: 15),
                                          Expanded(
                                            child: Card(
                                              elevation: 10,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Commoncolors.c5,
                                                      Commoncolors.c1,
                                                    ],
                                                  ),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(0,10,0,10),
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                          'assets/e.png',
                                                          height: 70,
                                                          width: 68
                                                      ),
                                                      SizedBox(width: 10),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            'الرصيد',
                                                            style: TextStyle(
                                                              color: Colors.greenAccent,
                                                              fontSize: screenHeight * 0.03,
                                                              fontWeight: FontWeight.w900,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${accountInfo.balance.toStringAsFixed(1)}',
                                                            style: TextStyle(
                                                              color: Colors.greenAccent,
                                                              fontSize: screenHeight * 0.03,
                                                              fontWeight: FontWeight.w800,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              // الأزرار
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildOptionButton(context, 'العاب', Commoncolors.c1, Commoncolors.c5),
                                    // SizedBox(width: 0),
                                    _buildOptionButton(context, 'حزم', Commoncolors.c5, Commoncolors.c5),
                                    // SizedBox(width: 5),
                                    _buildOptionButton(context, 'رصيد', Commoncolors.c5, Commoncolors.c1),
                                  ],
                                ),
                              ),
                              // عرض الحركات السابقة
                              Container(
                                alignment: Alignment.topRight,
                                padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 25.0),
                                child: Text(
                                  'سجل العمليات',
                                  style: TextStyle(
                                    color: Commoncolors.c8,
                                    fontSize: screenHeight * 0.03,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Source Serif Pro',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: 'من تاريخ',
                                          border: OutlineInputBorder(),
                                        ),
                                        onTap: () async {
                                          DateTime? picked = await showDatePicker(
                                            context: context,
                                            initialDate: _startDate ?? DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2101),
                                          );
                                          if (picked != null) {
                                            setState(() {
                                              _startDate = picked;
                                            });
                                          }
                                        },
                                        controller: TextEditingController(
                                          text: _startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : '',
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.0),
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: 'إلى تاريخ',
                                          border: OutlineInputBorder(),
                                        ),
                                        onTap: () async {
                                          DateTime? picked = await showDatePicker(
                                            context: context,
                                            initialDate: _endDate ?? DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2101),
                                          );
                                          if (picked != null) {
                                            setState(() {
                                              _endDate = picked;
                                            });
                                          }
                                        },
                                        controller: TextEditingController(
                                          text: _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : '',
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.0),
                                    ElevatedButton(
                                      onPressed: _fetchReports,
                                      child: Text('عرض'),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: FutureBuilder<List<TransactionReport>>(
                                  future: _transactionReports,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(color: Colors.red, fontSize: 16),
                                          textAlign: TextAlign.right,
                                        ),
                                      );
                                    } else if (snapshot.hasData) {
                                      final transactions = snapshot.data!;
                                      return transactions.isNotEmpty
                                          ? ListView.builder(
                                        itemCount: transactions.length,
                                        itemBuilder: (context, index) {
                                          final transaction = transactions[index];
                                          final createdOnDate = DateTime.parse(transaction.createdOn);
                                          final formattedDateTime = DateFormat('dd/MM/yyyy HH:mm').format(createdOnDate);
                                          Icon statusIcon;
                                          Color statusColor;
                                          String statusText;

                                          switch (transaction.status) {
                                            case 0:
                                              statusIcon = Icon(Icons.access_time, color: Colors.orange);
                                              statusColor = Colors.orange;
                                              statusText = 'قيد التنفيذ';
                                              break;
                                            case 1:
                                              statusIcon = Icon(Icons.check_circle, color: Colors.green);
                                              statusColor = Colors.green;
                                              statusText = 'نجحت العملية';
                                              break;
                                            case 2:
                                              statusIcon = Icon(Icons.cancel, color: Colors.redAccent);
                                              statusColor = Colors.redAccent;
                                              statusText = 'فشلت العملية';
                                              break;
                                            default:
                                              statusIcon = Icon(Icons.help, color: Colors.grey);
                                              statusColor = Colors.grey;
                                              statusText = 'غير محدد';
                                              break;
                                          }

                                          return Container(
                                            margin: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 22.0),
                                            padding: const EdgeInsets.all(16.0),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.blue.shade100,
                                                  Colors.grey.shade50,
                                                  Colors.white54,
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                              borderRadius: BorderRadius.circular(10.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.blue.shade300.withOpacity(.23),
                                                  spreadRadius: 1,
                                                  blurRadius: 10,
                                                  offset: Offset(3, -2),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Center(
                                                  child: Text(
                                                    transaction.productName ?? 'غير محدد',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: screenHeight * 0.025,
                                                      fontWeight: FontWeight.w900,
                                                      height: 1.4,
                                                    ),
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(height: 8.0),
                                                Center(
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      statusIcon,
                                                      SizedBox(width: 5),
                                                      Text(
                                                        statusText,
                                                        style: TextStyle(
                                                          fontSize: screenHeight * 0.022,
                                                          fontWeight: FontWeight.w600,
                                                          color: statusColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 8.0),
                                                Center(
                                                  child: Text(
                                                    'الرقم : ${transaction.mobile}',
                                                    style: TextStyle(
                                                      fontSize: screenHeight * 0.02,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 8.0),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      'الكمية : ${transaction.amount.toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                        fontSize: screenHeight * 0.02,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    Text(
                                                      'السعر : ${transaction.price.toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                        fontSize: screenHeight * 0.02,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8.0),
                                                Text(
                                                  'تاريخ العملية : $formattedDateTime',
                                                  style: TextStyle(
                                                    fontSize: screenHeight * 0.02,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                          : Center(child: Text('لا توجد بيانات', textAlign: TextAlign.right));
                                    } else {
                                      return Center(child: Text('لا توجد بيانات', textAlign: TextAlign.right));
                                    }
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                        return Center(child: Text('No data available'));
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  DateTime parseDateTime(String dateTimeString) {
    try {
      return DateTime.parse(dateTimeString);
    } catch (e) {
      print('Error parsing date: $e');
      return DateTime.now();
    }
  }

  Widget _buildOptionButton(BuildContext context, String title, Color c1, Color c2) {
    IconData icon;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    if (title == 'العاب') {
      icon = Icons.videogame_asset;
    } else if (title == 'حزم') {
      icon = Icons.shopping_bag;
    } else if (title == 'رصيد') {
      icon = Icons.account_balance_wallet;
    } else {
      icon = Icons.help;
    }

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [c1, c2],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              _handleButtonPress(context, title);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 28, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenHeight * 0.028,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleButtonPress(BuildContext context, String title) {
    if (title == 'العاب') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GamesPage()),
      );
    } else    if (title == 'حزم') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GamesPage2()),
      );
    }
    else    if (title == 'رصيد') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GamesPage3()),
      );
    }
  }


  Widget promoCard(String image, String title) {
    return GestureDetector(
      child: AspectRatio(
        aspectRatio: 2.62 / 3,
        child: Container(
          margin: EdgeInsets.only(right: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(image),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                stops: [0.1, 0.9],
                colors: [
                  Colors.black.withOpacity(.8),
                  Colors.black.withOpacity(.1),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      color:Commoncolors.c9,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('d/M/y h:mm a').format(dateTime);
  }
}

class AccountInfo {
  final String userFullName;
  final double refillLimit;
  final double balance;

  AccountInfo({
    required this.userFullName,
    required this.refillLimit,
    required this.balance,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      userFullName: json['userFullName'] ?? '',
      refillLimit: (json['refillLimit'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userFullName': userFullName,
      'refillLimit': refillLimit,
      'balance': balance,
    };
  }
}
Future<AccountInfo> fetchAccountInfo(String token) async {
  final response = await http.get(
    Uri.parse('https://ultratopup.com/api/mobile/test/GetAccountInfo'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return AccountInfo.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load account info');
  }
}

class TransactionReport {
  final int id;
  final String mobile;
  final int carrierId;
  final double amount;
  final double price;
  final String productName;
  final String createdOn;
  final int status;

  TransactionReport({
    required this.id,
    required this.mobile,
    required this.carrierId,
    required this.amount,
    required this.price,
    required this.productName,
    required this.createdOn,
    required this.status,
  });

  factory TransactionReport.fromJson(Map<String, dynamic> json) {
    return TransactionReport(
      id: json['id'],
      mobile: json['mobile'],
      carrierId: json['carrierId'],
      amount: json['amount'].toDouble(),
      price: json['price'].toDouble(),
      productName: json['productName'] ?? '',
      createdOn: json['createdOn'],
      status: json['status'],
    );
  }
}
Future<List<TransactionReport>> fetchTransactionReports(String token) async {
  try {
    final response = await http.get(
      Uri.parse('https://ultratopup.com/api/mobile/test/GetReport'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body) as List;
      return jsonData.map((item) => TransactionReport.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load transaction reports');
    }
  } catch (e) {
    throw Exception('Failed to load transaction reports');
  }
}
Future<List<TransactionReport>>
fetchTransactionReports2(String token, String startDate, String endDate)
async {
  try {
    final response = await http.get(
      Uri.parse('https://ultratopup.com/api/mobile/test/GetReport?${startDate}=Startdate&${endDate}=Enddate'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body) as List;
      return jsonData.map((item) => TransactionReport.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load transaction reports');
    }
  } catch (e) {
    throw Exception('Failed to load transaction reports');
  }
}
