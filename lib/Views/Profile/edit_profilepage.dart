import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:quora/Configurations/apiConfig.dart';
import 'package:quora/Providers/userProvider.dart';

import 'package:quora/Services/authservices.dart';
import 'package:quora/styles/colors.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool userloading = true;
  bool isSubmitting = false;
  File _userImageFile;
  String selectedYear = "None";
  String selectedBranch = "None";
  final _nameController = TextEditingController();
  final _collegeController = TextEditingController();
  Auth user;

  void _pickImage() async {
    final image = ImagePicker();
    final imageFile = await image.getImage(source: ImageSource.gallery);
    setState(() {
      _userImageFile = File(imageFile.path);
    });
  }

  @override
  void initState() {
    user = Provider.of<Auth>(context, listen: false);
    Provider.of<UserProvider>(context, listen: false)
        .getUser(user)
        .then((userdata) {})
        .catchError((error) {
      print(error);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Edit Profile"),
        backgroundColor: AppColors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: (userloading)
              ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
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
                                    : AssetImage(
                                        'assets/images/profileplaceholder.png'),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(75),
                            border: Border.all(color: AppColors.violet)),
                      ),
                    ),
                    TextField(
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.violet)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.orange)),
                          border: UnderlineInputBorder(),
                          labelText: "Name",
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
                          // _completeProfile();
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
      ),
    );
  }
}
