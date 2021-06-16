import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController birthDayController = TextEditingController();
  DateTime _selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin người dùng'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: (){
            Navigator.of(context).pop;
          },
        ),

      ),
        body: Container(
          padding: EdgeInsets.only(left: 15,top: 20,right: 15),
          child: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Center(
                  child: ProfilePicture(),
                ),
                SizedBox(height: 30),
                buildTextField("Họ và tên", nameController),
                buildTextField("Số điện thoại", phoneNumberController),

              ],
            ),
          ),
        ),
    );
    /*Container(
      padding: EdgeInsets.only(left: 15,top: 20,right: 15),
      child: GestureDetector(
        onTap: (){},
        child: ListView(
          children: [
            Center(
              child: ProfilePicture(),
            ),
            SizedBox(height: 30),
            buildTextField("Họ và tên", nameController),

          ],
        ),
      ),
    );*/
  }
  Widget buildTextField(String hintText, TextEditingController controller){
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        style: TextStyle(
          fontSize: 18,
          color: Colors.black87,
        ),

        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),

          contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),

      ),

      );
  }
}

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 115,
        width: 115,
        child: Stack(clipBehavior: Clip.none, fit: StackFit.expand, children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile_default.png'),

          ),
          Positioned(
              right: -9,
              bottom: 0,
              child: SizedBox(
                height: 45,
                width: 45,
                child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    color: Colors.lightGreen,
                    onPressed: () {},
                    child: Image.asset('assets/images/camera.png')),
              ))
        ]));
  }
}
