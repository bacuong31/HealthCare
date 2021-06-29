import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_care/constants.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../main.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void initializeSetting() async {
  var initAndroid = AndroidInitializationSettings('app_notification_icon');
  var initSetting = InitializationSettings(android: initAndroid);
  flutterLocalNotificationsPlugin.initialize(initSetting);
}

class ChiSoNhipTim {
  final int nhipTim;
  final DateTime ngayCapNhat;
  final String id;

  const ChiSoNhipTim({this.nhipTim, this.ngayCapNhat, this.id});

  factory ChiSoNhipTim.fromDocument(DocumentSnapshot document) {
    return ChiSoNhipTim(
      nhipTim: document.data()['nhipTim'],
      ngayCapNhat: document.data()['timestamp'].toDate(),
      id: document.data()['id'],
    );
  }

  factory ChiSoNhipTim.fromMap(Map<String, dynamic> data) {
    return ChiSoNhipTim(
      nhipTim: data['nhipTim'],
      ngayCapNhat: data['timestamp'].toDate(),
      id: data['id'],
    );
  }
}

class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({Key key}) : super(key: key);

  @override
  _HeartRateScreenState createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen> {
  List<ChiSoNhipTim> listChiSoNhipTim = [];

  List<String> loiKhuyen = [
    "Nhịp tim của bạn đang ở mức bình thường.",
    "Nhịp tim của bạn nhanh hơn bình thường. Bạn đang có dấu hiệu bệnh lý về tim mạch. Hãy đến gặp bác sĩ để tìm hiểu thêm."
  ];

  @override
  void initState() {
    initializeSetting();
    tz.initializeTimeZones();
    super.initState();
  }

  Future<void> displayNotification() async {
    print("Notification is sent");
    flutterLocalNotificationsPlugin.cancel(2);
    Duration duration;
    if (selectionColor == normalState) {
      duration = new Duration(days: 14);
    }
    if (selectionColor == warningState) {
      duration = new Duration(days: 3);
    }
    if (selectionColor == dangerousState) {
      duration = new Duration(seconds: 3);
    }
    flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      "Nhắc nhở",
      "Đây là thông báo nhắc nhở đo chỉ số nhịp tim",
      tz.TZDateTime.now(tz.local).add(duration),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          'channel des',
        ),
      ),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String _newNhipTim = '';
              return AlertDialog(
                title: Text('Thêm chỉ số'),
                content: Container(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0),
                      Text("Nhịp tim"),
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        autofocus: true,
                        onChanged: (value) {
                          _newNhipTim = value;
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text('Hủy'.toUpperCase()),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text('Thêm chỉ số'.toUpperCase()),
                    onPressed: () {
                      Navigator.pop(context);
                      if (_newNhipTim == "") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Thất bại, bạn cần nhập chỉ số nhịp tim",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        postToFireStore(
                          nhipTim: int.parse(_newNhipTim),
                        );
                        displayNotification();
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Thêm chỉ số',
        child: Icon(Icons.add, size: 35.0),
      ),
      appBar: AppBar(
        title: Transform(
            transform: Matrix4.translationValues(-28, 0.0, 0.0),
            child: Center(child: Text("Nhịp tim"))),
      ),
      body: StreamBuilder<List<ChiSoNhipTim>>(
          stream: _getChiSoNhipTim(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot);
              return Center(
                  child: Text("Có lỗi xảy ra! Vui lòng thử lại sau."));
            } else if (snapshot.hasData) {
              final chiSo = snapshot.data;
              listChiSoNhipTim = chiSo;
            }
            return ListView(
              children: <Widget>[
                Container(height: defaultPadding),
                Center(
                  child: Card(
                    elevation: 3.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    child: listChiSoNhipTim.length == 0
                        ? Container(
                            padding: EdgeInsets.all(10.0),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildChiSo(
                                  "Nhịp tim",
                                  "--",
                                  "",
                                ),

                              ],
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildChiSo(
                                      "Nhịp tim",
                                      listChiSoNhipTim.last.nhipTim.toString(),
                                      "BPM",
                                    ),
                                  ],
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "Lần cập nhật gần nhất: ",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: listChiSoNhipTim.last.ngayCapNhat
                                            .toString()
                                            .substring(0, 10),
                                        // Chỉ lấy đến ngày
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                MaterialButton(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        String _newNhipTim = '';
                                        return AlertDialog(
                                          title: Text('Thay đổi chỉ số'),
                                          content: Container(
                                            height: 150,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 8.0),
                                                Text("Nhịp tim"),
                                                TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: <
                                                      TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  autofocus: true,
                                                  onChanged: (value) {
                                                    _newNhipTim = value;
                                                  },
                                                ),
                                                SizedBox(height: 8.0),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text('Hủy'.toUpperCase()),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                  'Lưu thay đổi'.toUpperCase()),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                FirebaseFirestore.instance
                                                    .collection('heart_rate')
                                                    .doc(listChiSoNhipTim
                                                        .last.id)
                                                    .update({
                                                  "nhipTim":
                                                      int.parse(_newNhipTim),
                                                  "timestamp": DateTime.now(),
                                                });
                                                displayNotification();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 50.0,
                                    width: 240.0,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo[100],
                                      shape: BoxShape.rectangle,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Cập nhật chỉ số",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                          color: lavender,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                  ),
                ),
                SizedBox(height: defaultPadding),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: SfLinearGauge(
                      minorTicksPerInterval: 1,
                      useRangeColorForAxis: true,
                      animateAxis: true,
                      axisTrackStyle: LinearAxisTrackStyle(thickness: 1),
                      minimum: 0.0,
                      maximum: 120.0,
                      ranges: <LinearGaugeRange>[
                        LinearGaugeRange(
                            startValue: 0,
                            endValue: 100,
                            position: LinearElementPosition.outside,
                            color: normalState,),
                        LinearGaugeRange(
                            startValue: 100,
                            endValue: 120,
                            position: LinearElementPosition.outside,
                            color: dangerousState,),
                      ],
                      markerPointers: [
                        LinearShapePointer(
                          value: listChiSoNhipTim.length == 0
                              ? 60.0
                              : listChiSoNhipTim.last.nhipTim.toDouble(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: defaultPadding),
                Center(
                  child: listChiSoNhipTim.length == 0
                      ? Container()
                      : buildLoiKhuyen(context, listChiSoNhipTim.last.nhipTim),
                ),
                SizedBox(height: defaultPadding),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lịch sử đo",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: defaultPadding),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Nhịp tim",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15.0),
                            ),

                            Text(
                              "Ngày cập nhật",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "(BPM)",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13.0),
                            ),
                            Transform(
                              transform:
                                  Matrix4.translationValues(-28, 0.0, 0.0),
                              child: Text(
                                "",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13.0),
                              ),
                            ),
                            Text(
                              "",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13.0),
                            ),
                          ],
                        ),
                        listChiSoNhipTim.length == 0
                            ? Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(
                                  vertical: 4.0,
                                  horizontal: 16.0,
                                ),
                                margin: EdgeInsets.symmetric(vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.indigo[50],
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("--------",
                                        style: TextStyle(fontSize: 20)),
                                    Text("--------",
                                        style: TextStyle(fontSize: 20)),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: listChiSoNhipTim.length > 3
                                    ? 3
                                    : listChiSoNhipTim.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 50,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4.0,
                                      horizontal: 16.0,
                                    ),
                                    margin: EdgeInsets.symmetric(vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo[50],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: listChiSoNhipTim.length >= 3
                                          ? [
                                              Text(
                                                listChiSoNhipTim[
                                                        listChiSoNhipTim
                                                                .length -
                                                            3 +
                                                            index]
                                                    .nhipTim
                                                    .toString(),
                                              ),
                                              Text(listChiSoNhipTim[
                                                      listChiSoNhipTim.length -
                                                          3 +
                                                          index]
                                                  .ngayCapNhat
                                                  .toUtc()
                                                  .toString()
                                                  .substring(0, 10))
                                            ]
                                          : [
                                              Text(
                                                listChiSoNhipTim[index]
                                                    .nhipTim
                                                    .toString(),
                                              ),
                                              Text(listChiSoNhipTim[index]
                                                  .ngayCapNhat
                                                  .toUtc()
                                                  .toString()
                                                  .substring(0, 10))
                                            ],
                                    ),
                                  );
                                },
                              )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: defaultPadding),
              ],
            );
          }),
    );
  }

  Color selectionColor = normalState;
  Container buildLoiKhuyen(BuildContext context, int _nhipTim) {

    String suggestion = "";
    if (_nhipTim <= 100){
      suggestion = loiKhuyen[0];
      selectionColor = normalState;
    } else if (_nhipTim > 100){
      suggestion = loiKhuyen[1];
      selectionColor = dangerousState;
    }
    return Container(
      decoration: BoxDecoration(
        color: selectionColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        children: [
          Text(
            suggestion,
            style: TextStyle(
              color: Colors.white,
              fontSize: 19.0,
            ),
          ),
        ],
      ),
    );
  }

  Column buildChiSo(String name, String value, String unit) {
    return Column(
      children: <Widget>[
        Text(
          name, //firstInfo
          style: TextStyle(
            fontSize: 19,
          ),
        ),
        SizedBox(height: 6.0),
        RichText(
          // Chỉ số
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: value.toString(),
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: " " + unit,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void postToFireStore({int nhipTim}) async {
    var reference = FirebaseFirestore.instance.collection('heart_rate');
    reference.add({
      "nhipTim": nhipTim,
      "ownerId": currentUser.id,
      "timestamp": DateTime.now(),
    }).then((DocumentReference doc) {
      String docId = doc.id;
      reference.doc(docId).update({"id": docId});
    });
  }

  Stream<List<ChiSoNhipTim>> _getChiSoNhipTim() {
    final snapshots = FirebaseFirestore.instance
        .collection('heart_rate')
        .orderBy('timestamp')
        .where('ownerId', isEqualTo: currentUser.id)
        .snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => ChiSoNhipTim.fromMap(snapshot.data()),
        )
        .toList());
  }
}
