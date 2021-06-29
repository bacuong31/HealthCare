import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_care/constants.dart';

import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../main.dart';

class ChiSoDuongHuyet {
  final int duongHuyet;
  final String trangThai;
  final DateTime ngayCapNhat;
  final String id;

  const ChiSoDuongHuyet(
      {this.duongHuyet, this.trangThai, this.ngayCapNhat, this.id});

  factory ChiSoDuongHuyet.fromDocument(DocumentSnapshot document) {
    return ChiSoDuongHuyet(
      duongHuyet: document.data()['duongHuyet'],
      trangThai: document.data()['trangThai'],
      ngayCapNhat: document.data()['timestamp'].toDate(),
      id: document.data()['id'],
    );
  }

  factory ChiSoDuongHuyet.fromMap(Map<String, dynamic> data) {
    return ChiSoDuongHuyet(
      duongHuyet: data['duongHuyet'],
      trangThai: data['trangThai'],
      ngayCapNhat: data['timestamp'].toDate(),
      id: data['id'],
    );
  }
}

class BloodSugarScreen extends StatefulWidget {
  const BloodSugarScreen({Key key}) : super(key: key);

  @override
  _BloodSugarScreenState createState() => _BloodSugarScreenState();
}

class _BloodSugarScreenState extends State<BloodSugarScreen> {
  List<ChiSoDuongHuyet> listChiSoDuongHuyet = [];

