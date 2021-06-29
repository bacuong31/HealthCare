

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_care/model/Diseases.dart';
import 'package:intl/intl.dart';
class SearchResult extends StatelessWidget {
  String query;
  List<Diseases> diseases = [];
  SearchResult({this.query});

  @override
  Widget build(BuildContext context) {
    String title = toBeginningOfSentenceCase(query);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
              title,

          ),
        ),

        body: StreamBuilder<List<Diseases>>(
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
              return _buildThongTinBenh(diseases);
            }));
  }

  Widget _buildThongTinBenh(List<Diseases> diseases) {
    return ListView(

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
            diseases[0].moTa,
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
            diseases[0].trieuChung,
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
            diseases[0].chuanDoan,
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
            diseases[0].dieuTri,
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  Stream<List<Diseases>> _getBenh() {
    final snapshots = FirebaseFirestore.instance
        .collection('diseases')
        .where('tenBenh', isEqualTo: query)
        .snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => Diseases.fromMap(snapshot.data()),
        )
        .toList());
  }
}
