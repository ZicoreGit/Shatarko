import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shatarkopanicbtn/components/bottom_nav_bar.dart';
import 'package:shatarkopanicbtn/constant/api_url.dart';
import 'package:shatarkopanicbtn/models/contact_model.dart';
import 'package:shatarkopanicbtn/models/user_data.dart';
import 'package:shatarkopanicbtn/pages/send_request.dart';
import 'package:shatarkopanicbtn/styles/page_style.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ShowContact extends StatefulWidget {
  const ShowContact({super.key});

  @override
  State<ShowContact> createState() => _ShowContactState();
}

class _ShowContactState extends State<ShowContact> {
  bool isFabVisible = true;
  //api reciver
  bool apiFlag = true;

  //controller
  final TextEditingController _contactUserController = TextEditingController();
  //contact list
  List<ContactList> allcontact = [];
  //get username
  Future getContact(String userid) async {
    Response response =
        await post(Uri.parse('${Apiurl.apiURl}/showContact'), body: {
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
          final contactlist = ContactList(
            contactId: eachContact['id'].toString(),
            contactStatus: eachContact['status_flag'],
            contactName: eachContact['user_name'],
            contactPhonenumber: eachContact['user_phone_number'],
            contactRelationship: eachContact['relationship_status'],
          );
          allcontact.add(contactlist);
        }
      }
    }
  }

