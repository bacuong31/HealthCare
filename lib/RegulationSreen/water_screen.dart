import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_care/constants.dart';

import '../main.dart';

//TODO: timer push notification to measurement

class ChiSoNuoc {
  final int luongNuoc;
  final int canNang;
  final DateTime ngayCapNhat;
  final String id;

  const ChiSoNuoc({this.luongNuoc, this.canNang, this.ngayCapNhat, this.id});

  factory ChiSoNuoc.fromDocument(DocumentSnapshot document) {
    return ChiSoNuoc(
      luongNuoc: document.data()['luongNuoc'],
      canNang: document.data()['canNang'],
      ngayCapNhat: document.data()['timestamp'].toDate(),
      id: document.data()['id'],
    );
  }

  factory ChiSoNuoc.fromMap(Map<String, dynamic> data) {
    return ChiSoNuoc(
      luongNuoc: data['luongNuoc'],
      canNang: data['canNang'],
      ngayCapNhat: data['timestamp'].toDate(),
      id: data['id'],
    );
  }
}

class WaterConsumptionScreen extends StatefulWidget {
  const WaterConsumptionScreen({Key key}) : super(key: key);

  @override
  _WaterConsumptionScreenState createState() => _WaterConsumptionScreenState();
}

class _WaterConsumptionScreenState extends State<WaterConsumptionScreen> {
  List<ChiSoNuoc> listChiSoNuoc = [];

  //TODO: Lời khuyên cho nước
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
              String _newCanNang = '';
              return AlertDialog(
                title: Text('Thêm chỉ số'),
                content: Container(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0),
                      Text("Cân nặng"),
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        autofocus: true,
                        onChanged: (value) {
                          _newCanNang = value;
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
                      if (_newCanNang == "") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Thất bại, bạn cần nhập chỉ số cân nặng",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        postToFireStore(
                          canNang: int.parse(_newCanNang),
                          luongNuoc: int.parse(_newCanNang) * 31,
                        );
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
            child: Center(child: Text("Nhu cầu nước"))),
      ),
      body: StreamBuilder<List<ChiSoNuoc>>(
          stream: _getChiSoNuoc(),

          initialData: null,

          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot);
              return Center(
                  child: Text("Có lỗi xảy ra! Vui lòng thử lại sau."));
            } else if (snapshot.hasData) {
              final chiSo = snapshot.data;
              listChiSoNuoc = chiSo;
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
                    child: listChiSoNuoc.length == 0
                        ? Container(
                            padding: EdgeInsets.all(10.0),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildChiSo(
                                  "Cân nặng",
                                  "--",
                                  "",
                                ),
                                buildChiSo(
                                  "Nhu cầu nước",
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
                                      "Cân nặng",
                                      listChiSoNuoc.last.canNang.toString(),
                                      "kg",
                                    ),
                                    buildChiSo(
                                      "Nhu cầu nước",
                                      listChiSoNuoc.last.luongNuoc.toString(),
                                      "lít",
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
                                        text: listChiSoNuoc.last.ngayCapNhat
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
                                        String _newCanNang = '';
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
                                                Text("Cân nặng"),
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
                                                    _newCanNang = value;
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
                                                    .collection('water')
                                                    .doc(listChiSoNuoc.last.id)
                                                    .update({
                                                  "canNang":
                                                      int.parse(_newCanNang),
                                                  "luongNuoc":
                                                      int.parse(_newCanNang) *
                                                          31,
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
                                          color: Color(0XFF3F51A0),
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
                  child: listChiSoNuoc.length == 0
                      ? Container()
                      : buildLoiKhuyen(context, listChiSoNuoc.last.canNang),
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
                              "Cân nặng",
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
                          "(kg)",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 13.0),
                        ),
                        listChiSoNuoc.length == 0
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
                                itemCount: listChiSoNuoc.length > 3
                                    ? 3
                                    : listChiSoNuoc.length,
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
                                      children: listChiSoNuoc.length >= 3
                                          ? [
                                              Text(
                                                listChiSoNuoc[listChiSoNuoc
                                                                .length -
                                                            3 +
                                                            index]
                                                        .luongNuoc
                                                        .toString() +
                                                    "/" +
                                                    listChiSoNuoc[listChiSoNuoc
                                                                .length -
                                                            3 +
                                                            index]
                                                        .canNang
                                                        .toString(),
                                              ),
                                              Text(listChiSoNuoc[
                                                      listChiSoNuoc.length -
                                                          3 +
                                                          index]
                                                  .ngayCapNhat
                                                  .toUtc()
                                                  .toString()
                                                  .substring(0, 10))
                                            ]
                                          : [
                                              Text(
                                                listChiSoNuoc[index]
                                                        .luongNuoc
                                                        .toString() +
                                                    "/" +
                                                    listChiSoNuoc[index]
                                                        .canNang
                                                        .toString(),
                                              ),
                                              Text(listChiSoNuoc[index]
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

  Container buildLoiKhuyen(BuildContext context, int _canNang) {
    Color selectionColor = null;
    String suggestion = "Yuul B.Alwright";

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

  void postToFireStore({int canNang, int luongNuoc}) async {
    var reference = FirebaseFirestore.instance.collection('water');
    reference.add({
      "canNang": canNang,
      "luongNuoc": luongNuoc,
      "ownerId": currentUser.id,
      "timestamp": DateTime.now(),
    }).then((DocumentReference doc) {
      String docId = doc.id;
      reference.doc(docId).update({"id": docId});
    });
  }

  Stream<List<ChiSoNuoc>> _getChiSoNuoc() {
    final snapshots = FirebaseFirestore.instance
        .collection('water')
        .orderBy('timestamp')
        .where('ownerId', isEqualTo: currentUser.id)
        .snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => ChiSoNuoc.fromMap(snapshot.data()),
        )
        .toList());
  }
}
