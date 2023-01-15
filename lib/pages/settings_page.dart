import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shatarkopanicbtn/pages/login_page.dart';
import 'package:shatarkopanicbtn/styles/page_style.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //remove shared preferences
  void remove() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('useridSP');
    preferences.remove('usernameSP');
    preferences.remove('userphonenumberSP');
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LogInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      body: SafeArea(
        child: ListView(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: (() {
                  remove();
                }),
                child: const Text('Log out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
