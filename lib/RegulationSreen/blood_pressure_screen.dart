import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_care/constants.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../main.dart';

//TODO: timer push notification to measurement

class ChiSoHuyetAp {
  final int tamThu;
  final int tamTruong;
  final DateTime ngayCapNhat;
  final String id;

  const ChiSoHuyetAp({this.tamThu, this.tamTruong, this.ngayCapNhat, this.id});

  factory ChiSoHuyetAp.fromDocument(DocumentSnapshot document) {
    return ChiSoHuyetAp(
      tamThu: document.data()['tamThu'],
      tamTruong: document.data()['tamTruong'],
      ngayCapNhat: document.data()['timestamp'].toDate(),
      id: document.data()['id'],
    );
  }

  factory ChiSoHuyetAp.fromMap(Map<String, dynamic> data) {
    return ChiSoHuyetAp(
      tamThu: data['tamThu'],
      tamTruong: data['tamTruong'],
      ngayCapNhat: data['timestamp'].toDate(),
      id: data['id'],
    );
  }
}

class BloodPressureScreen extends StatefulWidget {


  const BloodPressureScreen({Key key}) : super(key: key);

  @override
  _BloodPressureScreenState createState() => _BloodPressureScreenState();
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  List<ChiSoHuyetAp> listChiSoHuyetAp = [];

