// /import 'package:billingapp/constants.dart';
// import 'package:billingapp/models/payments.dart';
// import 'package:billingapp/screens/viewpayments/singlepayment.dart';
// import 'package:bouncing_widget/bouncing_widget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class ViewPayments extends StatefulWidget {
//   const ViewPayments({Key? key}) : super(key: key);

//   @override
//   State<ViewPayments> createState() => _ViewPaymentsState();
// }

// class _ViewPaymentsState extends State<ViewPayments> {
//   String fromDate = '';
//   String todate = '';
//   bool filter = false;
//   bool foundFilteredBills = false;
//   List<Payments> filterPayments = [];
//   List<Payments> createdpaymnets = [
//     Payments('paymnetid', '24/4/2022', '1000', 'Water payment', '',
//         'Fridah Milly', '072222812', '34AX12UXL89', 'unallocated'),
//     Payments('paymnetid', '24/5/2022', '1000', 'Water payment', '',
//         'Kevin Waweru', '0723124812', 'PA3453L89', 'unallocated'),
//     Payments('paymnetid', '24/6/2022', '1000', 'Water payment', '',
//         'James Ford', '0744142842', 'PAX12UXL89', 'allocated'),
//     Payments('paymnetid', '24/7/2022', '1000', 'Water payment', '',
//         'MIlly Onrr', '0745122812', '34AX12UXL89', 'unallocated'),
//     Payments('paymnetid', '24/8/2022', '1000', 'Water payment', '',
//         'Peter Moony', '0704622812', 'PAX12UXL8', 'allocated'),
//     Payments('paymnetid', '24/8/2022', '1000', 'Water payment', '',
//         'Kylian Mbappe', '0734162712', '34AX12UXL89', 'unallocated'),
//     Payments('paymnetid', '24/8/2022', '1000', 'Water payment', '',
//         'Julian Forsure', '0704127812', 'PAX12UXL89', 'unallocated'),
//     Payments('paymnetid', '24/8/2022', '1000', 'Water payment', '',
//         'Kenny Pure', '0713123852', '34AX12UXL89', 'allocated'),
//     Payments('paymnetid', '24/8/2022', '1000', 'Water payment', '',
//         'Peter Moony', '0704622812', 'PAX12UXL8', 'allocated'),
//     Payments('paymnetid', '24/8/2022', '1000', 'Water payment', '',
//         'Kylian Mbappe', '0734162712', '34AX12UXL89', 'unallocated'),
//     Payments('paymnetid', '24/8/2022', '1000', 'Water payment', '',
//         'Julian Forsure', '0704127812', 'PAX12UXL89', 'unallocated'),
//     Payments('paymnetid', '24/8/2022', '1000', 'Water payment', '',
//         'Kenny Pure', '0713123852', '34AX12UXL89', 'allocated'),
//   ];

//   List<Payments> filterCreatedBills(fromdate, todate) {
//     List<Payments> results = [];
//     // var start = dateformat.parse(fromDate);
//     // var end = dateformat.parse(todate);

//     if (fromdate.isEmpty && todate.isEmpty) {
//       setState(() {});
//       results = createdpaymnets;
//     } else { 
//       for (var i = 0; i < createdpaymnets.length; i += 1) {
//         var date = (createdpaymnets[i].date);
//         if (date.compareTo(fromdate) >= 0 && date.compareTo(todate) <= 0) {
//           results.add(createdpaymnets[i]);
//         }
//       }
//     }
//     setState(() {
//       filterPayments = results;
//     });

//     return results;
//   }

