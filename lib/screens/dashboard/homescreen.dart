import 'dart:math';
import 'package:billingapp/constants.dart';
import 'package:billingapp/screens/createbill/createbill.dart';
import 'package:billingapp/screens/createinvoice/createinvoice.dart';
import 'package:billingapp/screens/dashboard/linetitles.dart';
import 'package:billingapp/screens/profile/profile.dart';
import 'package:billingapp/screens/signin/signin.dart';
import 'package:billingapp/screens/viewbills/viewbills.dart';
import 'package:billingapp/screens/viewinvoices/viewinvoice.dart';
import 'package:billingapp/screens/viewpayments/viewpays.dart';
import 'package:billingapp/services/firebaseserivices.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  final inactiveColor = Colors.black54;
  String? name;
  bool appisLoading = false;
  double totalbillsmade = 0;
  double totalPaymentsmade = 0;
  double totalbillsmadepercent = 0;
  double totalPaymentsmadepercent = 0;
  List<Map<dynamic, dynamic>> bills = [];
  List<Map<dynamic, dynamic>> pay = [];
  bool hasNoChartValues = false;
  Widget getBody() {
    List<Widget> pages = [
      DashBoard(
        name: name.toString(),
        // name: name,
        // hasNoChartValues: hasNoChartValues,
        // paiChartSelectionDatas: paiChartSelectionDatas,
        // dummyData1: dummyData1
      ),
      const CreateInvoice(),
      const CreateBill(),
      const ViewInvoices(),
      const ViewBills(),
      const Pay(),
    ];
    return IndexedStack(
      index: currentIndex,
      children: pages,
    );
  }

  List<PieChartSectionData> paiChartSelectionDatas = [];

  final List<FlSpot> dummyData1 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  double scaleFactor = 1.0;

  Future getAllUserDetails() async {
    setState(() {
      appisLoading = true;
    });

    var response = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseServices().getUserId())
        .get();

    setState(() {
      name = response.data()!['name'];
    });

    final CollectionReference paysRef =
        FirebaseFirestore.instance.collection("payments");
    final CollectionReference billsRef =
        FirebaseFirestore.instance.collection("bills");
    // ignore: prefer_typing_uninitialized_variables
    var payment;
    var payments = await paysRef
        .where('userid', isEqualTo: FirebaseServices().getUserId())
        .get();

    var paymentss = payments.docs;

    // ignore: prefer_typing_uninitialized_variables
    var amount;
    for (payment in paymentss) {
      setState(() {
        pay.add(payment.data());
      });
    }

    for (amount in pay) {
      setState(() {
        totalPaymentsmade = totalPaymentsmade + double.parse(amount['amount']);
      });
    }

    // ignore: prefer_typing_uninitialized_variables
    var bill;
    var allbills = await billsRef
        .where('userid', isEqualTo: FirebaseServices().getUserId())
        .get();

    for (bill in allbills.docs) {
      setState(() {
        bills.add(bill.data());
      });
    }

    for (amount in bills) {
      setState(() {
        totalbillsmade = totalbillsmade + double.parse(amount['amount']);
      });
    }

    setState(() {
      totalPaymentsmadepercent =
          (totalPaymentsmade * 100) / (totalPaymentsmade + totalbillsmade);
      totalbillsmadepercent =
          (totalbillsmade * 100) / (totalbillsmade + totalPaymentsmade);

      if (totalPaymentsmade < 1 && totalbillsmade < 1) {
        setState(() {
          hasNoChartValues = true;
        });
        paiChartSelectionDatas.add(
          PieChartSectionData(
              color: primaryTwo,
              value: 100,
              radius: 25,
              titlePositionPercentageOffset: 2.0,
              titleStyle: const TextStyle(
                  fontSize: 1,
                  color: primaryTwo,
                  fontFamily: 'AvenirNext',
                  fontWeight: FontWeight.w600)),
        );

        paiChartSelectionDatas.add(
          PieChartSectionData(
              color: secondaryColor,
              value: 0.0,
              radius: 22,
              titlePositionPercentageOffset: 2.0,
              titleStyle: const TextStyle(
                  color: secondaryColor,
                  fontFamily: 'AvenirNext',
                  fontWeight: FontWeight.w600)),
        );
      } else {
        paiChartSelectionDatas.add(
          PieChartSectionData(
              color: primaryTwo,
              value: totalPaymentsmadepercent.round().toDouble(),
              title: '${totalPaymentsmadepercent.round().toString()} %',
              showTitle: true,
              radius: 25,
              titlePositionPercentageOffset: 2.0,
              titleStyle: const TextStyle(
                  color: primaryTwo,
                  fontFamily: 'AvenirNext',
                  fontWeight: FontWeight.w600)),
        );

        paiChartSelectionDatas.add(
          PieChartSectionData(
              color: secondaryColor,
              value: totalbillsmadepercent.round().toDouble(),
              showTitle: true,
              title: '${totalbillsmadepercent.round().toString()} %',
              radius: 22,
              titlePositionPercentageOffset: 2.0,
              titleStyle: const TextStyle(
                  color: secondaryColor,
                  fontFamily: 'AvenirNext',
                  fontWeight: FontWeight.w600)),
        );
      }
    });

    setState(() {});

    setState(() {
      appisLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return appisLoading == false
        ? Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedLabelStyle: const TextStyle(
                  fontSize: 10,
                  fontFamily: 'AvenirNext',
                  fontWeight: FontWeight.w600,
                  color: primaryThree),
              unselectedLabelStyle: const TextStyle(
                  fontSize: 10,
                  fontFamily: 'AvenirNext',
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
              unselectedItemColor: Colors.black,
              selectedItemColor: primaryThree,
              showUnselectedLabels: true,
              onTap: (index) => setState(() => currentIndex = index),
              currentIndex: currentIndex,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: currentIndex == 0
                      ? Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/home.svg',
                                color: primaryThree,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/home.svg',
                                color: secondaryColorfaded,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: currentIndex == 1
                      ? Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/invoice.svg',
                                color: primaryThree,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/invoice.svg',
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        ),
                  label: 'New Invoice',
                ),
                BottomNavigationBarItem(
                  icon: currentIndex == 2
                      ? Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/bill.svg',
                                color: primaryThree,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/bill.svg',
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        ),
                  label: 'New Bill',
                ),
                BottomNavigationBarItem(
                  icon: currentIndex == 3
                      ? Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/invoicess.svg',
                                color: primaryThree,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/invoicess.svg',
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        ),
                  label: 'Invoices',
                ),
                BottomNavigationBarItem(
                  icon: currentIndex == 3
                      ? Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/viewinvoice.svg',
                                color: primaryThree,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/viewinvoice.svg',
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        ),
                  label: 'View bills',
                ),
                BottomNavigationBarItem(
                  icon: currentIndex == 4
                      ? Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/pay.svg',
                                color: primaryThree,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/pay.svg',
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        ),
                  label: 'Payments',
                ),
              ],
            ),
            body: getBody(),
          )
        : const Scaffold(
            body: Center(
              child: Center(
                child: CircularProgressIndicator(
                  color: primaryThree,
                  strokeWidth: 2,
                ),
              ),
            ),
          );
  }
}

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key, required this.name}) : super(key: key);
  final String name;
  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with TickerProviderStateMixin {
  final List<Color> gradientColors = [
    const Color(0xFF5BD271),
    const Color(0xFF5BD2AC)
  ];
  final List<Color> gradient2Colors = [
    const Color(0xFF5BD271),
    const Color(0xFFFFFFFF)
  ];
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            BouncingWidget(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
              },
              child: SizedBox(
                height: 35,
                width: 35,
                child: SvgPicture.asset(
                  'assets/icons/person.svg',
                ),
              ),
            ),
            SizedBox(
              width: width / 4,
            ),
            const Text(
              'Dashboard',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'AvenirNext',
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
        actions: <Widget>[
          PopupMenuButton(
            elevation: 2,
            icon: SizedBox(
              height: 25,
              width: 25,
              child: SvgPicture.asset(
                'assets/icons/threedots.svg',
                color: Colors.black,
              ),
            ),
            itemBuilder: (ctx) => [
              buildPopupMenuItem(context, 'Logout'),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              "Hello",
              style: TextStyle(
                color: Colors.black45,
                fontSize: 15,
                fontFamily: 'AvenirNext',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              widget.name,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontFamily: 'AvenirNext',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TabBar(
                labelColor: Colors.black,
                labelPadding: const EdgeInsets.only(left: 20, right: 20),
                isScrollable: true,
                unselectedLabelColor: Colors.grey,
                controller: tabController,
                indicator: const BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: primaryThree, width: 5)),
                ),
                tabs: const [
                  Tab(text: 'Week'),
                  Tab(text: 'Month'),
                  Tab(text: 'Year'),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: TabBarView(
              controller: tabController,
              children: [
                WeeklyAnalytics(gradientColors: gradientColors, width: width),
                MonthlyAnalytics(gradientColors: gradientColors, width: width),
                YearlyAnalytics(gradientColors: gradientColors, width: width),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WeeklyAnalytics extends StatelessWidget {
  const WeeklyAnalytics({
    Key? key,
    required this.gradientColors,
    required this.width,
  }) : super(key: key);

  final List<Color> gradientColors;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Transform.translate(
              offset: const Offset(-15.0, 2.0),
              child: LineChart(LineChartData(
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 6,
                  titlesData: WeeklyLineTitle.getTitleData(),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.transparent,
                          strokeWidth: 0,
                        );
                      },
                      drawVerticalLine: true,
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.black12,
                          strokeWidth: 1.5,
                        );
                      }),
                  lineBarsData: [
                    LineChartBarData(
                        spots: [
                          FlSpot(0, 3),
                          FlSpot(1.6, 2),
                          FlSpot(2.3, 5),
                          FlSpot(3.9, 2.5),
                          FlSpot(4.0, 4),
                          FlSpot(4.5, 3),
                          FlSpot(6.0, 4),
                        ],
                        isCurved: true,
                        colors: gradientColors,
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                            show: true,
                            colors: gradientColors
                                .map((color) => color.withOpacity(0.1))
                                .toList())),
                  ])),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Total paid',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Ksh 94,000',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'BIlls',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Ksh 8400',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Invoices',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Ksh 9500',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BouncingWidget(
                onPressed: () {},
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        width: 100,
                        child: const Center(
                          child: Text(
                            'Total paid',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: SizedBox(
                          width: 80,
                          child: SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                PieChart(
                                  PieChartData(
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 30,
                                    startDegreeOffset: -90,
                                    sections: [
                                      PieChartSectionData(
                                        color: const Color(0xFF565AC9),
                                        value: 60.0,
                                        showTitle: false,
                                        radius: 5,
                                      ),
                                      PieChartSectionData(
                                        color: const Color(0xFFE2F2E7),
                                        showTitle: false,
                                        value: 40.0,
                                        radius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned.fill(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(height: 2),
                                      Text(
                                        '120',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
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
              BouncingWidget(
                onPressed: () {},
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        width: 100,
                        child: const Center(
                          child: Text(
                            'Bills paid',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: SizedBox(
                          width: 80,
                          child: SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                PieChart(
                                  PieChartData(
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 30,
                                    startDegreeOffset: -90,
                                    sections: [
                                      PieChartSectionData(
                                        color: const Color(0xFF4FA6C2),
                                        showTitle: false,
                                        value: 40.0,
                                        radius: 5,
                                      ),
                                      PieChartSectionData(
                                        color: const Color(0xFFE2F2E7),
                                        value: 60.0,
                                        showTitle: false,
                                        radius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned.fill(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(height: 2),
                                      Text(
                                        '87',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
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
              BouncingWidget(
                onPressed: () {},
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        width: 100,
                        child: const Center(
                          child: Text(
                            'Invoice paid',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: SizedBox(
                          width: 80,
                          child: SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                PieChart(
                                  PieChartData(
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 30,
                                    startDegreeOffset: -90,
                                    sections: [
                                      PieChartSectionData(
                                        color: primaryThree,
                                        value: 60.0,
                                        showTitle: false,
                                        radius: 5,
                                      ),
                                      PieChartSectionData(
                                        color: const Color(0xFFE2F2E7),
                                        showTitle: false,
                                        value: 40.0,
                                        radius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned.fill(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(height: 2),
                                      Text(
                                        '90',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
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
            ],
          ),
        ),
      ],
    );
  }
}

class MonthlyAnalytics extends StatelessWidget {
  const MonthlyAnalytics({
    Key? key,
    required this.gradientColors,
    required this.width,
  }) : super(key: key);

  final List<Color> gradientColors;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Transform.translate(
              offset: const Offset(-10.0, 2.0),
              child: LineChart(LineChartData(
                  minX: 0,
                  maxX: 12,
                  minY: 0,
                  maxY: 6,
                  titlesData: MonthlyLineTitle.getTitleData(),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.transparent,
                          strokeWidth: 0,
                        );
                      },
                      drawVerticalLine: true,
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.black12,
                          strokeWidth: 1.5,
                        );
                      }),
                  lineBarsData: [
                    LineChartBarData(
                        spots: [
                          FlSpot(0, 3),
                          FlSpot(1.6, 2),
                          FlSpot(2.9, 5),
                          FlSpot(4.8, 2.5),
                          FlSpot(5.0, 4),
                          FlSpot(6.5, 3),
                          FlSpot(7.1, 6),
                          FlSpot(7.9, 4),
                          FlSpot(8.0, 6),
                          FlSpot(9.4, 4),
                          FlSpot(10.7, 6),
                          FlSpot(12, 3),
                        ],
                        isCurved: true,
                        colors: gradientColors,
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                            show: true,
                            colors: gradientColors
                                .map((color) => color.withOpacity(0.1))
                                .toList())),
                  ])),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Total paid',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Ksh 94,000',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'BIlls',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Ksh 8400',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Invoices',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Ksh 9500',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BouncingWidget(
                onPressed: () {},
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        width: 100,
                        child: const Center(
                          child: Text(
                            'Total paid',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: SizedBox(
                          width: 80,
                          child: SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                PieChart(
                                  PieChartData(
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 30,
                                    startDegreeOffset: -90,
                                    sections: [
                                      PieChartSectionData(
                                        color: const Color(0xFF565AC9),
                                        value: 60.0,
                                        showTitle: false,
                                        radius: 5,
                                      ),
                                      PieChartSectionData(
                                        color: const Color(0xFFE2F2E7),
                                        showTitle: false,
                                        value: 40.0,
                                        radius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned.fill(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(height: 2),
                                      Text(
                                        '120',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
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
              BouncingWidget(
                onPressed: () {},
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        width: 100,
                        child: const Center(
                          child: Text(
                            'Bills paid',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: SizedBox(
                          width: 80,
                          child: SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                PieChart(
                                  PieChartData(
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 30,
                                    startDegreeOffset: -90,
                                    sections: [
                                      PieChartSectionData(
                                        color: const Color(0xFF4FA6C2),
                                        showTitle: false,
                                        value: 40.0,
                                        radius: 5,
                                      ),
                                      PieChartSectionData(
                                        color: const Color(0xFFE2F2E7),
                                        value: 60.0,
                                        showTitle: false,
                                        radius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned.fill(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(height: 2),
                                      Text(
                                        '87',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
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
              BouncingWidget(
                onPressed: () {},
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        width: 100,
                        child: const Center(
                          child: Text(
                            'Invoice paid',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: SizedBox(
                          width: 80,
                          child: SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                PieChart(
                                  PieChartData(
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 30,
                                    startDegreeOffset: -90,
                                    sections: [
                                      PieChartSectionData(
                                        color: primaryThree,
                                        value: 60.0,
                                        showTitle: false,
                                        radius: 5,
                                      ),
                                      PieChartSectionData(
                                        color: const Color(0xFFE2F2E7),
                                        showTitle: false,
                                        value: 40.0,
                                        radius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned.fill(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(height: 2),
                                      Text(
                                        '90',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
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
            ],
          ),
        ),
      ],
    );
  }
}

class YearlyAnalytics extends StatelessWidget {
  const YearlyAnalytics({
    Key? key,
    required this.gradientColors,
    required this.width,
  }) : super(key: key);

  final List<Color> gradientColors;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Transform.translate(
              offset: const Offset(0.0, 2.0),
              child: LineChart(LineChartData(
                  minX: 0,
                  maxX: 12,
                  minY: 0,
                  maxY: 6,
                  titlesData: YearlyLineTitle.getTitleData(),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.transparent,
                          strokeWidth: 0,
                        );
                      },
                      drawVerticalLine: true,
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.black12,
                          strokeWidth: 1.5,
                        );
                      }),
                  lineBarsData: [
                    LineChartBarData(
                        spots: [
                          FlSpot(0, 3),
                          FlSpot(1.6, 2),
                          FlSpot(2.9, 5),
                          FlSpot(4.8, 2.5),
                          FlSpot(5.0, 4),
                          FlSpot(6.5, 3),
                          FlSpot(7.1, 6),
                          FlSpot(7.9, 4),
                          FlSpot(8.0, 6),
                          FlSpot(9.4, 4),
                          FlSpot(10.7, 6),
                          FlSpot(12, 3),
                        ],
                        isCurved: true,
                        colors: gradientColors,
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                            show: true,
                            colors: gradientColors
                                .map((color) => color.withOpacity(0.1))
                                .toList())),
                  ])),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Total paid',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Ksh 94,000',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'BIlls',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Ksh 8400',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Invoices',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Ksh 9500',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BouncingWidget(
                onPressed: () {},
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        width: 100,
                        child: const Center(
                          child: Text(
                            'Total paid',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: SizedBox(
                          width: 80,
                          child: SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                PieChart(
                                  PieChartData(
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 30,
                                    startDegreeOffset: -90,
                                    sections: [
                                      PieChartSectionData(
                                        color: const Color(0xFF565AC9),
                                        value: 60.0,
                                        showTitle: false,
                                        radius: 5,
                                      ),
                                      PieChartSectionData(
                                        color: const Color(0xFFE2F2E7),
                                        showTitle: false,
                                        value: 40.0,
                                        radius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned.fill(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(height: 2),
                                      Text(
                                        '120',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
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
              BouncingWidget(
                onPressed: () {},
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        width: 100,
                        child: const Center(
                          child: Text(
                            'Bills paid',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: SizedBox(
                          width: 80,
                          child: SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                PieChart(
                                  PieChartData(
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 30,
                                    startDegreeOffset: -90,
                                    sections: [
                                      PieChartSectionData(
                                        color: const Color(0xFF4FA6C2),
                                        showTitle: false,
                                        value: 40.0,
                                        radius: 5,
                                      ),
                                      PieChartSectionData(
                                        color: const Color(0xFFE2F2E7),
                                        value: 60.0,
                                        showTitle: false,
                                        radius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned.fill(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(height: 2),
                                      Text(
                                        '87',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
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
              BouncingWidget(
                onPressed: () {},
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        width: 100,
                        child: const Center(
                          child: Text(
                            'Invoice paid',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: SizedBox(
                          width: 80,
                          child: SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                PieChart(
                                  PieChartData(
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 30,
                                    startDegreeOffset: -90,
                                    sections: [
                                      PieChartSectionData(
                                        color: primaryThree,
                                        value: 60.0,
                                        showTitle: false,
                                        radius: 5,
                                      ),
                                      PieChartSectionData(
                                        color: const Color(0xFFE2F2E7),
                                        showTitle: false,
                                        value: 40.0,
                                        radius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned.fill(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(height: 2),
                                      Text(
                                        '90',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
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
            ],
          ),
        ),
      ],
    );
  }
}
// class DashBoard extends StatefulWidget {
//   const DashBoard({
//     Key? key,
//     required this.paiChartSelectionDatas,
//     required this.dummyData1,
//     required this.name,
//     required this.hasNoChartValues,
//   }) : super(key: key);

//   final List<PieChartSectionData> paiChartSelectionDatas;
//   final List<FlSpot> dummyData1;
//   final String? name;
//   final bool hasNoChartValues;
//   @override
//   State<DashBoard> createState() => _DashBoardState();
// }

// class _DashBoardState extends State<DashBoard> {
//   double scaleFactor = 0.1;
//   onPressed(BuildContext context) {}

//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: false,
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Row(
//           children: [
//             BouncingWidget(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const Profile()),
//                 );
//               },
//               child: SizedBox(
//                 height: 35,
//                 width: 35,
//                 child: SvgPicture.asset(
//                   'assets/icons/person.svg',
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: width / 4,
//             ),
//             const Text(
//               'Dashboard',
//               style: TextStyle(
//                   color: Colors.black,
//                   fontFamily: 'AvenirNext',
//                   fontWeight: FontWeight.w600),
//             )
//           ],
//         ),
//         actions: <Widget>[
//           PopupMenuButton(
//             elevation: 2,
//             icon: SizedBox(
//               height: 25,
//               width: 25,
//               child: SvgPicture.asset(
//                 'assets/icons/threedots.svg',
//                 color: Colors.black,
//               ),
//             ),
//             itemBuilder: (ctx) => [
//               buildPopupMenuItem(context, 'Logout'),
//             ],
//           ),
//         ],
//       ),
//       body: SizedBox(
//         height: MediaQuery.of(context).size.height,
//         child: SingleChildScrollView(
//           physics: const ScrollPhysics(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(
//                 height: 10,
//               ),
// const Padding(
//   padding: EdgeInsets.symmetric(horizontal: 15.0),
//   child: Text(
//     "Hello",
//     style: TextStyle(
//       color: Colors.black45,
//       fontSize: 15,
//       fontFamily: 'AvenirNext',
//       fontWeight: FontWeight.w600,
//     ),
//   ),
//               ),
//               const SizedBox(
//                 height: 7,
//               ),
// Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 15.0),
//   child: Text(
//     widget.name.toString(),
//     style: const TextStyle(
//       color: Colors.black87,
//       fontSize: 18,
//       fontFamily: 'AvenirNext',
//       fontWeight: FontWeight.w600,
//     ),
//   ),
// ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Center(
//                   child: BouncingWidget(
//                     onPressed: () {},
//                     child: Card(
//                       elevation: 2,
//                       color: cardyColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Column(
//                         children: [
//                           const SizedBox(
//                             height: 16,
//                           ),
//                           Row(
//                             children: [
//                               const SizedBox(
//                                 width: 50,
//                               ),
//                               widget.hasNoChartValues == false
//                                   ? const Text(
//                                       'Invoices',
//                                       style: TextStyle(
//                                           color: secondaryColor,
//                                           fontFamily: 'AvenirNext',
//                                           fontWeight: FontWeight.w600),
//                                     )
//                                   : const Text(
//                                       '0 Invoices',
//                                       style: TextStyle(
//                                           color: primaryThree,
//                                           fontFamily: 'AvenirNext',
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               Container(
//                                 height: 10,
//                                 width: 10,
//                                 decoration: BoxDecoration(
//                                   color: widget.hasNoChartValues == false
//                                       ? secondaryColor
//                                       : primaryThree,
//                                   borderRadius: const BorderRadius.all(
//                                       Radius.circular(10)),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 100,
//                               ),
//                               widget.hasNoChartValues == false
//                                   ? const Text(
//                                       'Payments',
//                                       style: TextStyle(
//                                           color: primaryThree,
//                                           fontFamily: 'AvenirNext',
//                                           fontWeight: FontWeight.w600),
//                                     )
//                                   : const Text(
//                                       '0 Pays',
//                                       style: TextStyle(
//                                           color: primaryThree,
//                                           fontFamily: 'AvenirNext',
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               Container(
//                                 height: 10,
//                                 width: 10,
//                                 decoration: const BoxDecoration(
//                                   color: primaryThree,
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(10)),
//                                 ),
//                               ),
//                             ],
//                           ),
// SizedBox(
//   height: 200,
//   width: 300,
//   child: Padding(
//     padding: const EdgeInsets.all(10.0),
//     child: SizedBox(
//       // color: Colors.red,
//       height: 100,
//       child: Stack(
//         children: [
//           PieChart(
//             PieChartData(
//               sectionsSpace: 0,
//               centerSpaceRadius: 50,
//               startDegreeOffset: -90,
//               sections: widget.paiChartSelectionDatas,
//             ),
//           ),
//           Positioned.fill(
//             child: Column(
//               mainAxisAlignment:
//                   MainAxisAlignment.center,
//               children: const [
//                 SizedBox(height: 8),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
// ),
//         ],
//       ),
//     ),
//   ),
// ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               BouncingWidget(
//                 onPressed: () {},
//                 child: Center(
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: 250,
//                         width: double.infinity,
//                         child: Container(
//                           padding: const EdgeInsets.only(
//                               top: 20, bottom: 20, right: 20),
//                           width: double.infinity,
//                           // color: Colors.red,
//                           child: LineChart(
//                             swapAnimationDuration:
//                                 const Duration(milliseconds: 150),
//                             LineChartData(
//                               borderData: FlBorderData(show: false),
//                               lineBarsData: [
//                                 // The red line
//                                 LineChartBarData(
//                                   spots: widget.dummyData1,
//                                   isCurved: true,
//                                   barWidth: 3,
//                                   curveSmoothness: 2.0,
//                                   colors: [
//                                     primaryThree,
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 100,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class DataItem {
  int x;
  double y1;
  double y2;
  double y3;
  DataItem(
      {required this.x, required this.y1, required this.y2, required this.y3});
}

PopupMenuItem buildPopupMenuItem(context, String title) {
  return PopupMenuItem(
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      },
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: secondaryColor,
              fontFamily: 'AvenirNext',
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    ),
  );
}

// class CircleTabIndicator extends Decoration {
//  final Color color;
//  final double radius;

//   CircleTabIndicator(this.color, this.radius)
//   //override createBoxPainter

//   @override
//   BoxPainter createBoxPainter([VoidCallback? onChanged]) {
//     return CircelPainter();
//   }
// }

// class CircelPainter extends BoxPainter {

// //override paint

//   @override
//   void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {

//   }
// }
