import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shatarkopanicbtn/models/user_data.dart';
import 'package:shatarkopanicbtn/styles/page_style.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<UserData>(context, listen: false).getuserNameFSP();
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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('lib/images/male.png'),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Consumer<UserData>(builder: (context, provider, child) {
                return Text(
                  provider.userName.toString(),
                  style: Styles.userNameTextStyle,
                );
              }),
              Consumer<UserData>(builder: (context, provider, child) {
                return Text(
                  provider.userPhonenumber.toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
