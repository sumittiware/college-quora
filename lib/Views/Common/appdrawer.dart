import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quora/Configurations/sharing.dart';
import 'package:quora/Providers/userProvider.dart';
import 'package:quora/Services/authservices.dart';
import 'package:quora/Views/BookMarks/bookmarkscreen.dart';
import 'package:quora/Views/Profile/profilepage.dart';
import 'package:quora/Views/Settings/settingscreen.dart';
import 'package:quora/styles/colors.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).appuser;
    final _deviceSize = MediaQuery.of(context).size;
    return Drawer(
      child: SizedBox(
        height: _deviceSize.height,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              height: _deviceSize.height * 0.2,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: (user.imageURl != null)
                          ? NetworkImage(user.imageURl)
                          : AssetImage('assets/images/user.jpg'),
                    ),
                    Text(
                      user.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 0.5,
              width: double.infinity,
              color: Colors.grey,
            ),
            SizedBox(
              height: 4,
            ),
            _drawerTile(context, Icons.account_circle_outlined, "Profile",
                ProfilePage()),
            SizedBox(
              height: 4,
            ),
            _drawerTile(context, Icons.bookmark_outline_rounded, "Bookmarks",
                BookMarksScreen()),
            SizedBox(
              height: 4,
            ),
            _drawerTile(
                context, Icons.settings_outlined, "Settings", SettingScreen()),
            Spacer(),
            Container(
              height: 0.5,
              width: double.infinity,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Are you sure ?"),
                              content: Text("Do you want to log-out?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context)
                                          .pushReplacementNamed('/');
                                      Provider.of<Auth>(context, listen: false)
                                          .logout();
                                    },
                                    child: Text("Yes")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("No")),
                              ],
                            );
                          });
                    },
                    icon: Icon(Icons.logout, color: AppColors.violet),
                    label: Text("Logout",
                        style: TextStyle(color: AppColors.violet))),
                TextButton.icon(
                    onPressed: () {
                      shareApp();
                    },
                    icon: Icon(Icons.share_outlined, color: AppColors.violet),
                    label: Text(
                      "Share",
                      style: TextStyle(color: AppColors.violet),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  ListTile _drawerTile(
      BuildContext context, IconData icon, String title, Widget navigateTo) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return navigateTo;
        }));
      },
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
      ),
    );
  }
}
