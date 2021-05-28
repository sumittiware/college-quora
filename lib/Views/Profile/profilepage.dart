import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quora/Configurations/apiConfig.dart';
import 'package:quora/Models/user.dart';
import 'package:quora/Providers/userProvider.dart';
import 'package:quora/Services/authservices.dart';
import 'package:quora/Views/Profile/edit_profilepage.dart';
import 'package:quora/styles/colors.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool userloading = true;
  Auth user;
  User appuser;

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
    final _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Profile"),
        backgroundColor: AppColors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: _deviceSize.height * 0.15,
                width: _deviceSize.width,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/images/user.jpg'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sumit Tiware",
                            style: TextStyle(fontSize: 20),
                          ),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: AppColors.orange),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return EditProfileScreen();
                                }));
                              },
                              child: Text(
                                "Edit Profile",
                                style: TextStyle(color: AppColors.orange),
                              ))
                        ],
                      )
                    ],
                  ),
                )),
            Container(
              height: 8,
              width: double.infinity,
              color: Colors.grey[200],
            ),
            SizedBox(
              height: 4,
            ),
            _infoTile(Icons.location_on_outlined,
                "Government College of Engineering, Amravati"),
            _infoTile(Icons.h_plus_mobiledata_outlined,
                "Computer Science and Engneering"),
            _infoTile(Icons.group, "2nd year"),
            _infoTile(Icons.contact_phone_outlined, "+91 9874563210"),
            _infoTile(Icons.contact_mail_outlined, "tiwaresumit143@gmail.com"),
            _infoTile(Icons.calendar_today_outlined, "Joined May 2021"),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 4,
              width: double.infinity,
              color: Colors.grey[200],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _scrollTile("Answers", true),
                  _scrollTile("Questions", false),
                  _scrollTile("Followers", false),
                  _scrollTile("Following", false),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 8,
          ),
          Text(data),
        ],
      ),
    );
  }

  Widget _scrollTile(String title, bool isselected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        children: [
          Text("0 $title",
              style: TextStyle(
                  color: (isselected) ? AppColors.violet : Colors.black)),
          SizedBox(height: 4),
          if (isselected)
            Container(
              height: 4,
              width: 70,
              color: AppColors.violet,
            )
        ],
      ),
    );
  }
}
