import 'package:flutter/material.dart';
import 'package:health_care/RegulationSreen/regulation_screen.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/service/auth.dart';
import 'package:health_care/sign_in/sign_in_screen.dart';
import 'DataSearch.dart';

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

  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
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
              padding: EdgeInsets.only(left: 8.0),
              child: Text("Tìm kiếm thông tin về sức khỏe",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18.0,
                  ))),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.indigo,
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
                  color: Colors.white,
                  fontSize: 18),
            ),
          ),
          SizedBox(height: 8.0),
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
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegulationScreen(
                              screenName: demoList[index].Name,
                            ),
                          ),
                        );
                      },
                      child: Container(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, top: 5.0),
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
