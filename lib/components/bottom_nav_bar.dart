import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shatarkopanicbtn/pages/conatcts_page.dart';
import 'package:shatarkopanicbtn/pages/home_page.dart';
import 'package:shatarkopanicbtn/pages/profile_page.dart';
import 'package:shatarkopanicbtn/pages/settings_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    AllConatcts(),
    ProfilePage(),
    SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFFF3F8FF), // navigation bar color
        statusBarColor: Color(0xFFF3F8FF), // status bar color
        statusBarIconBrightness: Brightness.dark, // status bar icons' color
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          height: 80,
          decoration: const BoxDecoration(
            color: Color(0xFFF3F8FF),
            // boxShadow: [
            //   BoxShadow(
            //     blurRadius: 20,
            //     color: Colors.black.withOpacity(.1),
            //   )
            // ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: GNav(
                // rippleColor: Colors.black,
                // hoverColor: Colors.black,
                gap: 8,
                activeColor: const Color(0xFFF3F8FF),
                iconSize: 25,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.black,
                color: Colors.black,
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.contact_page,
                    text: 'Contact',
                  ),
                  GButton(
                    icon: Icons.person,
                    text: 'Profile',
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: 'Settings',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
