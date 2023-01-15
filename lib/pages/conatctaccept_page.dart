import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shatarkopanicbtn/components/bottom_nav_bar.dart';
import 'package:shatarkopanicbtn/constant/api_url.dart';
import 'package:shatarkopanicbtn/models/user_data.dart';
import 'package:shatarkopanicbtn/styles/page_style.dart';

class ConatctAccept extends StatefulWidget {
  final String id;
  final String userid;
  final String name;
  final String phonenumber;
  final String relationshipstatus;
  const ConatctAccept(
      {super.key,
      required this.id,
      required this.userid,
      required this.name,
      required this.phonenumber,
      required this.relationshipstatus});

  @override
  State<ConatctAccept> createState() => _ConatctAcceptState();
}

class _ConatctAcceptState extends State<ConatctAccept> {
  // function
  Future<void> acceptConatct(String id,String userid,String username) async {
    log(id);
    //reponse
    Response response =
        await post(Uri.parse('${Apiurl.apiURl}/acceptRequest'), body: {
      'contact_id': id,
      'user_id':userid,
      'user_name':username,
    });
    if (response.statusCode == 200) {
      var status = jsonDecode(response.body.toString());
      if (status[0]['status'] == '1') {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
      }
    }
  }

  Future<void> cancelRequest(String id) async {
    log(id);
    //reponse
    Response response =
        await post(Uri.parse('${Apiurl.apiURl}/cancelRequest'), body: {
      'contact_id': id,
    });
    if (response.statusCode == 200) {
      var status = jsonDecode(response.body.toString());
      if (status[0]['status'] == '1') {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
        String username = Provider.of<UserData>(context, listen: false).userName
        .toString();
    return AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xFFF3F8FF), // navigation bar color
          statusBarColor: Color(0xFFF3F8FF), // status bar color
          statusBarIconBrightness: Brightness.dark, // status bar icons' color
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Styles.backgroundColor,
            body: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 90,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      widget.name,
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  Text(
                    widget.phonenumber,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'As a ${widget.relationshipstatus}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            log('Acceptbtn');
                            acceptConatct(widget.id,widget.userid,username);
                          },
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12)),
                            child: const Center(
                              child: Text(
                                'Accept',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            log('Cancel');
                            cancelRequest(widget.id);
                          },
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12)),
                            child: const Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
