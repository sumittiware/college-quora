import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quora/Configurations/apiConfig.dart';
import 'package:quora/Models/user.dart';
import 'package:quora/Providers/userProvider.dart';
import 'package:quora/Services/authservices.dart';
import 'package:quora/Views/Common/error.dart';
import 'package:quora/Views/Profile/edit_profilepage.dart';
import 'package:quora/Views/Profile/widgets/panel.dart';
import 'package:quora/styles/colors.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
    // Provider.of<UserProvider>(context, listen: false)
    //     .getUser(user)
    //     .then((userdata) {})
    //     .catchError((error) {
    //   print(error);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding.top;
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
      body: FutureBuilder(
        future: Provider.of<UserProvider>(context, listen: false).getUser(user),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : (snapshot.hasError)
                  ? AppError(
                      error: snapshot.error.toString(),
                    )
                  : SlidingUpPanel(
                      body: SingleChildScrollView(
                        child: SizedBox(
                          height: _deviceSize.height * 0.6 -
                              (kToolbarHeight + padding),
                          child: Column(
                            children: [
                              SizedBox(
                                  height: _deviceSize.height * 0.15,
                                  width: _deviceSize.width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 60,
                                          backgroundImage: NetworkImage(
                                              snapshot.data.imageURl),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data.username ?? "none",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  side: BorderSide(
                                                      color: AppColors.orange),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return EditProfileScreen();
                                                  }));
                                                },
                                                child: Text(
                                                  "Edit Profile",
                                                  style: TextStyle(
                                                      color: AppColors.orange),
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
                                  snapshot.data.college, null),
                              _infoTile(Icons.h_plus_mobiledata_outlined,
                                  snapshot.data.branch, null),
                              _infoTile(Icons.group, snapshot.data.year, null),
                              _infoTile(
                                  Icons.contact_phone_outlined,
                                  snapshot.data.contact,
                                  snapshot.data.numberverified),
                              _infoTile(
                                  Icons.contact_mail_outlined,
                                  snapshot.data.email,
                                  snapshot.data.emailverified),
                              _infoTile(Icons.calendar_today_outlined,
                                  snapshot.data.createdDate, null),
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
                            ],
                          ),
                        ),
                      ),
                      padding: EdgeInsets.all(12),
                      minHeight: _deviceSize.height * 0.4,
                      maxHeight: _deviceSize.height,
                      panel: Container(
                        child: BottomPanel(),
                      ),
                    );
        },
      ),
    );
  }

  Widget _infoTile(IconData icon, String data, bool verification) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 8,
          ),
          Text(data ?? "none"),
          Spacer(),
          (verification != null)
              ? ((verification)
                  ? Icon(
                      Icons.verified,
                      color: Colors.green,
                    )
                  : Text(
                      "Verify",
                    ))
              : Container()
        ],
      ),
    );
  }
}
