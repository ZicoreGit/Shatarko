import 'package:flutter/material.dart';
import 'package:shatarkopanicbtn/styles/page_style.dart';
import 'package:shatarkopanicbtn/tab_components/me_as_emergency_tab.dart';
import 'package:shatarkopanicbtn/tab_components/show_contact_tab.dart';
import 'package:shatarkopanicbtn/tab_components/show_request_tab.dart';

class AllConatcts extends StatefulWidget {
  const AllConatcts({super.key});

  @override
  State<AllConatcts> createState() => _AllConatctsState();
}

class _AllConatctsState extends State<AllConatcts> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          backgroundColor: Styles.backgroundColor,
          body: Column(
            children: const [
              //how many tab need start
              TabBar(
                  indicatorColor: Colors.amber,
                  labelColor: Colors.black,
                  tabs: [
                    Tab(text: 'Conatct'),
                    Tab(
                      text: 'Added Me',
                    ),
                    Tab(
                      text: 'Request',
                    ),
                  ]),
              //how many tab need end

              //tab builder start
              Expanded(
                child: TabBarView(children: [
                  ShowContact(),
                  MeAsAEmergencyContact(),
                  RequestTab(),
                ]),
              ),
              //tab builder end
            ],
          ),
        ),
      ),
    );
  }
}
