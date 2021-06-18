import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';

class RegulationScreen extends StatelessWidget {
  final String screenName;

  const RegulationScreen({Key key, this.screenName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Transform(
            transform: Matrix4.translationValues(-28, 0.0, 0.0),
            child: Center(child: Text(screenName))),
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
                          "Nhịp tim lúc bình thường",
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        //TODO: Thông tin Text này dựa trên màn hình
                        // Có những cái khác có thêm 1 thông tin bên cạnh
                      ],
                    ),
                    Text("90 BPM",style: TextStyle(
                      fontSize: 16,
                    ),),
                    //TODO: Thông tin Text này dựa trên màn hình
                    Text(
                      "Lần cập nhật gần nhất: dd/mm/yyyy",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    //TODO: cập nhật ngày
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
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
