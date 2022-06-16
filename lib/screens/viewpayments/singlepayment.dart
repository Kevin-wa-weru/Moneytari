import 'package:billingapp/constants.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:searchfield/searchfield.dart';

class SinglePayment extends StatefulWidget {
  const SinglePayment({
    Key? key,
    required this.docid,
  }) : super(key: key);
  final String docid;
  @override
  State<SinglePayment> createState() => _SinglePaymentState();
}

class _SinglePaymentState extends State<SinglePayment>
    with SingleTickerProviderStateMixin {
  bool showBillingContainer = false;
  String selectedValue = '.';
  List<SearchFieldListItem> options = [
    SearchFieldListItem('INV2020001'),
    SearchFieldListItem('Kevin Waweru'),
    SearchFieldListItem('INV2020003'),
    SearchFieldListItem('INV2020004'),
    SearchFieldListItem('INV2020005'),
  ];

  String? name;
  String? phone;
  String? amount;
  String? paymentref;
  String? paymentcode;
  String? allocation;
  bool appisLoading = false;

  Future getspecificPay() async {
    setState(() {
      appisLoading = true;
    });

    var response = await FirebaseFirestore.instance
        .collection("payments")
        .doc(widget.docid.replaceAll(" ", ""))
        .get();

    setState(() {
      name = response.data()!['name'];
      phone = response.data()!['phone'];
      amount = response.data()!['amount'];
      paymentref = response.data()!['paymentref'];
      paymentcode = response.data()!['paymentcode'];
      allocation = response.data()!['allocation'];
    });

    setState(() {
      appisLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getspecificPay();
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
                          color: Colors.black54,
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
                                text: 'Amount :  ',
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'AvenirNext',
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: amount,
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
                                text: 'Paymet ref :  ',
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'AvenirNext',
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: paymentref,
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
                                text: 'Payment code :  ',
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'AvenirNext',
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <InlineSpan>[
                                  allocation == 'allocated'
                                      ? const TextSpan(
                                          text: 'INV20202',
                                          style: TextStyle(
                                            color: primaryThree,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      : const TextSpan(
                                          text: 'Unallocated',
                                          style: TextStyle(
                                            color: Colors.red,
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
                allocation == 'unallocated'
                    ? Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Container(
                          width: 400,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: SearchField(
                              marginColor: primaryThree,
                              hint: 'Select item to allocate',
                              searchInputDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: secondaryColor, width: 0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: secondaryColor, width: 0.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: primaryThree, width: 2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                filled: true,
                              ),
                              itemHeight: 50,
                              maxSuggestionsInViewPort: 4,
                              suggestionsDecoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              onSuggestionTap: (value) {
                                setState(() {
                                  selectedValue = value.searchKey;
                                });
                              },
                              suggestions: options),
                        ),
                      )
                    : Container(),
                BouncingWidget(
                  onPressed: () {
                    setState(() {
                      if (selectedValue == '.') {
                        Fluttertoast.showToast(
                            msg: "Select or enter an item to Allocate",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: primaryThree,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                      if (allocation == 'allocated') {
                        Fluttertoast.showToast(
                            msg: "Payment has already been allocated",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: primaryThree,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        showBillingContainer = true;
                      }
                    });
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
                          'Allocate payment ',
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
                          const Center(
                              child: Text(
                            'Payment has been allocated ',
                            style: TextStyle(
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
