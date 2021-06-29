import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:health_care/MainScreen/profile.dart';

import 'package:health_care/RegulationSreen/blood_pressure_screen.dart';
import 'package:health_care/RegulationSreen/blood_sugar_screen.dart';
import 'package:health_care/RegulationSreen/heart_rate.dart';
import 'package:health_care/RegulationSreen/water_screen.dart';
import 'package:health_care/model/Diseases.dart';

import 'package:health_care/constants.dart';
import 'package:health_care/main.dart';
import 'package:health_care/service/auth.dart';
import 'package:health_care/sign_in/sign_in_screen.dart';
import 'DataSearch.dart';

class HeathFunctionClassInfo {
  final String Name, ImageURL;

  HeathFunctionClassInfo({this.Name, this.ImageURL});
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<HeathFunctionClassInfo> demoList = [
    HeathFunctionClassInfo(
        Name: "Huyết áp", ImageURL: 'assets/images/blood-pressure.png'),
    HeathFunctionClassInfo(
        Name: "Nhu cầu nước", ImageURL: 'assets/images/water.png'),
    HeathFunctionClassInfo(
        Name: "Kiểm tra nhịp tim", ImageURL: 'assets/images/heart-rate.png'),
    HeathFunctionClassInfo(
        Name: "Đường huyết", ImageURL: 'assets/images/blood-sugar.png'),
  ];

  List<Diseases> diseases = [];

  String buildLoiChao() {
    DateTime time = new DateTime.now();
    if (time.hour > 6 && time.hour <= 11) {
      return "Chào buổi sáng!";
    }
    if (time.hour > 11 && time.hour <= 14) {
      return "Chào buổi trưa!";
    }
    if (time.hour > 14 && time.hour <= 18) {
      return "Chào buổi chiều!";
    }
    if (time.hour > 18 && time.hour <= 21) {
      return "Chào buổi tối!";
    }
    return "Chúc ngủ ngon";
  }

  void buildScreen(int index, BuildContext context) {
    switch (demoList[index].Name) {
      case "Huyết áp":
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BloodPressureScreen(),
            ),
          );
          break;
        }
      case "Nhu cầu nước":
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WaterConsumptionScreen(),
            ),
          );
          break;
        }
      case "Kiểm tra nhịp tim":
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HeartRateScreen(),
            ),
          );
          break;
        }
      case "Đường huyết":
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BloodSugarScreen(),
            ),
          );
          break;
        }
      default:
        break;
    }
  }

  Future<void> _signOut() async {
    try {
      await widget.auth.signOut();
    } catch (e) {
      print(e.toString());
    }
    currentUser = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 38.0,
        leading: IconButton(
          padding: EdgeInsets.only(left: 8.0),
          icon: Icon(Icons.account_circle_rounded),
          iconSize: 40,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
          },
        ),
        title: Text(
          buildLoiChao(),
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
              padding: EdgeInsets.only(left: 8.0),
              child: Text("Tìm kiếm thông tin về sức khỏe",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20.0,
                  ))),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.indigo[300],
                minimumSize:
                    Size(MediaQuery.of(context).size.width * 0.8, 26.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: DataSearch(
                    hintText: "Tìm kiếm",
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 8.0,
                ),
                child: Transform(
                  transform: Matrix4.translationValues(-8, 0.0, 0.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.search_sharp,
                        color: Colors.white,
                        size: 36,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        "Tìm kiếm",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "Theo dõi thông tin sức khỏe",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20.0),
            ),
          ),
          SizedBox(height: 8.0),
          Container(
            color: Colors.indigo[100],
            height: 180.0,
            child: ListView.builder(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        buildScreen(index, context);
                      },
                      child: Container(
                        height: 140.0,
                        width: 200.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.scaleDown,
                              image: AssetImage(demoList[index].ImageURL)),
                          //fix later
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                      child: Text(
                        demoList[index].Name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: defaultPadding),
          Container(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Thông tin thường nhật",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
          ),
          StreamBuilder<List<Diseases>>(
              stream: _getBenh(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    alignment: FractionalOffset.center,
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  final data = snapshot.data;
                  diseases = data;
                }
                return _buildThongTinThuongNhat(diseases);
              })
        ],
      ),
    );
  }

  Stream<List<Diseases>> _getBenh() {
    final snapshots =
        FirebaseFirestore.instance.collection('diseases').snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => Diseases.fromMap(snapshot.data()),
        )
        .toList());
  }

  _buildThongTinBenh(List<Diseases> diseases,int index) {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => Scaffold(
      body: new ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15, 20, 10, 0),
            alignment: Alignment.topLeft,
            child: Text(
              "Mô tả",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(15, 7, 10, 10),
            child: Text(
              diseases[index].moTa,
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          Divider(height: 10,),
          Container(
            padding: EdgeInsets.fromLTRB(15, 10, 10, 0),
            alignment: Alignment.topLeft,
            child: Text(
              "Triệu chứng",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(15, 7, 10, 10),
            child: Text(
              diseases[index].trieuChung,
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          Divider(height: 10,),
          Container(
            padding: EdgeInsets.fromLTRB(15, 10, 10, 0),
            alignment: Alignment.topLeft,
            child: Text(
              "Chuẩn đoán",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(15, 7, 10, 10),
            child: Text(
              diseases[index].chuanDoan,
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          Divider(height: 10,),
          Container(
            padding: EdgeInsets.fromLTRB(15, 10, 10, 0),
            alignment: Alignment.topLeft,
            child: Text(
              "Điều trị",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(15, 7, 10, 10),
            child: Text(
              diseases[index].dieuTri,
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    ) ),) ;
  }

  Widget _buildThongTinThuongNhat(List<Diseases> diseases) {
    var rng = new Random();
    int randomIndex = rng.nextInt(diseases.length);
    return Container(
      margin:
          const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Colors.indigo[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        onPressed: () {_buildThongTinBenh(diseases, randomIndex);},
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                diseases[randomIndex].tenBenh.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                diseases[randomIndex].tomTat,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18.0,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
