import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/service/auth.dart';
import 'package:health_care/sign_in/sign_in_screen.dart';

class HeathFunctionClassInfo {
  final String Name, ImageURL;


  HeathFunctionClassInfo(this.Name, this.ImageURL);
}

List demoList = [
  HeathFunctionClassInfo("Kiểm tra nhịp tim", null),
  HeathFunctionClassInfo("Huyết áp", null),
  HeathFunctionClassInfo("Đường huyết", null),
  HeathFunctionClassInfo("Nồng độ cồn", null),
  HeathFunctionClassInfo("Nồng độ cồn", null),
];

class MainScreen extends StatelessWidget {
  const MainScreen({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  Future<void> _signOut() async{
    try{
      await auth.signOut();

    } catch(e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.account_circle_rounded),
          iconSize: 40,
          onPressed: () {},
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Chào buổi tối",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text("Trương Bá Cường",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: _signOut,
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: defaultPadding),
          Container(
            color: panelColor,
            height: 160.0,
            child: new ListView.builder(
              padding: EdgeInsets.all(4.0),
              itemCount: demoList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      height: 120.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                        image: null, //fix later
                        color: Colors.black12,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        demoList[index].Name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
