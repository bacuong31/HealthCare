
import 'package:cloud_firestore/cloud_firestore.dart';

class Diseases {
  final String id;
  final String tenBenh;
  final String moTa;
  final String trieuChung;
  final String chuanDoan;
  final String dieuTri;
  final String tomTat;

  const Diseases({this.id,this.tenBenh,this.moTa,this.trieuChung,this.chuanDoan,this.dieuTri,this.tomTat});

  factory Diseases.fromDocument(DocumentSnapshot document) {
    return Diseases(
      id: document.data()['id'],
      tenBenh: document.data()['tenBenh'],
      moTa: document.data()['moTa'],
      trieuChung: document.data()['trieuChung'],
      chuanDoan: document.data()['chuanDoan'],
      dieuTri: document.data()['dieuTri'],
      tomTat: document.data()['tomTat'],
    );
  }

  factory Diseases.fromMap(Map<String, dynamic> data) {
    return Diseases(
      id: data['id'],
      tenBenh: data['tenBenh'],
      moTa: data['moTa'],
      trieuChung: data['trieuChung'],
      chuanDoan:data['chuanDoan'],
      dieuTri: data['dieuTri'],
      tomTat: data['tomTat'],
    );
  }
}
