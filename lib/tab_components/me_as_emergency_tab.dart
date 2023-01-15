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
import 'package:shatarkopanicbtn/styles/page_style.dart';

class MeAsAEmergencyContact extends StatefulWidget {
  const MeAsAEmergencyContact({super.key});

  @override
  State<MeAsAEmergencyContact> createState() => _MeAsAEmergencyContactState();
}

class _MeAsAEmergencyContactState extends State<MeAsAEmergencyContact> {
  //api reciver
  bool apiFlag = true;

  List<RequestList> allcontact = [];
  //get username
  Future getContact(String userid) async {
    // OverlayState? overlaySate = Overlay.of(context);
    Response response =
        await post(Uri.parse('${Apiurl.apiURl}/measEmergencycontact'), body: {
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 224, 226, 231),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 19, horizontal: 18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    allcontact[index].contactName,
                                    style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'As a ${allcontact[index].contactRelationship}',
                                    style: const TextStyle(
                                        color: Colors.black87, fontSize: 12),
                                  ),
                                ],
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