  List<String> loiKhuyen = [
    "Tình trạng đường huyết của bạn hơi thấp, hãy giữ gìn sức khỏe nhé",
    "Tình trạng đường huyết của bạn bình thường. Bạn có thể tìm hiểu thêm thông qua mục tìm kiếm",
    "Bạn đang có dấu hiệu của bệnh tiểu đường. Ứng dụng khuyên bạn nên đến phòng khám uy tín gần nhất",
    "Bạn đang bị bệnh tiểu đường. Ứng dụng khuyên bạn nên đến phòng khám uy tín gần nhất",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String _newDuongHuyet = '';
              String _trangThai = "No";
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Text('Thêm chỉ số'),
                    content: Container(
                      height: 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Đường huyết"),
                          TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            autofocus: true,
                            onChanged: (value) {
                              _newDuongHuyet = value;
                            },
                          ),
                          SizedBox(height: 16.0),
                          Text("Trạng thái"),
                          Column(
                            children: <Widget>[
                              RadioListTile<String>(
                                  title: Text("No"),
                                  value: "No",
                                  groupValue: _trangThai,
                                  onChanged: (String value) {
                                    setState(() {
                                      print("no");
                                      _trangThai = value;
                                    });
                                  }),
                              RadioListTile<String>(
                                  title: Text("Đói"),
                                  value: "Đói",
                                  groupValue: _trangThai,
                                  onChanged: (String value) {
                                    setState(() {
                                      print("đói");
                                      _trangThai = value;
                                    });
                                  }),
                            ],
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
                          if (_newDuongHuyet == "") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "Thất bại, bạn cần nhập chỉ số đường huyết",
                                style: TextStyle(fontSize: 16.0),
                              ),
                              duration: Duration(seconds: 2),
                            ));
                          } else {
                            postToFireStore(
                              duongHuyet: int.parse(_newDuongHuyet),
                              trangThai: _trangThai,
                            );
                          }
                        },
                      ),
                    ],
                  );
                },
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
            child: Center(child: Text("Trạng thái"))),
      ),
      body: StreamBuilder<List<ChiSoDuongHuyet>>(
          stream: _getChiSoDuongHuyet(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot);
              return Center(
                  child: Text("Có lỗi xảy ra! Vui lòng thử lại sau."));
            } else if (snapshot.hasData) {
              final chiSo = snapshot.data;
              listChiSoDuongHuyet = chiSo;
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
                    child: listChiSoDuongHuyet.length == 0
                        ? Container(
                            padding: EdgeInsets.all(10.0),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildChiSo(
                                  "Đường Huyết",
                                  "--",
                                  "",
                                ),
                                buildChiSo(
                                  "Trạng thái",
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
                                      "Đường huyết",
                                      listChiSoDuongHuyet.last.duongHuyet
                                          .toString(),
                                      "mg/dl",
                                    ),
                                    buildChiSo(
                                      "Trạng thái",
                                      listChiSoDuongHuyet.last.trangThai
                                          .toString(),
                                      "",
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
                                        text: listChiSoDuongHuyet
                                            .last.ngayCapNhat
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
                                        String _newDuongHuyet = '';
                                        String _trangThai = "No";
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                              title: Text('Thay đổi chỉ số'),
                                              content: Container(
                                                height: 190,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 8.0),
                                                    Text("Đường huyết"),
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
                                                        _newDuongHuyet = value;
                                                      },
                                                    ),
                                                    Column(
                                                      children: <Widget>[
                                                        RadioListTile<String>(
                                                            title: Text("No"),
                                                            value: "No",
                                                            groupValue:
                                                                _trangThai,
                                                            onChanged:
                                                                (String value) {
                                                              setState(() {
                                                                print("no");
                                                                _trangThai =
                                                                    value;
                                                              });
                                                            }),
                                                        RadioListTile<String>(
                                                            title: Text("Đói"),
                                                            value: "Đói",
                                                            groupValue:
                                                                _trangThai,
                                                            onChanged:
                                                                (String value) {
                                                              setState(() {
                                                                _trangThai =
                                                                    value;
                                                              });
                                                            }),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  child:
                                                      Text('Hủy'.toUpperCase()),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('Lưu thay đổi'
                                                      .toUpperCase()),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'blood_sugar')
                                                        .doc(listChiSoDuongHuyet
                                                            .last.id)
                                                        .update({
                                                      "duongHuyet": int.parse(
                                                          _newDuongHuyet),
                                                      "trangThai": _trangThai,
                                                      "timestamp":
                                                          DateTime.now(),
                                                    });
                                                  },
                                                ),
                                              ],
                                            );
                                          },
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
                    child: listChiSoDuongHuyet.length == 0
                        ? SfLinearGauge(
                            useRangeColorForAxis: true,
                            animateAxis: true,
                            axisTrackStyle: LinearAxisTrackStyle(thickness: 1),
                            minimum: 0.0,
                            maximum: 300.0,
                            ranges: <LinearGaugeRange>[
                              LinearGaugeRange(
                                  startValue: 0,
                                  endValue: 140,
                                  position: LinearElementPosition.outside,
                                  color: Color(0xff0DC9AB)),
                              LinearGaugeRange(
                                  startValue: 140,
                                  endValue: 200,
                                  position: LinearElementPosition.outside,
                                  color: Color(0xffFFC93E)),
                              LinearGaugeRange(
                                  startValue: 200,
                                  endValue: 300,
                                  position: LinearElementPosition.outside,
                                  color: Color(0xffF45656)),
                            ],
                            markerPointers: [
                              LinearShapePointer(
                                value: 140,
                              ),
                            ],
                          )
                        : listChiSoDuongHuyet.last.trangThai == "No"
                            ? SfLinearGauge(
                                useRangeColorForAxis: true,
                                animateAxis: true,
                                axisTrackStyle:
                                    LinearAxisTrackStyle(thickness: 1),
                                minimum: 0.0,
                                maximum: 300.0,
                                ranges: <LinearGaugeRange>[
                                  LinearGaugeRange(
                                      startValue: 0,
                                      endValue: 140,
                                      position: LinearElementPosition.outside,
                                      color: Color(0xff0DC9AB)),
                                  LinearGaugeRange(
                                      startValue: 140,
                                      endValue: 200,
                                      position: LinearElementPosition.outside,
                                      color: Color(0xffFFC93E)),
                                  LinearGaugeRange(
                                      startValue: 200,
                                      endValue: 300,
                                      position: LinearElementPosition.outside,
                                      color: Color(0xffF45656)),
                                ],
                                markerPointers: [
                                  LinearShapePointer(
                                    value: listChiSoDuongHuyet.last.duongHuyet
                                        .toDouble(),
                                  ),
                                ],
                              )
                            : SfLinearGauge(
                                useRangeColorForAxis: true,
                                animateAxis: true,
                                axisTrackStyle:
                                    LinearAxisTrackStyle(thickness: 1),
                                minimum: 0.0,
                                maximum: 200.0,
                                ranges: <LinearGaugeRange>[
                                  LinearGaugeRange(
                                      startValue: 0,
                                      endValue: 100,
                                      position: LinearElementPosition.outside,
                                      color: Color(0xff0DC9AB)),
                                  LinearGaugeRange(
                                      startValue: 100,
                                      endValue: 125,
                                      position: LinearElementPosition.outside,
                                      color: Color(0xffFFC93E)),
                                  LinearGaugeRange(
                                      startValue: 125,
                                      endValue: 200,
                                      position: LinearElementPosition.outside,
                                      color: Color(0xffF45656)),
                                ],
                                markerPointers: [
                                  LinearShapePointer(
                                    value: listChiSoDuongHuyet.last.duongHuyet
                                        .toDouble(),
                                  ),
                                ],
                              ),
                  ),
                ),
                SizedBox(height: defaultPadding),
                Center(
                  child: listChiSoDuongHuyet.length == 0
                      ? Container()
                      : buildLoiKhuyen(
                          context,
                          listChiSoDuongHuyet.last.duongHuyet,
                          listChiSoDuongHuyet.last.trangThai),
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
                              "Đường huyết",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15.0),
                            ),
                            Text(
                              "Trạng thái",
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
                              "(mg/dl)",
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
                        listChiSoDuongHuyet.length == 0
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
                                    Transform(
                                      transform:
                                          Matrix4.translationValues(-5.0, 0, 0),
                                      child: Text("--------",
                                          style: TextStyle(fontSize: 20)),
                                    ),
                                    Text("--------",
                                        style: TextStyle(fontSize: 20)),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: listChiSoDuongHuyet.length > 3
                                    ? 3
                                    : listChiSoDuongHuyet.length,
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
                                      children: listChiSoDuongHuyet.length >= 3
                                          ? [
                                              Text(
                                                listChiSoDuongHuyet[
                                                        listChiSoDuongHuyet
                                                                .length -
                                                            3 +
                                                            index]
                                                    .duongHuyet
                                                    .toString(),
                                              ),
                                              Transform(
                                                transform:
                                                    Matrix4.translationValues(
                                                        20, 0.0, 0.0),
                                                child: Text(
                                                  listChiSoDuongHuyet[
                                                          listChiSoDuongHuyet
                                                                  .length -
                                                              3 +
                                                              index]
                                                      .trangThai,
                                                ),
                                              ),
                                              Text(listChiSoDuongHuyet[
                                                      listChiSoDuongHuyet
                                                              .length -
                                                          3 +
                                                          index]
                                                  .ngayCapNhat
                                                  .toUtc()
                                                  .toString()
                                                  .substring(0, 10))
                                            ]
                                          : [
                                              Text(
                                                listChiSoDuongHuyet[index]
                                                    .duongHuyet
                                                    .toString(),
                                              ),
                                              Transform(
                                                transform:
                                                    Matrix4.translationValues(
                                                        20, 0.0, 0.0),
                                                child: Text(
                                                  listChiSoDuongHuyet[index]
                                                      .trangThai
                                                      .toString(),
                                                ),
                                              ),
                                              Text(listChiSoDuongHuyet[index]
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

  Container buildLoiKhuyen(
      BuildContext context, int duongHuyet, String trangThai) {
    Color selectionColor = Colors.green[200];
    String suggestion = "";

    if (trangThai == "No") {
      if (duongHuyet <= 25) {
        suggestion = loiKhuyen[0];
        selectionColor = normalState;
      } else if (duongHuyet <= 140) {
        suggestion = loiKhuyen[1];
        selectionColor = normalState;
      } else if (duongHuyet <= 200) {
        suggestion = loiKhuyen[2];
        selectionColor = warningState;
      } else {
        suggestion = loiKhuyen[3];
        selectionColor = dangerousState;
      }
    }
    if (trangThai == "Đói") {
      if (duongHuyet <= 100) {
        suggestion = loiKhuyen[1];
        selectionColor = normalState;
      } else if (duongHuyet <= 125) {
        suggestion = loiKhuyen[2];
        selectionColor = warningState;
      } else {
        suggestion = loiKhuyen[3];
        selectionColor = dangerousState;
      }
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
              color: Colors.black,
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

  void postToFireStore({int duongHuyet, String trangThai}) async {
    var reference = FirebaseFirestore.instance.collection('blood_sugar');
    reference.add({
      "duongHuyet": duongHuyet,
      "trangThai": trangThai,
      "ownerId": currentUser.id,
      "timestamp": DateTime.now(),
    }).then((DocumentReference doc) {
      String docId = doc.id;
      reference.doc(docId).update({"id": docId});
    });
  }

  Stream<List<ChiSoDuongHuyet>> _getChiSoDuongHuyet() {
    final snapshots = FirebaseFirestore.instance
        .collection('blood_sugar')
        .orderBy('timestamp')
        .where('ownerId', isEqualTo: currentUser.id)
        .snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => ChiSoDuongHuyet.fromMap(snapshot.data()),
        )
        .toList());
  }
}
