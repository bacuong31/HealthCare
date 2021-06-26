import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String name;
  final String photoUrl;
  final String sex;
  final String birthday;

  const AppUser({this.id, this.photoUrl, this.name, this.birthday, this.sex});

  factory AppUser.fromDocument(DocumentSnapshot document) {
    return AppUser(
      id: document.data()['id'],
      name: document.data()['name'],
      photoUrl: document.data()['photoUrl'],
      sex: document.data()['sex'],
      birthday: document.data()['birthday'],
    );
  }
}
