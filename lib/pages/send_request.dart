import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shatarkopanicbtn/components/bottom_nav_bar.dart';
import 'package:shatarkopanicbtn/constant/api_url.dart';
import 'package:shatarkopanicbtn/models/user_data.dart';
import 'package:shatarkopanicbtn/styles/page_style.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SendRequestPage extends StatefulWidget {
  final int requestuserid;
  final String requestusername;
  final String requestuserphonenumber;
  final String requestusergender;
  const SendRequestPage(
      {super.key,
      required this.requestuserid,
      required this.requestusername,
      required this.requestuserphonenumber,
      required this.requestusergender});

  @override
  State<SendRequestPage> createState() => _SendRequestPageState();
}

class _SendRequestPageState extends State<SendRequestPage> {
  String relationship = '';
  String sendingTime = '';
  @override
  void initState() {
    super.initState();
    setState(() {
      sendingTime = DateTime.now().toString();
    });
  }

  //function for sent request
  void requestSent(
      int userid, int requestuserid, String relationshipStatus) async {
    OverlayState? overlaySate = Overlay.of(context);
    Response response =
        await post(Uri.parse('${Apiurl.apiURl}/sentRequest'), body: {
      'sender_id': userid.toString(),
      'receiver_id': requestuserid.toString(),
      'relationship_status': relationshipStatus,
      'sending_time':sendingTime,
    });
    if (response.statusCode == 200) {
      var requestData = jsonDecode(response.body.toString());
      //if request sent successfully user redirect to home page
      if (requestData[0]['status'] == '1') {
        if (!mounted) return;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) {
          return const BottomNavBar();
        })));
      } else {
        showTopSnackBar(
          overlaySate!,
          const CustomSnackBar.error(
            message: 'Try again',
            backgroundColor: Colors.yellow,
            textStyle: TextStyle(color: Colors.black, fontSize: 18),
          ),
          dismissType: DismissType.onSwipe,
          dismissDirection: const [DismissDirection.startToEnd],
          displayDuration: const Duration(milliseconds: 100),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(Styles.systemUiOverlayStyle);
    int? userid = Provider.of<UserData>(context, listen: false).userId;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Styles.backgroundColor,
        body: ListView(children: [
          Column(
            children: [
              //image
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: widget.requestusergender == 'Male'
                          ? const AssetImage('lib/images/male.png')
                          : const AssetImage('lib/images/female.png'),
                      fit: BoxFit.fill),
                ),
              ),
              //name

              Text(
                widget.requestusername,
                style: GoogleFonts.openSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),

              //phone number
              Text(
                widget.requestuserphonenumber,
                style: GoogleFonts.openSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),

              const SizedBox(
                height: 30.0,
              ),

              //relation box text
              Text(
                'Define the relationship with the user',
                style: GoogleFonts.openSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF626262)),
              ),

              //relation box
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 10.0),
                child: DropdownButtonFormField(
                  alignment: AlignmentDirectional.bottomCenter,
                  style: Styles.textfieldinputStyle,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelStyle:
                        // const TextStyle(color: Colors.black, fontSize: 15),
                        Styles.textfieldtextLabel,
                    contentPadding: const EdgeInsets.all(8.0),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Father',
                      child: Text('Father'),
                    ),
                    DropdownMenuItem(
                      value: 'Mother',
                      child: Text('Mother'),
                    ),
                    DropdownMenuItem(
                      value: 'Brother',
                      child: Text('Brother'),
                    ),
                    DropdownMenuItem(
                      value: 'Sister',
                      child: Text('Sister'),
                    ),
                    DropdownMenuItem(
                      value: 'Wife',
                      child: Text('Wife'),
                    ),
                    DropdownMenuItem(
                      value: 'Husbend',
                      child: Text('Husbend'),
                    ),
                    DropdownMenuItem(
                      value: 'Friend',
                      child: Text('Friend'),
                    ),
                    DropdownMenuItem(
                      value: 'Other',
                      child: Text('Other'),
                    ),
                  ],
                  onChanged: ((value) {
                    setState(() {
                      relationship = value!;
                    });
                  }),
                ),
              ),
              //request button
              const SizedBox(
                height: 250.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: GestureDetector(
                  onTap: () {
                    if (relationship.isEmpty) {
                      OverlayState? overlaySate = Overlay.of(context);
                      showTopSnackBar(
                        overlaySate!,
                        const CustomSnackBar.error(
                          message: 'Select  relationship',
                          backgroundColor: Colors.yellow,
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        dismissType: DismissType.onSwipe,
                        dismissDirection: const [DismissDirection.startToEnd],
                        displayDuration: const Duration(milliseconds: 100),
                      );
                    } else {
                      requestSent(userid!, widget.requestuserid, relationship);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE600),
                      borderRadius: BorderRadius.circular(12),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     spreadRadius: 2,
                      //     blurRadius: 10,
                      //     // changes position of shadow
                      //   ),
                      // ],
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Send Add Request',
                      style:
                          Styles.buttonTextStyle.copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
