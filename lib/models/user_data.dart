import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

//collecting and maintaining data using provider

class UserData extends ChangeNotifier {
  int? userId;
  String? userName = '';
  String? userPhonenumber = '';
  List<String>? singleContactName = [];

  getuserNameFSP() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getInt('useridSP');
    userName = preferences.getString('usernameSP');
    userPhonenumber = preferences.getString('userphonenumberSP');
    singleContactName = preferences.getStringList('emergencysingleName');
    notifyListeners();
  }

  get userid => userId;
  get username => userName;
  get userphonenumber => userPhonenumber;
  get usersinglecontactList => singleContactName;
}
