import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shatarkopanicbtn/components/bottom_nav_bar.dart';
import 'package:shatarkopanicbtn/constant/api_url.dart';
import 'package:shatarkopanicbtn/pages/registration_page.dart';
import 'package:shatarkopanicbtn/styles/page_style.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInState();
}

class _LogInState extends State<LogInPage> {
  // -----------------------init function------------------------------
  String firbasemessagingtoken = '';

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) {
      log("Firebase messaging token:$value");
      setState(() {
        firbasemessagingtoken = value.toString();
      });
    });
  }


  double gapbetweenTextfield = 15.0;
  final TextEditingController _userPhonenumberController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void login(String phonenumber, String password) async {
    //over lay state
    OverlayState? overlaySate = Overlay.of(context);
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
        barrierDismissible: false);

    try {
      Response response =
          await post(Uri.parse('${Apiurl.apiURl}/login'), body: {
        'user_phonenumber': phonenumber,
        'firebase_messaging_token': firbasemessagingtoken,
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        var apiUserid = data[0]['user_id'];
        var apiUsername = data[0]['user_name'];
        var apiUserphonenumber = data[0]['user_phone_number'];
        var apiPassword = data[0]['user_password'];
        debugPrint('api password:$apiPassword');

        if (!mounted) return;
        Navigator.of(context).pop();
        if (password == apiPassword) {
          // loginNotification();
          //---------------------------shared prefarences-----------------------
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setInt('useridSP', apiUserid);
          preferences.setString('usernameSP', apiUsername);
          preferences.setString('userphonenumberSP', apiUserphonenumber);

          //----------------------navigator to homepage-------------------------
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
          );
        } else if (apiPassword == '0') {
          debugPrint('You haven\'t register yet.');
          showTopSnackBar(
            overlaySate!,
            const CustomSnackBar.error(
              message: 'You haven\'t register yet.',
              backgroundColor: Colors.yellow,
              textStyle: TextStyle(color: Colors.black, fontSize: 18),
              icon: Icon(
                Icons.error_outline_outlined,
                size: 40,
              ),
              iconPositionLeft: 20,
              iconRotationAngle: 0,
            ),
            dismissType: DismissType.onSwipe,
            dismissDirection: const [DismissDirection.startToEnd],
            displayDuration: const Duration(milliseconds: 100),
          );
        } else if (password != apiPassword) {
          showTopSnackBar(
            overlaySate!,
            const CustomSnackBar.error(
              message: 'Password is incorrect.',
              backgroundColor: Colors.yellow,
              textStyle: TextStyle(color: Colors.black, fontSize: 18),
              icon: Icon(
                Icons.error_outline_outlined,
                size: 40,
              ),
              iconPositionLeft: 20,
              iconRotationAngle: 0,
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
    SystemChrome.setSystemUIOverlayStyle(Styles.systemUiOverlayStyle);
    //overlay context
    OverlayState? overlaySate = Overlay.of(context);
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          addAutomaticKeepAlives: false,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  //-------------------------------for log in page image------------------------------------
                  Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    height: MediaQuery.of(context).size.height / 2.8,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                          Styles.backgroundColor,
                          BlendMode.modulate,
                        ),
                        fit: BoxFit.fitHeight,
                        image: const AssetImage("lib/images/mainlogin.png"),
                      ),
                    ),
                  ),

                  //-----------------------------for log in to account text------------------------------------

                  Text(
                    'Log in to your account',
                    style: GoogleFonts.roboto(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: gapbetweenTextfield,
                  ),
                  //----------------------------for text field user name ------------------------------------
                  TextField(
                    controller: _userPhonenumberController,
                    style: Styles.textfieldinputStyle,
                    autofocus: false,
                    decoration: InputDecoration(
                      counterText:
                          "", //counter text null or empty to hide under counter text
                      labelText: 'Phone Number',
                      labelStyle: Styles.textfieldtextLabel,
                      contentPadding: const EdgeInsets.all(10),
                      filled: true,
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
                    obscureText: false,
                    maxLength: 11,
                  ),
                  SizedBox(
                    height: gapbetweenTextfield,
                  ),
                  //--------------------------for text field user password---------------------------------
                  TextField(
                    controller: _passwordController,
                    style: Styles.textfieldinputStyle,
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: Styles.textfieldtextLabel,
                      contentPadding: const EdgeInsets.all(10),
                      filled: true,
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
                    obscureText: true,
                  ),
                  SizedBox(
                    height: gapbetweenTextfield,
                  ),
                  //----------------------------------log in buttton-------------------------------------
                  InkWell(
                    onTap: () {
                      if (_userPhonenumberController.text.isEmpty) {
                        //----CUSTOM TOP SNAKBAR-------
                        showTopSnackBar(
                          overlaySate!,
                          const CustomSnackBar.error(
                            message: 'Enter Phone number',
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
                          dismissDirection: [
                            DismissDirection.startToEnd,
                            DismissDirection.up
                          ],
                          displayDuration: const Duration(milliseconds: 100),
                        );
                      } else if (_passwordController.text.isEmpty) {
                        showTopSnackBar(
                          overlaySate!,
                          const CustomSnackBar.error(
                            message: 'Enter Password',
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
                          dismissDirection: const [DismissDirection.startToEnd],
                          displayDuration: const Duration(milliseconds: 100),
                        );
                      } else {
                        login(_userPhonenumberController.text.toString(),
                            _passwordController.text.toString());
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: const Color(0xFF252525),
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        'Sign In',
                        style: Styles.buttonTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don t have an account?',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        //------------------------------log in to registration page---------------------------
                        InkWell(
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Color(0xFF4A90E2), fontSize: 15),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: gapbetweenTextfield,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
