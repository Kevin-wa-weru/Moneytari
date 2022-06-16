import 'package:billingapp/constants.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';

class SingleInvoices extends StatefulWidget {
  const SingleInvoices({Key? key, required this.docid}) : super(key: key);
  final String docid;
  @override
  State<SingleInvoices> createState() => _SingleInvoicesState();
}

class _SingleInvoicesState extends State<SingleInvoices>
    with SingleTickerProviderStateMixin {
  String? name;
  String? phone;
  String? amount;
  String? description;
  String? date;
  bool? status;
  bool appisLoading = false;
  bool showBillingContainer = false;

  getspecificInvoice() async {
    setState(() {
      appisLoading = true;
    });

    try {
      var response = await FirebaseFirestore.instance
          .collection("invoices")
          .doc(widget.docid.replaceAll('"', ''))
          .get();
      print(response.data());
      setState(() {
        name = response.data()!['name'];
        phone = response.data()!['phone'];
        amount = response.data()!['amount'];
        description = response.data()!['description'];
        date = response.data()!['dateadded'];
        status = response.data()!['status'];
      });

      setState(() {
        appisLoading = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
      setState(() {
        appisLoading = false;
      });
    }
  }

  Future<void> startPaymentProcessing(
      {required String phone, required double amount}) async {
    setState(() {
      appisLoading = true;
    });
    dynamic transactionInitialisation;
    try {
      transactionInitialisation = await MpesaFlutterPlugin.initializeMpesaSTKPush(
          businessShortCode: "174379",
          transactionType: TransactionType.CustomerPayBillOnline,
          amount: amount,
          partyA: phone,
          partyB: "174379",
          callBackURL: Uri(
              scheme: "https",
              host: "us-central1-onlineshop-b593d.cloudfunctions.net",
              path: "paymentCallback"),
          accountReference: "Moneytari",
          phoneNumber: phone,
          transactionDesc: "demo",
          baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
          passKey:
              "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919");
      var result = transactionInitialisation as Map<String, dynamic>;

      if (result.keys.contains("ResponseCode")) {
        String mResponseCode = result["ResponseCode"];
        // ignore: avoid_print, prefer_interpolation_to_compose_strings
        print("Result Code:" + mResponseCode);
        if (mResponseCode == '0') {
          setState(() {
            appisLoading = false;
          });
        }
      }
    } catch (e) {
      // ignore: prefer_interpolation_to_compose_strings, avoid_print
      print('Exception' + e.toString());
      setState(() {
        appisLoading = false;
      });
    }
  }

  @override
  void initState() {
    getspecificInvoice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appisLoading == false
            ? AppBar(
                leading: IconButton(
                  icon: SizedBox(
                    height: 15,
                    width: 15,
                    child: SizedBox(
                      height: 15,
                      width: 15,
                      child: SvgPicture.asset('assets/icons/cancel.svg',
                          color: Colors.black,
                          height: 10,
                          fit: BoxFit.fitHeight),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                leadingWidth: 50,
                centerTitle: false,
                title: Text(
                  name.toString(),
                  style: const TextStyle(
                      fontFamily: 'AvenirNext',
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
              )
            : AppBar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
              ),
        body: appisLoading == false
            ? ListView(children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BouncingWidget(
                    onPressed: () {},
                    child: Card(
                      elevation: 2,
                      color: cardyColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SizedBox(
                        width: 200,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Text.rich(TextSpan(
                                text: 'Name :  ',
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'AvenirNext',
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: name,
                                    style: const TextStyle(
                                      color: secondaryColor,
                                      fontFamily: 'AvenirNext',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ])),
                            const SizedBox(
                              height: 15,
                            ),
                            Text.rich(TextSpan(
                                text: 'Phone :  ',
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'AvenirNext',
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: phone,
                                    style: const TextStyle(
                                      color: secondaryColor,
                                      fontFamily: 'AvenirNext',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ])),
                            const SizedBox(
                              height: 15,
                            ),
                            Text.rich(TextSpan(
                                text: 'Description :  ',
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'AvenirNext',
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: description,
                                    style: const TextStyle(
                                      color: secondaryColor,
                                      fontFamily: 'AvenirNext',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ])),
                            const SizedBox(
                              height: 15,
                            ),
                            Text.rich(TextSpan(
                                text: 'Amount :  ',
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'AvenirNext',
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: 'Ksh $amount',
                                    style: const TextStyle(
                                      color: secondaryColor,
                                      fontFamily: 'AvenirNext',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ])),
                            const SizedBox(
                              height: 15,
                            ),
                            Text.rich(TextSpan(
                                text: 'Status :  ',
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'AvenirNext',
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <InlineSpan>[
                                  status == false ?
                                  const TextSpan(
                                    text: 'Unpaid',
                                    style:  TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'AvenirNext',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ):
                                   const TextSpan(
                                    text: 'Paid',
                                    style:  TextStyle(
                                      color: primaryThree,
                                      fontFamily: 'AvenirNext',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )

                                ])),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                BouncingWidget(
                  onPressed: () {
                    if (status == true) {
                      Fluttertoast.showToast(
                          msg: "$name has already paid",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: primaryThree,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      startPaymentProcessing(phone: '254704122812', amount: 1);

                      setState(() {
                        showBillingContainer = true;
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      width: 400,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: primaryThree,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: const Center(
                        child: Text(
                          'Request Payment ',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
                showBillingContainer == true
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          Center(
                              child: Text(
                            'Payment request sent to $name',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: primaryThree,
                                fontFamily: 'AvenirNext'),
                          )),
                          const SizedBox(
                            height: 16,
                          ),
                          Center(
                              child: SizedBox(
                            height: 50,
                            width: 50,
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: SvgPicture.asset('assets/icons/check.svg',
                                  color: primaryThree,
                                  height: 10,
                                  fit: BoxFit.fitHeight),
                            ),
                          )),
                        ],
                      )
                    : Container(),
              ])
            : const Center(
                child: CircularProgressIndicator(
                  color: primaryThree,
                  strokeWidth: 2,
                ),
              ));
  }
}