  List<String> loiKhuyen = [
    "Huyết áp của bạn đang ở mức thấp. Hãy bổ sung nước và đường cho cơ thể",
    "Huyết áp của bạn đang ở mức lý tưởng. Hãy đo lại huyết áp sau 1 tháng",
    "Huyết áp của bạn đang rất ổn định. Hãy đo lại huyết áp sau 1 tháng",
    "Bạn đang có bệnh lý về huyết áp. Hãy liên hệ với bác sĩ để được tư vấn và điều trị",
    "Nguy hiểm! Huyết áp của bạn đang rất cao. Hãy đến cơ sở y tế gần nhất để kiểm tra và điều trị"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String _newTamThu = '';
              String _newTamTruong = '';
              return AlertDialog(
                title: Text('Thêm chỉ số'),
                content: Container(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0),
                      Text("Tâm thu"),
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        autofocus: true,
                        onChanged: (value) {
                          _newTamThu = value;
                        },
                      ),
                      SizedBox(height: 8.0),
                      Text("Tâm trương"),
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        autofocus: true,
                        onChanged: (value) {
                          _newTamTruong = value;
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
                      if (_newTamTruong == "" || _newTamThu == "") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Thất bại, bạn cần nhập đủ hai chỉ số",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        postToFireStore(
                            tamThu: int.parse(_newTamThu),
                            tamTruong: int.parse(_newTamTruong));
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
            child: Center(child: Text("Huyết áp"))),
      ),
      body: StreamBuilder<List<ChiSoHuyetAp>>(
          stream: _getChiSoHuyetAp(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text("Có lỗi xảy ra! Vui lòng thử lại sau."));
            } else if (snapshot.hasData) {
              final chiSo = snapshot.data;
              listChiSoHuyetAp = chiSo;
            }
            return ListView(
              children: <Widget>[
                Container(height: defaultPadding),
                Center(
                  //TODO: Xử lý phân biệt màn hình
                  child: Card(
                    elevation: 3.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    child: listChiSoHuyetAp.length == 0
                        ? Container(
                      padding: EdgeInsets.all(10.0),
                      alignment: Alignment.center,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.85,
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildChiSo(
                            "Tâm thu",
                            "--",
                            "",
                          ),
                          buildChiSo(
                            "Tâm trương",
                            "--",
                            "",
                          ),
                        ],
                      ),
                    )
                        : Container(
                      alignment: Alignment.center,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.85,
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              buildChiSo(
                                "Tâm thu",
                                listChiSoHuyetAp.last.tamThu.toString(),
                                "mmHg",
                              ),
                              buildChiSo(
                                "Tâm trương",
                                listChiSoHuyetAp.last.tamTruong
                                    .toString(),
                                "mmHg",
                              ),
                            ],
                          ),
                          //TODO: Thông tin Text này dựa trên màn hình
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
                                  text: listChiSoHuyetAp.last.ngayCapNhat
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
                                  String _newTamThu = '';
                                  String _newTamTruong = '';
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
                                          Text("Tâm thu"),
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
                                              _newTamThu = value;
                                            },
                                          ),
                                          SizedBox(height: 8.0),
                                          Text("Tâm trương"),
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
                                              _newTamTruong = value;
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
                                        child: Text(
                                            'Lưu thay đổi'.toUpperCase()),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          FirebaseFirestore.instance
                                              .collection(
                                              'blood_pressure')
                                              .doc(listChiSoHuyetAp
                                              .last.id)
                                              .update({
                                            "tamThu":
                                            int.parse(_newTamThu),
                                            "tamTruong":
                                            int.parse(_newTamTruong),
                                            "timestamp": DateTime.now(),
                                          });
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
                      maximum: 140.0,
                      ranges: <LinearGaugeRange>[
                        LinearGaugeRange(
                            startValue: 0,
                            endValue: 90,
                            position: LinearElementPosition.outside,
                            color: Color(0xffFFC93E)),
                        LinearGaugeRange(
                            startValue: 90,
                            endValue: 110,
                            position: LinearElementPosition.outside,
                            color: Color(0xff0DC9AB)),
                        LinearGaugeRange(
                            startValue: 110,
                            endValue: 130,
                            position: LinearElementPosition.outside,
                            color: Color(0xffFFC93E)),
                        LinearGaugeRange(
                            startValue: 130,
                            endValue: 140,
                            position: LinearElementPosition.outside,
                            color: Color(0xffF45656)),
                      ],
                      markerPointers: [
                        LinearShapePointer(
                          value: listChiSoHuyetAp.length == 0 ? 70.0 : listChiSoHuyetAp.last.tamThu
                              .toDouble(),
                        ),
                      ],
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
                      maximum: 100.0,
                      ranges: <LinearGaugeRange>[
                        LinearGaugeRange(
                            startValue: 0,
                            endValue: 64,
                            position: LinearElementPosition.outside,
                            color: Color(0xffFFC93E)),
                        LinearGaugeRange(
                            startValue: 64,
                            endValue: 84,
                            position: LinearElementPosition.outside,
                            color: Color(0xff0DC9AB)),
                        LinearGaugeRange(
                            startValue: 84,
                            endValue: 90,
                            position: LinearElementPosition.outside,
                            color: Color(0xffFFC93E)),
                        LinearGaugeRange(
                            startValue: 90,
                            endValue: 100,
                            position: LinearElementPosition.outside,
                            color: Color(0xffF45656)),
                      ],
                      markerPointers: [
                        LinearShapePointer(
                          value: listChiSoHuyetAp.length == 0 ? 50.0:listChiSoHuyetAp.last.tamTruong
                              .toDouble(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: defaultPadding),
                Center(
                  child: listChiSoHuyetAp.length == 0
                      ? Container()
                      : buildLoiKhuyen(context, listChiSoHuyetAp.last.tamThu,
                      listChiSoHuyetAp.last.tamTruong),
                ),
                SizedBox(height: defaultPadding),
                Center(
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.85,
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
                              "Tâm thu/Tâm trương",
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
                        Text(
                          "(mmHg)",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 13.0),
                        ),
                        listChiSoHuyetAp.length == 0
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
                          itemCount: listChiSoHuyetAp.length > 3
                              ? 3
                              : listChiSoHuyetAp.length,
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
                                children: listChiSoHuyetAp.length >= 3
                                    ? [
                                  Text(
                                    listChiSoHuyetAp[
                                    listChiSoHuyetAp
                                        .length -
                                        3 +
                                        index]
                                        .tamThu
                                        .toString() +
                                        "/" +
                                        listChiSoHuyetAp[
                                        listChiSoHuyetAp
                                            .length -
                                            3 +
                                            index]
                                            .tamTruong
                                            .toString(),
                                  ),
                                  Text(listChiSoHuyetAp[
                                  listChiSoHuyetAp.length -
                                      3 +
                                      index]
                                      .ngayCapNhat
                                      .toUtc()
                                      .toString()
                                      .substring(0, 10))
                                ]
                                    : [
                                  Text(
                                    listChiSoHuyetAp[index]
                                        .tamThu
                                        .toString() +
                                        "/" +
                                        listChiSoHuyetAp[index]
                                            .tamTruong
                                            .toString(),
                                  ),
                                  Text(listChiSoHuyetAp[index]
                                      .ngayCapNhat
                                      .toUtc()
                                      .toString()
                                      .substring(0, 10))
                                ],
                              ),
                            );
                          },
                        ) //TODO: change to StreamBuilder later ?
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

  Container buildLoiKhuyen(BuildContext context, int _tamThu, int _tamTruong) {
    Color selectionColor = null;
    String suggestion = null;

    if (_tamThu < 90) {
      if (_tamTruong < 60) {
        suggestion = loiKhuyen[0];
        selectionColor = warningState;
      } else if (_tamTruong >= 60 && _tamTruong <= 84) {
        suggestion = loiKhuyen[1];
        selectionColor = normalState;
      } else {
        suggestion = loiKhuyen[3];
        selectionColor = warningState;
      }
    } else if (_tamThu >= 90 && _tamThu <= 110) {
      if (_tamTruong < 60) {
        suggestion = loiKhuyen[0];
        selectionColor = warningState;
      } else if (_tamTruong >= 60 && _tamTruong <= 84) {
        suggestion = loiKhuyen[1];
        selectionColor = normalState;
      } else {
        suggestion = loiKhuyen[3];
        selectionColor = warningState;
      }
    } else if (_tamThu > 110 && _tamThu <= 130) {
      if (_tamTruong < 60) {
        suggestion = loiKhuyen[0];
        selectionColor = warningState;
      } else if (_tamTruong >= 60 && _tamTruong <= 84) {
        suggestion = loiKhuyen[2];
        selectionColor = normalState;
      } else if (_tamTruong > 84 && _tamTruong <= 90) {
        suggestion = loiKhuyen[3];
        selectionColor = warningState;
      } else {
        suggestion = loiKhuyen[4];
        selectionColor = dangerousState;
      }
    } else if (_tamThu > 130 && _tamThu <= 139) {
      suggestion = loiKhuyen[3];
      selectionColor = warningState;
    } else if (_tamThu > 139) {
      suggestion = loiKhuyen[4];
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
      width: MediaQuery
          .of(context)
          .size
          .width * 0.85,
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

  void postToFireStore({int tamThu, int tamTruong}) async {
    var reference = FirebaseFirestore.instance.collection('blood_pressure');
    reference.add({
      "tamThu": tamThu,
      "tamTruong": tamTruong,
      "ownerId": currentUser.id,
      "timestamp": DateTime.now(),
    }).then((DocumentReference doc) {
      String docId = doc.id;
      reference.doc(docId).update({"id": docId});
    });
  }

  Stream<List<ChiSoHuyetAp>> _getChiSoHuyetAp() {
    final snapshots = FirebaseFirestore.instance
        .collection('blood_pressure')
        .orderBy('timestamp')
        .where('ownerId', isEqualTo: currentUser.id)
        .snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs
            .map(
              (snapshot) => ChiSoHuyetAp.fromMap(snapshot.data()),
        )
            .toList());
  }
}
