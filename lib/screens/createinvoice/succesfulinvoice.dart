import 'package:billingapp/constants.dart';
import 'package:billingapp/screens/dashboard/homescreen.dart';
import 'package:billingapp/services/firebaseserivices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class SuccefulInvoice extends StatefulWidget {
  const SuccefulInvoice({Key? key, required this.invoiceId}) : super(key: key);

  final String invoiceId;
  @override
  State<SuccefulInvoice> createState() => _SuccefulInvoiceState();
}

class _SuccefulInvoiceState extends State<SuccefulInvoice>
    with SingleTickerProviderStateMixin {
  FirebaseServices firebaseServices = FirebaseServices();
  String? name;
  String? phone;
  String? description;
  String? amount;
  bool appisLoading = false;
  Future getspecificInvoice() async {
    setState(() {
      appisLoading = true;
    });
    //  await FirebaseFirestore.instance.collection("invoices").where('userid', isEqualTo: FirebaseServices().getUserId()).get().then((value) => null);
    var response = await FirebaseFirestore.instance
        .collection("invoices")
        .doc(widget.invoiceId)
        .get();

    setState(() {
      name = response.data()!['name'];
      phone = response.data()!['phone'];
      description = response.data()!['description'];
      amount = response.data()!['amount'];
    });

    setState(() {
      appisLoading = false;
    });
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
                title: const Text(
                  'Succesfully Invoiced',
                  style: TextStyle(
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
                            height: 10,
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
                                  text: 'Ksh.$amount',
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
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Dashboard()),
                    );
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
                          'Back to Dashboard',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ])
            : const Center(
                child: CircularProgressIndicator(
                  color: primaryThree,
                  strokeWidth: 2,
                ),
              ));
  }
}
