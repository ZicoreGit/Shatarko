import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shatarkopanicbtn/constant/api_url.dart';
import 'package:shatarkopanicbtn/pages/login_page.dart';
import 'package:shatarkopanicbtn/styles/page_style.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // -----------------------init function------------------------------
  String firbasemessagingtoken = '';
  String accountcreatetime = '';

  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((value) {
      log("Firebase messaging token:$value");
      setState(() {
        firbasemessagingtoken = value.toString();
        accountcreatetime = DateTime.now().toString();
      });
    });
    super.initState();
  }

  //---------------------image picker------------------------
  File? profilepic;
  String encodedProfilepic = "";

  Future profileImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);
    Uint8List bytes = await image.readAsBytes();
    encodedProfilepic = base64Encode(bytes);
    setState(() {
      profilepic = imageTemporary;
    });
  }

  //---------------------------collect date---------------------------
  final TextEditingController _userdateofBirthController =
      TextEditingController();
  collectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(200),
      lastDate: DateTime(20254),
    );
    if (pickedDate != null) {
      setState(() {
        _userdateofBirthController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  //gap
  double gapbetweenTextfield = 15.0;
  //-----------------------------inisializing controller for textfield--------------------
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userPhoneNumberController =
      TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  final TextEditingController _userConfirmPasswordController =
      TextEditingController();
  final TextEditingController _userAddress = TextEditingController();

  //variable
  String gender = '';
  String bloodgroup = '';

  //registration function

  Future<void> registration(
      String username,
      String email,
      String phonenumber,
      String gender,
      String bloodgroup,
      String password,
      String address,
      String dateofbirth) async {
    //over lay state
    OverlayState? overlaySate = Overlay.of(context);

    try {
      Response response =
          await post(Uri.parse('${Apiurl.apiURl}/registration'), body: {
        'user_name': username,
        'user_phonenumber': phonenumber,
        'user_password': password,
        'user_email': email,
        'user_gender': gender,
        'user_profilepic': encodedProfilepic,
        'user_dateofbirth': dateofbirth,
        'user_bloodgroup': bloodgroup,
        'user_address': address,
        'user_accountcreationtime': accountcreatetime,
        'firebase_messagingtoken': firbasemessagingtoken,
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        var apiData = data[0]['status'];
        debugPrint('api password:$apiData');
        if (!mounted) return;
        if (apiData == '1') {
          //---------------------------shared prefarences-----------------------

          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString('usernameSP', username);
          preferences.setString('userphonenumberSP', phonenumber);
          showTopSnackBar(
            overlaySate!,
            const CustomSnackBar.error(
              message: 'Regestration succesfully',
              backgroundColor: Colors.yellow,
              textStyle: TextStyle(color: Colors.black, fontSize: 18),
            ),
            dismissType: DismissType.onSwipe,
            dismissDirection: const [DismissDirection.startToEnd],
            displayDuration: const Duration(milliseconds: 100),
          );
          if (!mounted) return;

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: ((context) => const LogInPage())));
        } else if (apiData == '0') {
          showTopSnackBar(
            overlaySate!,
            const CustomSnackBar.error(
              message: 'Already registered',
              backgroundColor: Colors.red,
              textStyle: TextStyle(color: Colors.white, fontSize: 18),
            ),
            dismissType: DismissType.onSwipe,
            dismissDirection: const [DismissDirection.startToEnd],
            displayDuration: const Duration(milliseconds: 100),
          );
        } else {
          if (!mounted) return;
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
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    //over lay state
    OverlayState? overlaySate = Overlay.of(context);
    //changing status bar color
    SystemChrome.setSystemUIOverlayStyle(Styles.systemUiOverlayStyle);
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                //-------------------------------image picker-------------------
                Stack(
                  children: [
                    ClipOval(
                      child: profilepic != null
                          ? Image.file(
                              profilepic!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'lib/images/male.png',
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 20,
                      child: InkWell(
                        onTap: () {
                          profileImage();
                        },
                        child: const Icon(
                          Icons.camera,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                //create account text
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Create your account',
                  style: GoogleFonts.roboto(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  height: gapbetweenTextfield,
                ),

                TextField(
                  controller: _userNameController, //user name controller
                  style: Styles.textfieldinputStyle,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'User name',
                    labelStyle: Styles.textfieldtextLabel,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    isDense: true,
                    isCollapsed: true,
                    filled: true,
                    fillColor: const Color(0xFFE5E5E5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),

                SizedBox(
                  height: gapbetweenTextfield,
                ),
                TextField(
                  controller:
                      _userPhoneNumberController, //user phone number controller
                  style: Styles.textfieldinputStyle,
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: 'Phone number',
                    labelStyle: Styles.textfieldtextLabel,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    isDense: true,
                    isCollapsed: true,
                    filled: true,
                    fillColor: const Color(0xFFE5E5E5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                ),
                SizedBox(
                  height: gapbetweenTextfield,
                ),

                TextField(
                  controller: _userEmailController, //user email controller
                  style: Styles.textfieldinputStyle,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: Styles.textfieldtextLabel,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    isDense: true,
                    isCollapsed: true,
                    filled: true,
                    fillColor: const Color(0xFFE5E5E5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),

                SizedBox(
                  height: gapbetweenTextfield,
                ),

                //text field for gender

                DropdownButtonFormField(
                  style: Styles.textfieldinputStyle,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Select Gender',
                    labelStyle: Styles.textfieldtextLabel,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    isDense: true,
                    isCollapsed: true,
                    filled: true,
                    fillColor: const Color(0xFFE5E5E5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
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
                      value: 'Male',
                      child: Text('Male'),
                    ),
                    DropdownMenuItem(
                      value: 'Female',
                      child: Text('Female'),
                    ),
                  ],
                  onChanged: ((value) {
                    setState(() {
                      gender = value!;
                    });
                  }),
                ),

                SizedBox(
                  height: gapbetweenTextfield,
                ),
                //dropdown for blood group
                DropdownButtonFormField(
                  style: Styles.textfieldinputStyle,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Select blood group',
                    labelStyle: Styles.textfieldtextLabel,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    isDense: true,
                    isCollapsed: true,
                    filled: true,
                    fillColor: const Color(0xFFE5E5E5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
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
                      value: 'A+',
                      child: Text('A+'),
                    ),
                    DropdownMenuItem(
                      value: 'A-',
                      child: Text('A-'),
                    ),
                    DropdownMenuItem(
                      value: 'B+',
                      child: Text('B+'),
                    ),
                    DropdownMenuItem(
                      value: 'B-',
                      child: Text('B-'),
                    ),
                    DropdownMenuItem(
                      value: 'AB+',
                      child: Text('AB+'),
                    ),
                    DropdownMenuItem(
                      value: 'AB-',
                      child: Text('AB-'),
                    ),
                    DropdownMenuItem(
                      value: 'O+',
                      child: Text('O+'),
                    ),
                    DropdownMenuItem(
                      value: 'O-',
                      child: Text('O-'),
                    ),
                  ],
                  onChanged: ((value) {
                    setState(() {
                      bloodgroup = value!;
                    });
                  }),
                ),
                SizedBox(
                  height: gapbetweenTextfield,
                ),

                //-------------------------- Date of birth--------------------------
                TextField(
                  // onTap: () {

                  // },
                  // readOnly: true,
                  controller: _userdateofBirthController, //user name controller
                  style: Styles.textfieldinputStyle,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    labelStyle: Styles.textfieldtextLabel,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    isDense: true,
                    isCollapsed: true,
                    filled: true,
                    fillColor: const Color(0xFFE5E5E5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2),
                    ),
                    //+++++++++++++++++++++++++++++++++++++++ suffix icon +++++++++++++++++++++++++++
                    suffixIcon: IconButton(
                      onPressed: (() {
                        collectDate();
                      }),
                      icon: const Icon(Icons.calendar_month),
                      iconSize: 24,
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                SizedBox(
                  height: gapbetweenTextfield,
                ),
                TextField(
                  controller: _userAddress, //user confirm password
                  style: Styles.textfieldinputStyle,
                  decoration: InputDecoration(
                    labelText: 'User Address',
                    labelStyle: Styles.textfieldtextLabel,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    isDense: true,
                    isCollapsed: true,
                    filled: true,
                    fillColor: const Color(0xFFE5E5E5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),

                SizedBox(
                  height: gapbetweenTextfield,
                ),

                TextField(
                  controller:
                      _userPasswordController, //user password controller
                  style: Styles.textfieldinputStyle,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: Styles.textfieldtextLabel,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    isDense: true,
                    isCollapsed: true,
                    filled: true,
                    fillColor: const Color(0xFFE5E5E5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  obscureText: true,
                ),

                SizedBox(
                  height: gapbetweenTextfield,
                ),

                TextField(
                  controller:
                      _userConfirmPasswordController, //user confirm password
                  style: Styles.textfieldinputStyle,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: Styles.textfieldtextLabel,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    isDense: true,
                    isCollapsed: true,
                    filled: true,
                    fillColor: const Color(0xFFE5E5E5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  obscureText: true,
                ),
                SizedBox(
                  height: gapbetweenTextfield,
                ),

                //registration button
                GestureDetector(
                  onTap: () {
                    if (_userNameController.text.isEmpty) {
                      showTopSnackBar(
                        overlaySate!,
                        const CustomSnackBar.error(
                          message: 'Enter user name',
                          backgroundColor: Colors.yellow,
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                          icon: Icon(
                            Icons.error_outline_outlined,
                            size: 40,
                          ),
                          iconPositionLeft: 20,
                          iconRotationAngle: 0,
                        ),
                        dismissType: DismissType.onSwipe,
                        displayDuration: const Duration(milliseconds: 100),
                      );
                    } else if (_userEmailController.text.isEmpty) {
                      showTopSnackBar(
                        overlaySate!,
                        const CustomSnackBar.error(
                          message: 'Enter email',
                          backgroundColor: Colors.yellow,
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                          icon: Icon(
                            Icons.error_outline_outlined,
                            size: 40,
                          ),
                          iconPositionLeft: 20,
                          iconRotationAngle: 0,
                        ),
                        dismissType: DismissType.onSwipe,
                        displayDuration: const Duration(milliseconds: 100),
                      );
                    } else if (_userPhoneNumberController.text.isEmpty) {
                      showTopSnackBar(
                        overlaySate!,
                        const CustomSnackBar.error(
                          message: 'Enter phone number',
                          backgroundColor: Colors.yellow,
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                          icon: Icon(
                            Icons.error_outline_outlined,
                            size: 40,
                          ),
                          iconPositionLeft: 20,
                          iconRotationAngle: 0,
                        ),
                        dismissType: DismissType.onSwipe,
                        displayDuration: const Duration(milliseconds: 100),
                      );
                    } else if (gender.isEmpty) {
                      showTopSnackBar(
                        overlaySate!,
                        const CustomSnackBar.error(
                          message: 'Select gender',
                          backgroundColor: Colors.yellow,
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                          icon: Icon(
                            Icons.error_outline_outlined,
                            size: 40,
                          ),
                          iconPositionLeft: 20,
                          iconRotationAngle: 0,
                        ),
                        dismissType: DismissType.onSwipe,
                        displayDuration: const Duration(milliseconds: 100),
                      );
                    } else if (bloodgroup.isEmpty) {
                      showTopSnackBar(
                        overlaySate!,
                        const CustomSnackBar.error(
                          message: 'Select blood group',
                          backgroundColor: Colors.yellow,
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                          icon: Icon(
                            Icons.error_outline_outlined,
                            size: 40,
                          ),
                          iconPositionLeft: 20,
                          iconRotationAngle: 0,
                        ),
                        dismissType: DismissType.onSwipe,
                        displayDuration: const Duration(milliseconds: 100),
                      );
                    } else if (_userPasswordController.text.isEmpty) {
                      showTopSnackBar(
                        overlaySate!,
                        const CustomSnackBar.error(
                          message: 'Enter password',
                          backgroundColor: Colors.yellow,
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                          icon: Icon(
                            Icons.error_outline_outlined,
                            size: 40,
                          ),
                          iconPositionLeft: 20,
                          iconRotationAngle: 0,
                        ),
                        dismissType: DismissType.onSwipe,
                        displayDuration: const Duration(milliseconds: 100),
                      );
                    } else if (_userConfirmPasswordController.text.isEmpty) {
                      showTopSnackBar(
                        overlaySate!,
                        const CustomSnackBar.error(
                          message: 'Enter confirm password',
                          backgroundColor: Colors.yellow,
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                          icon: Icon(
                            Icons.error_outline_outlined,
                            size: 40,
                          ),
                          iconPositionLeft: 20,
                          iconRotationAngle: 0,
                        ),
                        dismissType: DismissType.onSwipe,
                        displayDuration: const Duration(milliseconds: 100),
                      );
                    } else if (_userPasswordController.text !=
                        _userConfirmPasswordController.text) {
                      showTopSnackBar(
                        overlaySate!,
                        const CustomSnackBar.error(
                          message: 'Password does not match',
                          backgroundColor: Colors.yellow,
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                          icon: Icon(
                            Icons.error_outline_outlined,
                            size: 40,
                          ),
                          iconPositionLeft: 20,
                          iconRotationAngle: 0,
                        ),
                        dismissType: DismissType.onSwipe,
                        displayDuration: const Duration(milliseconds: 100),
                      );
                    } else {
                      registration(
                        _userNameController.text,
                        _userEmailController.text,
                        _userPhoneNumberController.text,
                        gender.toString(),
                        bloodgroup.toString(),
                        _userConfirmPasswordController.text,
                        _userAddress.text,
                        _userdateofBirthController.text,
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: const Color(0xFF252525),
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Sign Up',
                      style: Styles.buttonTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: gapbetweenTextfield,
                ),
                // ElevatedButton(onPressed: collectDate, child: Text('Click'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
