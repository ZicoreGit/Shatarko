import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shatarkopanicbtn/constant/api_url.dart';
import 'package:shatarkopanicbtn/models/notification_model.dart';
import 'package:shatarkopanicbtn/models/user_data.dart';
import 'package:shatarkopanicbtn/styles/page_style.dart';

class NotificationPage extends StatefulWidget {
  final String userid;
  const NotificationPage({super.key, required this.userid});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  //-----------------------api flag------------------------------
  bool apiFlag = true;
  //-----------------------initialize list-----------------------
  List<NotificationList> allnotification = [];
  //-----------------------fetching notification function--------
  Future getAllNotification(String userid) async {
    Response response =
        await post(Uri.parse('${Apiurl.apiURl}/showNotification'), body: {
      'user_id': userid,
    });
    if (response.statusCode == 200) {
      var notificationdata = jsonDecode(response.body.toString());
      log(notificationdata.toString());
      if (notificationdata[0]['status'] == '0') {
        setState(() {
          apiFlag = false;
        });
      } else {
        for (var eachNotification in notificationdata) {
          final notificationlist = NotificationList(
            userName: eachNotification['user_name'],
            panicType: eachNotification['panic_type'],
            buttonpressedDate: eachNotification['button_pressed_date'],
            buttonpressedTime: eachNotification['button_pressed_time'],
          );
          allnotification.add(notificationlist);
        }
        log(allnotification.length.toString());
      }
    } else {
      setState(() {
        apiFlag = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int? userid = Provider.of<UserData>(context, listen: false).userId;
    String username =
        Provider.of<UserData>(context, listen: false).userName.toString();
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFFF3F8FF), // navigation bar color
        statusBarColor: Color(0xFFF3F8FF), // status bar color
        statusBarIconBrightness: Brightness.dark, // status bar icons' color
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.black, size: 24.0),
          ),
          backgroundColor: Styles.backgroundColor,
          body: apiFlag == false
              ? const Center(
                  child: Text(
                    'You have not any notification yet',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                )
              : FutureBuilder(
                  future: getAllNotification(userid!.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                          itemCount: allnotification.length,
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: GestureDetector(
                                // onTap: () {
                                //   log('taped');
                                //   log(allcontact[index].contactId);
                                //   log(allcontact[index].contactName);
                                //   log(allcontact[index].contactPhonenumber);
                                //   log(allcontact[index].contactRelationship);
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => ConatctAccept(
                                //           id: allcontact[index]
                                //               .contactId
                                //               .toString(),
                                //           name: allcontact[index].contactName,
                                //           phonenumber:
                                //               allcontact[index].contactPhonenumber,
                                //           relationshipstatus: allcontact[index]
                                //               .contactRelationship),
                                //     ),
                                //   );
                                // },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 224, 226, 231),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(allnotification[index]
                                                .buttonpressedTime),
                                            Text(allnotification[index]
                                                .buttonpressedDate),
                                          ],
                                        ),

                                        const SizedBox(
                                          height: 25,
                                          child: VerticalDivider(
                                            color: Colors.red,
                                            thickness: 2,
                                            indent: 5,
                                            endIndent: 0,
                                            width: 20,
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.symmetric(
                                        //       horizontal: 2.0, vertical: 15),
                                        //   child: Flexible(
                                        //     child: Text(
                                        //       "${allnotification[index].userName} pressed ${allnotification[index].panicType} button",
                                        //       overflow: TextOverflow.ellipsis,
                                        //       textAlign: TextAlign.justify,
                                        //       style: GoogleFonts.openSans(
                                        //           color: Colors.black,
                                        //           fontSize: 14),
                                        //     ),
                                        //   ),
                                        // ),
                                        Expanded(
                                          child: username ==
                                                  allnotification[index]
                                                      .userName
                                              ? Text(
                                                  " You pressed ${allnotification[index].panicType} button",
                                                  overflow: TextOverflow.clip,
                                                )
                                              : Text(
                                                  "${allnotification[index].userName} pressed ${allnotification[index].panicType} button",
                                                ),
                                        ),

                                        // Text(allcontact[index].contactPhonenumber),
                                        // Text(allcontact[index].contactRelationship),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }));
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
        ),
      ),
    );
  }
}
