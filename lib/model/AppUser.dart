import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String phoneNumber;
  final DateTime birthDay;

  const AppUser({this.id, this.photoUrl, this.email, this.name, this.birthDay, this.phoneNumber});

  factory AppUser.fromDocument(DocumentSnapshot document) {
    return AppUser(
      email: document['email'],
      photoUrl: document['photoUrl'],
      id: document.id,
      name: document['name'],
      phoneNumber: document['phoneNumber'],
      birthDay: document["birthDay"],
    );
  }
}
