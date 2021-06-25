import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_care/constants.dart';

//TODO: timer push notification to measurement

class ChiSoHuyetAp {
  int tamThu;
  int tamTruong;
  DateTime ngayCapNhat;

  ChiSoHuyetAp(int _tamThu, int _tamTruong) {
    this.tamThu = _tamThu;
    this.tamTruong = _tamTruong;
    this.ngayCapNhat = DateTime.now().toUtc();
  }
}

class RegulationScreen extends StatefulWidget {
  final String screenName;

  const RegulationScreen({Key key, this.screenName}) : super(key: key);

  @override
  _RegulationScreenState createState() => _RegulationScreenState();
}

class _RegulationScreenState extends State<RegulationScreen> {
  List<ChiSoHuyetAp> listChiSoHuyetAp = new List.from([
    new ChiSoHuyetAp(70, 40),
    new ChiSoHuyetAp(71, 41),
  ]);

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
                        setState(() {
                          listChiSoHuyetAp.add(new ChiSoHuyetAp(
                              int.parse(_newTamThu), int.parse(_newTamTruong)));
                        });
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add, size: 35.0),
      ),
      appBar: AppBar(
        title: Transform(
            transform: Matrix4.translationValues(-28, 0.0, 0.0),
            child: Center(child: Text(widget.screenName))),
      ),
      body: ListView(
        children: <Widget>[
          Container(height: defaultPadding),
          Center(
            //TODO: Xử lý phân biệt màn hình
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: listChiSoHuyetAp.length == 0
                  ? Container(
                      padding: EdgeInsets.all(10.0),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.85,
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
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildChiSo(
                                "Tâm thu",
                                listChiSoHuyetAp.last.tamThu.toString(),
                                "mmHg",
                              ),
                              buildChiSo(
                                "Tâm trương",
                                listChiSoHuyetAp.last.tamTruong.toString(),
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
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: listChiSoHuyetAp.last.ngayCapNhat
                                      .toString()
                                      .substring(0, 10),
                                  // Chỉ lấy đến ngày
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          MaterialButton(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                                            keyboardType: TextInputType.number,
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
                                            keyboardType: TextInputType.number,
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
                                        child:
                                            Text('Lưu thay đổi'.toUpperCase()),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            listChiSoHuyetAp.last.tamThu =
                                                int.parse(_newTamThu);
                                            listChiSoHuyetAp.last.tamTruong =
                                                int.parse(_newTamTruong);
                                            listChiSoHuyetAp.last.ngayCapNhat =
                                                DateTime.now().toUtc();
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
                                color: Colors.grey,
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Center(
                                child: Text(
                                  "Cập nhật chỉ số",
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
            child: buildLoiKhuyen(context, listChiSoHuyetAp.last.tamThu,
                listChiSoHuyetAp.last.tamTruong),
          ),
          SizedBox(height: defaultPadding),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Text(
                "Lịch sử đo",
                style: TextStyle(color: Colors.red, fontSize: 20.0),
              ),
            ),
          ),//TODO: nhờ Cường chụp phần dưới của huyết áp
          //TODO; Lịch sử
          SizedBox(height: defaultPadding),

        ],
      ),
    );
  }

  Container buildLoiKhuyen(BuildContext context, int _tamThu, int _tamTruong) {
    //TODO: lấy dữ liệu bên Cường, máy t bị nâng cấp phiên bản nên mất chức năng huyết áp
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        //TODO: tham số color dựa trên lời khuyên? Ví dụ: đỏ = nghiêm trọng, xanh = tốt, vàng = cần chú ý
        borderRadius: const BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        children: [
          Text(
            "Lời khuyên từ Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            //TODO: lấy lời khuyên dựa trên 2 chỉ số
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
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
            fontSize: 17,
          ),
        ),
        SizedBox(height: 4.0),
        RichText(
          // Chỉ số
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: value.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: " " + unit,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