//   @override
//   void initState() {
//     filterPayments = createdpaymnets;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: primaryColor,
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
//             child: Row(
//               children: [
//                 SizedBox(
//                   width: width * 0.09,
//                 ),
//                 BouncingWidget(
//                   onPressed: () {
//                     showfromDatePicker();
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: primaryColor,
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(18)),
//                         border:
//                             Border.all(color: secondaryColorfaded, width: 3)),
//                     child: SizedBox(
//                       height: 25,
//                       child: Center(
//                           child: Row(
//                         children: [
//                           const SizedBox(
//                             width: 8,
//                           ),
//                           SizedBox(
//                             height: 15,
//                             width: 15,
//                             child: SvgPicture.asset(
//                               'assets/icons/date.svg',
//                               color: secondaryColorfaded,
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 8,
//                           ),
//                           fromDate.isEmpty
//                               ? const Text(
//                                   'From Date',
//                                   style: TextStyle(
//                                       fontSize: 10,
//                                       color: secondaryColor,
//                                       fontFamily: 'AvenirNext',
//                                       fontWeight: FontWeight.w600),
//                                 )
//                               : Text(
//                                   '${DateTime.parse(fromDate).toLocal().day.toString()}/${DateTime.parse(fromDate).toLocal().month.toString()}/${DateTime.parse(fromDate).toLocal().year.toString()}',
//                                   style: const TextStyle(
//                                       color: secondaryColor,
//                                       fontFamily: 'AvenirNext',
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                           const SizedBox(
//                             width: 8,
//                           ),
//                         ],
//                       )),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 BouncingWidget(
//                   onPressed: () {
//                     showtoDatePicker();
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: primaryColor,
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(18)),
//                         border:
//                             Border.all(color: secondaryColorfaded, width: 3)),
//                     child: SizedBox(
//                       height: 25,
//                       child: Center(
//                           child: Row(
//                         children: [
//                           const SizedBox(
//                             width: 8,
//                           ),
//                           SizedBox(
//                             height: 15,
//                             width: 15,
//                             child: SvgPicture.asset(
//                               'assets/icons/date.svg',
//                               color: secondaryColorfaded,
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 8,
//                           ),
//                           todate.isEmpty
//                               ? const Text(
//                                   'To Date',
//                                   style: TextStyle(
//                                       fontSize: 10,
//                                       color: secondaryColor,
//                                       fontFamily: 'AvenirNext',
//                                       fontWeight: FontWeight.w600),
//                                 )
//                               : Text(
//                                   '${DateTime.parse(todate).toLocal().day.toString()}/${DateTime.parse(todate).toLocal().month.toString()}/${DateTime.parse(todate).toLocal().year.toString()}',
//                                   style: const TextStyle(
//                                       color: secondaryColor,
//                                       fontFamily: 'AvenirNext',
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                           const SizedBox(
//                             width: 8,
//                           ),
//                         ],
//                       )),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 BouncingWidget(
//                   onPressed: () {
//                     if (fromDate.isEmpty) {
//                       Fluttertoast.showToast(
//                           msg: "Select from date",
//                           toastLength: Toast.LENGTH_LONG,
//                           gravity: ToastGravity.BOTTOM,
//                           backgroundColor: primaryColor,
//                           textColor: altColor,
//                           fontSize: 16.0);
//                     } else if (todate.isEmpty) {
//                       Fluttertoast.showToast(
//                           msg: "Select to date",
//                           toastLength: Toast.LENGTH_LONG,
//                           gravity: ToastGravity.BOTTOM,
//                           backgroundColor: primaryColor,
//                           textColor: altColor,
//                           fontSize: 16.0);
//                     } else {
//                       setState(() {
//                         filter = true;
//                         var response = filterCreatedBills(
//                             '${DateTime.parse(fromDate).toLocal().day.toString()}/${DateTime.parse(fromDate).toLocal().month.toString()}/${DateTime.parse(fromDate).toLocal().year.toString()}',
//                             '${DateTime.parse(todate).toLocal().day.toString()}/${DateTime.parse(todate).toLocal().month.toString()}/${DateTime.parse(todate).toLocal().year.toString()}');
//                         if (response.isEmpty) {
//                           Fluttertoast.showToast(
//                               msg: "No payments exist for that date range",
//                               toastLength: Toast.LENGTH_LONG,
//                               gravity: ToastGravity.BOTTOM,
//                               backgroundColor: primaryColor,
//                               textColor: altColor,
//                               fontSize: 16.0);
//                         } else {
//                           setState(() {
//                             foundFilteredBills = true;
//                           });
//                         }
//                       });
//                     }
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: primaryColor,
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(18)),
//                         border:
//                             Border.all(color: secondaryColorfaded, width: 3)),
//                     child: SizedBox(
//                       height: 25,
//                       child: Center(
//                           child: Row(
//                         children: [
//                           const SizedBox(
//                             width: 8,
//                           ),
//                           SizedBox(
//                             height: 15,
//                             width: 15,
//                             child: SvgPicture.asset(
//                               'assets/icons/filter.svg',
//                               color: secondaryColorfaded,
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 8,
//                           ),
//                           const Text(
//                             'Filter',
//                             style: TextStyle(
//                                 fontSize: 10,
//                                 color: secondaryColor,
//                                 fontFamily: 'AvenirNext',
//                                 fontWeight: FontWeight.w600),
//                           ),
//                           const SizedBox(
//                             width: 15,
//                           ),
//                         ],
//                       )),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // const SizedBox(
//           //   height: 10,
//           // ),
//           Expanded(
//               child: filterPayments.isNotEmpty
//                   ? Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: BouncingWidget(
//                         onPressed: () {},
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           color: cardyColor,
//                           child: ListView.builder(
//                               itemCount: filterPayments.length,
//                               itemBuilder: (context, index) {
//                                 return Column(
//                                   children: [
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       children: [
//                                         const SizedBox(
//                                           width: 0.1,
//                                         ),
//                                         SizedBox(
//                                           width: 50,
//                                           child: Text(
//                                             filterPayments[index].date,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: const TextStyle(
//                                                 color: secondaryColor,
//                                                 fontWeight: FontWeight.w800,
//                                                 fontFamily: 'AvenirNext',
//                                                 fontSize: 10),
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 5,
//                                         ),
//                                         SizedBox(
//                                           width: 50,
//                                           child: Text(
//                                             filterPayments[index].name,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: const TextStyle(
//                                                 color: secondaryColor,
//                                                 fontWeight: FontWeight.w800,
//                                                 fontFamily: 'AvenirNext',
//                                                 fontSize: 10),
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 5,
//                                         ),
//                                         SizedBox(
//                                           width: 50,
//                                           child: Text(
//                                             filterPayments[index]
//                                                 .amount
//                                                 .toString(),
//                                             overflow: TextOverflow.ellipsis,
//                                             style: const TextStyle(
//                                                 color: secondaryColor,
//                                                 fontWeight: FontWeight.w800,
//                                                 fontFamily: 'AvenirNext',
//                                                 fontSize: 10),
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 5,
//                                         ),
//                                         SizedBox(
//                                           width: 50,
//                                           child: Text(
//                                             filterPayments[index].paymentref,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: const TextStyle(
//                                                 color: secondaryColor,
//                                                 fontWeight: FontWeight.w800,
//                                                 fontFamily: 'AvenirNext',
//                                                 fontSize: 10),
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 5,
//                                         ),
//                                         BouncingWidget(
//                                           onPressed: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       SinglePayment(
//                                                         amount: filterPayments[
//                                                                 index]
//                                                             .amount,
//                                                         name: filterPayments[
//                                                                 index]
//                                                             .name,
//                                                         paymentstatus:
//                                                             filterPayments[
//                                                                     index]
//                                                                 .paymentstatus,
//                                                         phoneNumber:
//                                                             filterPayments[
//                                                                     index]
//                                                                 .phone,
//                                                         payref: filterPayments[
//                                                                 index]
//                                                             .paymentref,
//                                                       )),
//                                             );
//                                           },
//                                           child: Container(
//                                             height: 25,
//                                             width: 50,
//                                             color: Colors.transparent,
//                                             child: Container(
//                                               height: 10,
//                                               width: 50,
//                                               decoration: const BoxDecoration(
//                                                 color: secondaryColorfaded,
//                                                 borderRadius: BorderRadius.all(
//                                                     Radius.circular(4)),
//                                               ),
//                                               child: const Center(
//                                                   child: Text('View',
//                                                       style: TextStyle(
//                                                           color: Colors.white,
//                                                           fontFamily:
//                                                               'AvenirNext',
//                                                           fontSize: 12,
//                                                           fontWeight: FontWeight
//                                                               .w600))),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(
//                                       height: defaultPadding,
//                                     ),
//                                   ],
//                                 );
//                               }),
//                         ),
//                       ),
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Card(
//                         elevation: 1,
//                         color: cardyColor,
//                         child: ListView.builder(
//                             itemCount: createdpaymnets.length,
//                             itemBuilder: (context, index) {
//                               return Column(
//                                 children: [
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       const SizedBox(
//                                         width: 0.1,
//                                       ),
//                                       SizedBox(
//                                         width: 50,
//                                         child: Text(
//                                           createdpaymnets[index].date,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                               color: secondaryColor,
//                                               fontWeight: FontWeight.w800,
//                                               fontFamily: 'AvenirNext',
//                                               fontSize: 10),
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         width: 5,
//                                       ),
//                                       SizedBox(
//                                         width: 50,
//                                         child: Text(
//                                           createdpaymnets[index].name,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                               color: secondaryColor,
//                                               fontWeight: FontWeight.w800,
//                                               fontFamily: 'AvenirNext',
//                                               fontSize: 10),
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         width: 5,
//                                       ),
//                                       SizedBox(
//                                         width: 50,
//                                         child: Text(
//                                           createdpaymnets[index]
//                                               .amount
//                                               .toString(),
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                               color: secondaryColor,
//                                               fontWeight: FontWeight.w800,
//                                               fontFamily: 'AvenirNext',
//                                               fontSize: 10),
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         width: 5,
//                                       ),
//                                       SizedBox(
//                                         width: 50,
//                                         child: Text(
//                                           createdpaymnets[index].paymentref,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                               color: secondaryColor,
//                                               fontWeight: FontWeight.w800,
//                                               fontFamily: 'AvenirNext',
//                                               fontSize: 10),
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         width: 5,
//                                       ),
//                                       BouncingWidget(
//                                         onPressed: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     SinglePayment(
//                                                       amount:
//                                                           createdpaymnets[index]
//                                                               .amount,
//                                                       name:
//                                                           createdpaymnets[index]
//                                                               .name,
//                                                       paymentstatus:
//                                                           createdpaymnets[index]
//                                                               .paymentstatus,
//                                                       payref:
//                                                           createdpaymnets[index]
//                                                               .paymentref,
//                                                       phoneNumber:
//                                                           createdpaymnets[index]
//                                                               .phone,
//                                                     )),
//                                           );
//                                         },
//                                         child: Container(
//                                           height: 25,
//                                           width: 50,
//                                           color: Colors.transparent,
//                                           child: Container(
//                                             height: 10,
//                                             width: 50,
//                                             decoration: const BoxDecoration(
//                                               color: secondaryColorfaded,
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(4)),
//                                             ),
//                                             child: const Center(
//                                                 child: Text('View',
//                                                     style: TextStyle(
//                                                         color: Colors.white,
//                                                         fontFamily:
//                                                             'AvenirNext',
//                                                         fontSize: 12,
//                                                         fontWeight:
//                                                             FontWeight.w600))),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(
//                                     height: defaultPadding,
//                                   ),
//                                 ],
//                               );
//                             }),
//                       ),
//                     )),

//           Align(
//             alignment: Alignment.bottomCenter,
//             child: BouncingWidget(
//               onPressed: () {},
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: Container(
//                   width: 400,
//                   height: 50,
//                   decoration: const BoxDecoration(
//                     color: secondaryColor,
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                   ),
//                   child: const Center(
//                     child: Text(
//                       'Download payments',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontFamily: 'AvenirNext',
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // const SizedBox(
//           //   height: 20,
//           // ),

//           // const SizedBox(
//           //   height: 20,
//           // ),
//         ],
//       ),
//     );
//   }

//   void showfromDatePicker() {
//     showCupertinoModalPopup(
//         context: context,
//         builder: (BuildContext builder) {
//           return Container(
//             height: MediaQuery.of(context).copyWith().size.height * 0.25,
//             color: primaryColor,
//             child: CupertinoDatePicker(
//               mode: CupertinoDatePickerMode.date,
//               onDateTimeChanged: (value) {
//                 // ignore: unrelated_type_equality_checks, unnecessary_null_comparison
//                 if (value != null && value != fromDate) {
//                   setState(() {
//                     fromDate = value.toString();
//                   });
//                 }
//               },
//               initialDateTime: DateTime.now(),
//               minimumYear: 2019,
//               maximumYear: 2026,
//             ),
//           );
//         });
//   }

//   void showtoDatePicker() {
//     showCupertinoModalPopup(
//         context: context,
//         builder: (BuildContext builder) {
//           return Container(
//             height: MediaQuery.of(context).copyWith().size.height * 0.25,
//             color: primaryColor,
//             child: CupertinoDatePicker(
//               mode: CupertinoDatePickerMode.date,
//               onDateTimeChanged: (value) {
//                 // ignore: unrelated_type_equality_checks, unnecessary_null_comparison
//                 if (value != null && value != todate) {
//                   setState(() {
//                     todate = value.toString();
//                   });
//                 }
//               },
//               initialDateTime: DateTime.now(),
//               minimumYear: 2019,
//               maximumYear: 2026,
//             ),
//           );
//         });
//   }
// }
