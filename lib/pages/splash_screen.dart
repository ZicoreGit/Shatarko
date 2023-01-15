import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shatarkopanicbtn/components/bottom_nav_bar.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //location
  String lat = '';
  String long = '';
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionStatus;
  late LocationData _locationData;
  getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }
    _permissionStatus = await location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
    }

    if (_permissionStatus == PermissionStatus.granted) {
      _locationData = await location.getLocation();
      log(_locationData.toString());
      setState(() {
        lat = _locationData.latitude.toString();
        long = _locationData.longitude.toString();
      });
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
      );
    }
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("location:$lat"),
            Text(long),
          ],
        ),
      ),
    );
  }
}
