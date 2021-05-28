// Dart imports
import 'dart:convert';
import 'dart:io';
// Flutter imports
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
// Project imports
import 'package:quora/Configurations/apiConfig.dart';
import 'package:quora/Services/authservices.dart';
import 'package:quora/Views/Common/showmessage.dart';
import 'package:quora/Views/Home/homescreen.dart';
import 'package:quora/styles/colors.dart';

class CompleteYourProfile extends StatefulWidget {
  final profileUrl;
  CompleteYourProfile(this.profileUrl);
  static const routename = '/completeprofile';
  @override
  _CompleteYourProfileState createState() => _CompleteYourProfileState();
}

class _CompleteYourProfileState extends State<CompleteYourProfile> {
  bool isSubmitting = false;
  File _userImageFile;
  String selectedYear = "None";
  String selectedBranch = "None";
  final _phonenocoltroller = TextEditingController();
  final _collegeController = TextEditingController();

  _completeProfile() async {
    if (_phonenocoltroller.text == '' || _phonenocoltroller.text == null) {
      showCustomSnackBar(context, "Enter contact details!!");
      return;
    }
    if (_collegeController.text == '' || _collegeController.text == null) {
      showCustomSnackBar(context, "Enter College name!!");
      return;
    }
    if (_userImageFile == null && widget.profileUrl == null) {
      showCustomSnackBar(context, "Add profile image!!");
      return;
    }
    setState(() {
      isSubmitting = true;
    });

    final user = Provider.of<Auth>(context, listen: false);
    // print(user.userID);
    // print(user.token);
    final url = API().getUrl(endpoint: "user/createProfile/${user.userID}");
    String filename = _userImageFile.path ?? null;
    final mimeTypeData =
        lookupMimeType(filename, headerBytes: [0xFF, 0xD8]).split('/');

    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('image', filename,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
    request.fields['branch'] = selectedBranch;
    request.fields['year'] = selectedYear;
    request.fields['contact'] = _phonenocoltroller.text;
    request.headers.addAll({
      "Content-type": "multipart/form-data",
      'Authorization': 'Bearer ${user.token}'
    });
    final res = await request.send();
    var response = await http.Response.fromStream(res);
    setState(() {
      isSubmitting = false;
    });
    final resp = json.decode(response.body);
    showCustomSnackBar(context, resp['message']);
    print(resp['message']);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return HomeScreen();
    }));
  }

  void _pickImage() async {
    final image = ImagePicker();
    final imageFile = await image.getImage(source: ImageSource.gallery);
    setState(() {
      _userImageFile = File(imageFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final _padding = MediaQuery.of(context).padding.top;
    final _clipone = _height * 0.4 - (_padding + kToolbarHeight);
    final _cliptwo = _height * 0.1;
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: WaveClipperTwo(
                flip: true,
                reverse: false,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 42),
                height: _clipone,
                color: AppColors.orange,
                child: SvgPicture.asset("assets/svgs/welcome.svg"),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              height: _height - (_clipone + _cliptwo),
              child: Column(
                children: [
                  SizedBox(
                      height: _height * 0.07,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Complete your profile",
                          style: TextStyle(
                              fontSize: 20,
                              color: AppColors.violet,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      )),
                  GestureDetector(
                    onTap: () {
                      _pickImage();
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: (_userImageFile != null)
                                  ? FileImage(_userImageFile)
                                  : (widget.profileUrl == null)
                                      ? AssetImage(
                                          'assets/images/profileplaceholder.png')
                                      : NetworkImage(widget.profileUrl),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(75),
                          border: Border.all(color: AppColors.violet)),
                    ),
                  ),
                  TextField(
                    controller: _phonenocoltroller,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.violet)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.orange)),
                        prefixText: "+91",
                        border: UnderlineInputBorder(),
                        labelText: "Contact",
                        labelStyle:
                            TextStyle(color: AppColors.orange, fontSize: 17)),
                  ),
                  TextField(
                    controller: _collegeController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.violet)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.orange)),
                        border: UnderlineInputBorder(),
                        labelText: "College",
                        labelStyle:
                            TextStyle(color: AppColors.orange, fontSize: 17)),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Choose year",
                          style: TextStyle(
                            color: AppColors.orange,
                            fontSize: 17,
                          ),
                        ),
                        DropdownButton<String>(
                          underline: Container(
                            height: 0.5,
                            width: double.infinity,
                            color: AppColors.orange,
                          ),
                          focusColor: Colors.white,
                          value: selectedYear,
                          style: TextStyle(color: Colors.white),
                          iconEnabledColor: AppColors.orange,
                          items: <String>[
                            'None',
                            '1st',
                            '2nd',
                            '3rd',
                            '4th',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  value,
                                  style: TextStyle(color: AppColors.violet),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String value) {
                            setState(() {
                              selectedYear = value;
                            });
                          },
                        ),
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Choose Branch",
                        style: TextStyle(
                          color: AppColors.orange,
                          fontSize: 16,
                        ),
                      ),
                      DropdownButton<String>(
                        underline: Container(
                          height: 0.5,
                          width: double.infinity,
                          color: AppColors.orange,
                        ),
                        focusColor: Colors.white,
                        value: selectedBranch,
                        style: TextStyle(color: Colors.white),
                        iconEnabledColor: AppColors.orange,
                        items: <String>[
                          'None',
                          'Computer Science & Engineering',
                          'Information Technology',
                          'Electronics & Telecommunication',
                          'Electrical',
                          'Mechanical',
                          'Civil',
                          'Instrumentation',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: TextStyle(color: AppColors.violet)),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          setState(() {
                            selectedBranch = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    height: 50,
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        _completeProfile();
                      },
                      child: (!isSubmitting)
                          ? Text("Submit")
                          : CircularProgressIndicator(),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPrimary: Colors.white,
                          primary: AppColors.violet),
                    ),
                  ),
                ],
              ),
            ),
            ClipPath(
              clipper: WaveClipperTwo(flip: false, reverse: true),
              child: Container(
                height: _cliptwo,
                color: AppColors.violet,
              ),
            )
          ],
        ),
      ),
    ));
  }
}
