
import 'package:billingapp/constants.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: SizedBox(
              height: 15,
              width: 15,
              child: SizedBox(
                height: 15,
                width: 15,
                child: SvgPicture.asset('assets/icons/cancel.svg',
                    color: Colors.black54, height: 10, fit: BoxFit.fitHeight),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          leadingWidth: 50,
          centerTitle: false,
          title: const Text(
            'Kevin Waweru',
            style: TextStyle(
                fontFamily: 'AvenirNext',
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding ),
              child: BouncingWidget(
                onPressed: () {},
                child: Card(
                  elevation: 2,
                  color: cardyColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SizedBox(
                    width: 80,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 45,
                          width: 45,
                          child: SvgPicture.asset(
                            'assets/icons/person.svg',
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: const [
                            Text('Kevin Waweru',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'AvenirNext',
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Text('Kevinmwangi7881gmail.com',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'AvenirNext',
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('0704122812',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'AvenirNext',
                                fontWeight: FontWeight.w800)),
                        const SizedBox(
                          height: 10,
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15,),
            
            BouncingWidget(
              onPressed: () {
                Fluttertoast.showToast(
                    msg: "To be added",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: primaryThree,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  width: 400,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: primaryThree,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Center(
                    child: Text(
                      'Update Profile',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'AvenirNext',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