//------------------------------------------------------------------------------search contact-----------------------------------------------------------

  void searchContact(String phonenumber, String userid) async {
    OverlayState? overlaySate = Overlay.of(context);
    log(phonenumber);

    Response response =
        await post(Uri.parse('${Apiurl.apiURl}/searchContact'), body: {
      'contact_phonenumber': phonenumber,
      'user_id': userid,
    });
    if (response.statusCode == 200) {
      var contactdata = jsonDecode(response.body.toString());
      if (contactdata[0]['status_flag'] == '1') {
        showTopSnackBar(
          overlaySate!,
          const CustomSnackBar.error(
            message: 'Already sent a request.',
            backgroundColor: Colors.yellow,
            textStyle: TextStyle(color: Colors.black, fontSize: 18),
          ),
          dismissType: DismissType.onSwipe,
          dismissDirection: const [DismissDirection.startToEnd],
          displayDuration: const Duration(milliseconds: 100),
        );
      } else if (contactdata[0]['status_flag'] == '0') {
        showTopSnackBar(
          overlaySate!,
          const CustomSnackBar.error(
            message: 'This user already your friend.',
            backgroundColor: Colors.yellow,
            textStyle: TextStyle(color: Colors.black, fontSize: 18),
          ),
          dismissType: DismissType.onSwipe,
          dismissDirection: const [DismissDirection.startToEnd],
          displayDuration: const Duration(milliseconds: 100),
        );
      } else if (contactdata[0]['status_flag'] == '2') {
        if (!mounted) return;
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) {
              return SendRequestPage(
                  requestuserid: contactdata[0]['user_id'],
                  requestusername: contactdata[0]['user_name'],
                  requestuserphonenumber: contactdata[0]['user_phone_number'],
                  requestusergender: contactdata[0]['user_gender']);
            }),
          ),
        );
      } else if (contactdata[0]['status'] == '0') {
        showTopSnackBar(
          overlaySate!,
          const CustomSnackBar.error(
            message: 'User is not available',
            backgroundColor: Colors.yellow,
            textStyle: TextStyle(color: Colors.black, fontSize: 18),
          ),
          dismissType: DismissType.onSwipe,
          dismissDirection: const [DismissDirection.startToEnd],
          displayDuration: const Duration(milliseconds: 100),
        );
      } else {
        if (!mounted) return;
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) {
              return SendRequestPage(
                  requestuserid: contactdata[0]['user_id'],
                  requestusername: contactdata[0]['user_name'],
                  requestuserphonenumber: contactdata[0]['user_phone_number'],
                  requestusergender: contactdata[0]['user_gender']);
            }),
          ),
        );
      }
    }
  }
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ delete contact +++++++++++++++++++++++++++++++++++++++++++++

  deleteConatct(String conatctid) async {
    OverlayState? overlaySate = Overlay.of(context);

    Response response =
        await post(Uri.parse('${Apiurl.apiURl}/deleteContact'), body: {
      'contact_id': conatctid,
    });
    if (response.statusCode == 200) {
      var contactdata = jsonDecode(response.body.toString());
      if (contactdata[0]['status'] == '1') {
        showTopSnackBar(
          overlaySate!,
          const CustomSnackBar.error(
            message: 'Contact delete successfully',
            backgroundColor: Colors.yellow,
            textStyle: TextStyle(color: Colors.black, fontSize: 18),
          ),
          dismissType: DismissType.onSwipe,
          dismissDirection: const [DismissDirection.startToEnd],
          displayDuration: const Duration(milliseconds: 100),
        );
      }
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
      );
    }
  }

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ details dialog+++++++++++++++++++++
  void showDetailsDialog(String name, String phonenumber, String relationship) {
    log('I am dialog');
    showDialog(
        context: context,
        builder: ((context) {
          return SimpleDialog(
            children: [
              SizedBox(
                height: 150,
                child: Column(
                  children: [
                    const Text(
                      "Contact Details",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    const Divider(
                      thickness: 2,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          const Text(
                            "Name:",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          const Text(
                            "Phone Number:",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          Text(
                            phonenumber,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '**Added as $relationship**',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              )
            ],
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    int? userid = Provider.of<UserData>(context, listen: false).userId;
    log(userid.toString());
    String userphonenumber = Provider.of<UserData>(context, listen: false)
        .userPhonenumber
        .toString();
    log(userphonenumber);
    SystemChrome.setSystemUIOverlayStyle(Styles.systemUiOverlayStyle);
    // getContact();
    OverlayState? overlaySate = Overlay.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Styles.backgroundColor,
        floatingActionButton: isFabVisible
            ? FloatingActionButton(
                onPressed: () async {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      clipBehavior: Clip.antiAlias,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return FractionallySizedBox(
                          heightFactor: 0.6,
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 120),
                                child: Divider(
                                  thickness: 4,
                                  color: Colors.black,
                                ),
                              ),
                              //Text for how to search
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text(
                                  'Enter phone number',
                                  style: GoogleFonts.roboto(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ),
                              //search phone number
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 10.0),
                                child: TextFormField(
                                  controller: _contactUserController,
                                  style: Styles.textfieldinputStyle,
                                  autofocus: false,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                    labelStyle: Styles.textfieldtextLabel,
                                    contentPadding: const EdgeInsets.all(10),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                          width: 1.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                          width: 2),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: (() {
                                        //search other users
                                        if (_contactUserController.text ==
                                            userphonenumber) {
                                          showTopSnackBar(
                                            overlaySate!,
                                            const CustomSnackBar.error(
                                              message:
                                                  'Dont try your own number',
                                              backgroundColor: Colors.yellow,
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                            dismissType: DismissType.onSwipe,
                                            dismissDirection: const [
                                              DismissDirection.startToEnd
                                            ],
                                            displayDuration: const Duration(
                                                milliseconds: 100),
                                          );
                                        } else if (_contactUserController
                                            .text.isEmpty) {
                                          showTopSnackBar(
                                            overlaySate!,
                                            const CustomSnackBar.error(
                                              message: 'Text field is empty',
                                              backgroundColor: Colors.yellow,
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                            dismissType: DismissType.onSwipe,
                                            dismissDirection: const [
                                              DismissDirection.startToEnd
                                            ],
                                            displayDuration: const Duration(
                                                milliseconds: 100),
                                          );
                                        } else {
                                          searchContact(
                                              _contactUserController.text,
                                              userid.toString());
                                        }
                                      }),
                                      icon: const Icon(
                                        Icons.search_sharp,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                backgroundColor: Colors.black,
                child: const Icon(Icons.add),
              )
            : null,
        //----------------------------------------------------------------floating action bar end here----------------------------------------------------------
        body: apiFlag == false
            ? const Center(
                child: Text(
                  'You haven\'t added user yet',
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
                            child: Slidable(
                              startActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  //for delete
                                  SlidableAction(
                                    label: 'Delete',
                                    onPressed: ((context) {
                                      deleteConatct(
                                          allcontact[index].contactId);
                                    }),
                                    icon: Icons.delete,
                                    backgroundColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  showDetailsDialog(
                                      allcontact[index].contactName,
                                      allcontact[index].contactPhonenumber,
                                      allcontact[index].contactRelationship);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 224, 226, 231),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                allcontact[index].contactName,
                                                style: GoogleFonts.openSans(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                'As a ${allcontact[index].contactRelationship}',
                                                style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        allcontact[index].contactStatus == '0'
                                            ? Container()
                                            : Container(
                                                height: 25,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 61, 196, 117),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Center(
                                                    child: Text(
                                                  'Pending',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                              ),
                                      ],
                                    ),
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
    );
  }
}
