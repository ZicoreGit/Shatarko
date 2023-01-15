import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shatarkopanicbtn/constant/api_url.dart';
import 'package:shatarkopanicbtn/models/request_model.dart';
import 'package:shatarkopanicbtn/models/user_data.dart';
import 'package:shatarkopanicbtn/pages/conatctaccept_page.dart';
import 'package:shatarkopanicbtn/styles/page_style.dart';

class RequestTab extends StatefulWidget {
  const RequestTab({super.key});

  @override
  State<RequestTab> createState() => _RequestTabState();
}

class _RequestTabState extends State<RequestTab> {
  //api reciver
  bool apiFlag = true;

  List<RequestList> allcontact = [];
  //get username
  Future getContact(String userid) async {
    // OverlayState? overlaySate = Overlay.of(context);
    Response response =
        await post(Uri.parse('${Apiurl.apiURl}/showRequest'), body: {
      'user_id': userid,
    });
    if (response.statusCode == 200) {
      var contactdata = jsonDecode(response.body.toString());
      log(contactdata.toString());
      if (contactdata[0]['status'] == '0') {
        setState(() {
          apiFlag = false;
        });
      } else {
        for (var eachContact in contactdata) {
          final contactlist = RequestList(
            contactId: eachContact['id'].toString(),
            contactuserId: eachContact['user_id'].toString(),
            contactName: eachContact['user_name'],
            contactPhonenumber: eachContact['user_phone_number'],
            contactRelationship: eachContact['relationship_status'],
          );
          allcontact.add(contactlist);
        }
        log(allcontact.length.toString());
      }
    } else {
      setState(() {
        apiFlag = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //collect user id from shared pref
    int? userid = Provider.of<UserData>(context, listen: false).userId;
    SystemChrome.setSystemUIOverlayStyle(Styles.systemUiOverlayStyle);
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      body: apiFlag == false
          ? const Center(
              child: Text(
                'No one send you a request',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            )
          : FutureBuilder(
              future: getContact(userid!.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      itemCount: allcontact.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: GestureDetector(
                            onTap: () {
                              log('taped');
                              log(allcontact[index].contactId);
                              log(allcontact[index].contactuserId);
                              log(allcontact[index].contactName);
                              log(allcontact[index].contactPhonenumber);
                              log(allcontact[index].contactRelationship);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConatctAccept(
                                      id: allcontact[index]
                                          .contactId
                                          .toString(),
                                          userid: allcontact[index].contactuserId.toString(),
                                      name: allcontact[index].contactName,
                                      phonenumber:
                                          allcontact[index].contactPhonenumber,
                                      relationshipstatus: allcontact[index]
                                          .contactRelationship),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F6F6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0, vertical: 15),
                                      child: Text(
                                        allcontact[index].contactName,
                                        style: GoogleFonts.openSans(
                                            color: Colors.black, fontSize: 14),
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
    );
  }
}
