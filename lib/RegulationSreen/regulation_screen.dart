import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_care/constants.dart';

class FieldInfo {
  final String infoName;
  int infoValue;
  final String measureUnit;

  FieldInfo(this.infoName, this.infoValue, this.measureUnit);
}

class RegulationScreen extends StatefulWidget {
  final String screenName;

  const RegulationScreen({Key key, this.screenName}) : super(key: key);

  @override
  _RegulationScreenState createState() => _RegulationScreenState();
}

class _RegulationScreenState extends State<RegulationScreen> {
  var dateTime = DateTime.utc(2021, 6, 22);
  List<FieldInfo> listFieldInfo = new List.from([
    new FieldInfo("Nhịp tim lúc bình thường", 90, "BPM"),
    // new FieldInfo("Test", null, "Test"),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.8,
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          listFieldInfo[0].infoName, //firstInfo
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        //TODO: Thông tin Text này dựa trên màn hình
                        // Có những cái khác có thêm 1 thông tin bên cạnh AKA secondInfo
                      ],
                    ),
                    RichText(
                      // Chỉ số
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: listFieldInfo[0].infoValue.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: " " + listFieldInfo[0].measureUnit,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
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
                            text: dateTime.toString().substring(0, 10),
                            // Chỉ lấy đến ngày
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //TODO: Lưu dữ liệu ngày
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            String _newValue = '';
                            return AlertDialog(
                              title: Text('Thay đổi chỉ số'),
                              content: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                autofocus: true,
                                onChanged: (value) {
                                  _newValue = value;
                                },
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Lưu thay đổi'.toUpperCase()),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    //TODO: thay đổi = setState
                                    setState(() {
                                      listFieldInfo[0].infoValue = int.parse(_newValue);
                                      dateTime = DateTime.now().toUtc();
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
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            "Thay đổi chỉ số",
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
        ],
      ),
    );
  }
}
