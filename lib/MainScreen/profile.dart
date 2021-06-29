import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:health_care/model/AppUser.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:health_care/button/RoundedButton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../landing_screen.dart';
import '../main.dart';
import 'main_screen.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController nameController =
      TextEditingController(text: currentUser.name);
  final TextEditingController birthDayController =
      TextEditingController(text: currentUser.birthday);

  List<bool> _isSelected = [false, false];
  String _sexual;
  String _nameLabel;
  String _birthDayLabel;
  DateTime _dateTime;
  File file;
  ImagePicker imagePicker = ImagePicker();
  DateTime _selectedDate;
  bool femaleSelected = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(_nameStartedTyping);
    birthDayController.addListener(_birthDayStartedTyping);
    if (currentUser.sex == "Nam") {
      _isSelected[0] = true;
      _isSelected[1] = false;
      femaleSelected = false;
      _sexual = "Nam";
    } else if (currentUser.sex == "Nữ") {
      _isSelected[0] = false;
      _isSelected[1] = true;
      femaleSelected = true;
      _sexual = "Nữ";
    }
  }

  void _nameStartedTyping() {
    setState(() {
      if (nameController.text.isNotEmpty) {
        _nameLabel = "Họ tên";
      } else {
        _nameLabel = null;
      }
    });
  }

  void _birthDayStartedTyping() {
    setState(() {
      if (birthDayController.text.isNotEmpty) {
        _birthDayLabel = "Ngày sinh";
      } else {
        _birthDayLabel = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /*FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.id)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                  alignment: FractionalOffset.center,
                  child: CircularProgressIndicator());
            }
            AppUser user = AppUser.fromDocument(snapshot.data);
            currentUser = user;*/
    /*           nameController.text = user.name;
            birthDayController.text = user.birthday;

            if (user.sex == "Nam") {
              _isSelected[0] = true;
              _isSelected[1] = false;
              femaleSelected = false;
            } else if (user.sex == "Nữ") {
              _isSelected[0] = false;
              _isSelected[1] = true;
              femaleSelected = true;
            }*/
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Thông tin người dùng'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                applyChanges();
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => MainScreen()),
                );
                print(currentUser.name);
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: ProfileImage(context),
              ),
              SizedBox(height: 60),
              buildTextField("Họ tên", nameController),
              buildTextBirthDay(),
              buildSexual(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSexual() {
    return Padding(
        padding: EdgeInsets.fromLTRB(8, 14, 0, 0),
        child: Row(children: [
          Text(
            "Chọn giới tính: ",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          Divider(),
          ToggleButtons(
              isSelected: _isSelected,
              renderBorder: false,
              selectedColor: femaleSelected
                  ? Colors.pink[400]
                  : Color.fromRGBO(63, 229, 235, 1),
              fillColor: Colors.white,
              children: <Widget>[
                buildMaleIconButton(),
                buildFemaleIconButton(),
              ],
              onPressed: (int newIndex) {
                if (newIndex == 0) {
                  _isSelected[0] = true;
                  _isSelected[1] = false;
                  setState(() {
                    femaleSelected = false;
                    _sexual = "Nam";
                  });
                } else if (newIndex == 1) {
                  _isSelected[0] = false;
                  _isSelected[1] = true;
                  setState(() {
                    femaleSelected = true;
                    _sexual = "Nữ";
                  });
                }
              })
        ]));
  }

  Widget buildMaleIconButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(MdiIcons.humanMale,
                color: femaleSelected
                    ? Colors.black26
                    : Color.fromRGBO(63, 229, 235, 1)),
          ),
          Text('Nam', style: TextStyle(fontSize: 20))
        ],
      ),
    );
  }

  Widget buildFemaleIconButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(MdiIcons.humanFemale,
                color: femaleSelected ? Colors.pink[400] : Colors.black26),
          ),
          Text('Nữ', style: TextStyle(fontSize: 20))
        ],
      ),
    );
  }

  Widget ProfileImage(BuildContext context) {
    return SizedBox(
        height: 115,
        width: 115,
        child: Stack(clipBehavior: Clip.none, fit: StackFit.expand, children: [
          (file != null)
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                    file,
                    width: 100,
                    height: 100,
                    fit: BoxFit.fitHeight,
                  ),
                )
              : ((currentUser.photoUrl != "")
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(currentUser.photoUrl),
                      radius: 50.0,
                    )
                  : CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/profile_default.png'),
                      radius: 50.0,
                    )),
          Positioned(
              right: -6,
              bottom: 0,
              child: SizedBox(
                height: 40,
                width: 40,
                child: RawMaterialButton(
                  onPressed: () {
                    changeProfileImage(context);
                  },
                  elevation: 2.0,
                  fillColor: Colors.green,
                  //fillColor: Color(0x60FFFFFF),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  padding: EdgeInsets.all(10.0),
                  shape: CircleBorder(),
                ),
                /*FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    color: Colors.lightGreen,
                    onPressed: () {
                      changeProfileImage(context);
                    },
                    child: Image.asset('assets/images/camera.png'))*/
              ))
        ]));
  }

  Widget buildTextBirthDay() {
    return TextFormField(
      focusNode: new AlwaysDisabledFocusNode(),
      controller: birthDayController,
      style: TextStyle(
        fontSize: 20,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black87, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelText: _birthDayLabel,
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        hintText: "Ngày sinh",
        hintStyle: TextStyle(
          fontSize: 20,
          color: Colors.grey,
        ),
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      onTap: () {
        _selectDate(context);
      },
    );
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                surface: Colors.blueGrey,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.blue[50],
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      birthDayController
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: birthDayController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  Widget buildTextField(String hintText, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextFormField(
        style: TextStyle(
          fontSize: 20,
          color: Colors.black87,
        ),
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromRGBO(10, 63, 196, 1), width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          labelText: _nameLabel,
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
          contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }

  _selectNewImage(BuildContext parentContext) async {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 400,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(29),
                    topRight: const Radius.circular(29),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.remove, color: Colors.grey),
                  const Text(
                    'Ảnh đại diện',
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RoundedButton(
                    text: "Chụp ảnh",
                    press: () async {
                      Navigator.pop(context);
                      PickedFile imageFile = await imagePicker.getImage(
                          source: ImageSource.camera,
                          maxWidth: 1920,
                          maxHeight: 1200,
                          imageQuality: 80);
                      setState(() {
                        file = File(imageFile.path);
                      });
                    },
                  ),
                  RoundedButton(
                    text: "Thư viện ảnh",
                    press: () async {
                      Navigator.of(context).pop();
                      PickedFile imageFile = await imagePicker.getImage(
                          source: ImageSource.gallery,
                          maxWidth: 1920,
                          maxHeight: 1200,
                          imageQuality: 80);
                      setState(() {
                        file = File(imageFile.path);
                      });
                    },
                  ),
                  RoundedButton(
                    text: "Thoát",
                    press: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<String> uploadImage(var imageFile) async {
    var uuid = Uuid().v1();
    Reference ref = FirebaseStorage.instance.ref().child("profile_$uuid.jpg");
    UploadTask uploadTask = ref.putFile(imageFile);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  changeProfileImage(BuildContext context) async {
    file = null;
    await _selectNewImage(context);
  }

  reloadCurrentModelUserData() async {
    DocumentSnapshot userRecord = await ref.doc(currentUser.id).get();
    if (userRecord.data() != null) {}
    userRecord = await ref.doc(currentUser.id).get();
    currentUser = await AppUser.fromDocument(userRecord);
    //print("[IN-FUNCTION edited photo url] " + currentUser.photoUrl);
  }

  applyChanges() async {
    //print("[current photo url] " + currentUserModel.photoUrl);

    //print("[Ten] " + nameController.text);
    if (file != null) {
      if (currentUser.photoUrl != "") {
        Reference ref =
            FirebaseStorage.instance.refFromURL(currentUser.photoUrl);
        ref.delete();
      }
      uploadImage(file).then((data) => FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.id)
              .update({
            "photoUrl": data,
            "name": nameController.text,
            "birthday": birthDayController.text,
            "sex": _sexual
          }).whenComplete(() async => {reloadCurrentModelUserData()}));
      file = null;
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.id)
          .update({
        "name": nameController.text,
        "birthday": birthDayController.text,
        "sex": _sexual
      }).whenComplete(() async => {reloadCurrentModelUserData()});
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
