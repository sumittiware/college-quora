import 'package:flutter/material.dart';
import 'package:quora/Views/Home/homescreen.dart';
import 'package:quora/Views/Profile/profilepage.dart';
import 'package:quora/styles/colors.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                      backgroundImage: AssetImage('assets/images/user.jpg'),
                    ),
                    Text(
                      "Sumit Tiware",
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
            _drawerTile(context, Icons.account_circle_outlined, "Profile"),
            SizedBox(
              height: 4,
            ),
            _drawerTile(context, Icons.bookmark_outline_rounded, "Bookmarks"),
            SizedBox(
              height: 4,
            ),
            _drawerTile(context, Icons.settings_outlined, "Settings"),
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
                    onPressed: () {},
                    icon: Icon(Icons.logout, color: AppColors.violet),
                    label: Text("Logout",
                        style: TextStyle(color: AppColors.violet))),
                TextButton.icon(
                    onPressed: () {},
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

  ListTile _drawerTile(BuildContext context, IconData icon, String title) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return ProfilePage();
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
