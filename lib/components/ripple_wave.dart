import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:awesome_ripple_animation/awesome_ripple_animation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shatarkopanicbtn/constant/api_url.dart';
import 'package:shatarkopanicbtn/mqtt/mqtt_manager.dart';

class RippleWave extends StatefulWidget {
  final String id;
  final String username;
  final String panictype;
  final String imagePath;

  const RippleWave(
      {super.key,
      required this.id,
      required this.imagePath,
      required this.username,
      required this.panictype});

  @override
  State<RippleWave> createState() => _RippleWaveState();
}

class _RippleWaveState extends State<RippleWave> {
//--------------------------------------------------make a http request---------------------------------------------

  sendingPanic(String id, String panicType, String date, String time) async {
    try {
      Response response =
          await post(Uri.parse('${Apiurl.apiURl}/sendingPanic'), body: {
        'user_id': id,
        'user_name': widget.username,
        'panic_type': panicType,
        'button_pressed_date': date,
        'button_pressed_time': time,
      });
      if (response.statusCode == 200) {
        log('success');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  MQTTClintManager manager = MQTTClintManager();
  ValueNotifier<int> timeLeft = ValueNotifier<int>(3);
  Timer? timer;

  void startcountDown() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
      } else {
        DateTime buttonpressedDateTime = DateTime.now();
        log(buttonpressedDateTime.toString());
        var data = json.encode({
          'userName': widget.username,
          'panicType': widget.panictype,
          'time': DateFormat('hh:mm:ss a').format(buttonpressedDateTime) +
              DateFormat('yyyy-MM-dd').format(buttonpressedDateTime)
        });
        manager.publish(widget.username, data);
        //sending http request
        sendingPanic(
            widget.id,
            widget.panictype,
            DateFormat('hh:mm:ss a').format(buttonpressedDateTime),
            DateFormat('yyyy-MM-dd').format(buttonpressedDateTime));
        // showNotification();
        stopTimer();
        Navigator.pop(context);
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    manager.connect(widget.username);
    startcountDown();
  }

  @override
  void dispose() {
    // Navigator.pop(context);
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 150,
          ),
          SizedBox(
            height: 100,
            width: 100,
            child: RippleAnimation(
              key: UniqueKey(),
              repeat: true,
              duration: const Duration(
                milliseconds: 2300,
              ),
              ripplesCount: 5,
              color: Colors.red,
              minRadius: 100,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 220,
          ),
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Alarm will be sent within ',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: const Color(0xFFD00000),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: timeLeft,
                builder: (context, int value, child) {
                  return Text(
                    '$value s',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: const Color(0xFFD00000),
                    ),
                  );
                },
              ),
            ],
          )),
          const SizedBox(
            height: 110,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70.0),
            child: GestureDetector(
              onTap: () {
                log('tap');
                Navigator.pop(context);
                stopTimer();
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: 3.0,
                      style: BorderStyle.solid,
                      color: const Color(0xFFD00000)),
                ),
                child: Center(
                  child: Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        color: const Color(0xFFD00000)),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
