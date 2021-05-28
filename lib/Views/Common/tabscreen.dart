import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_quill/models/documents/nodes/container.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:quora/Providers/appproviders.dart';
import 'package:quora/Views/Chat/chatscreen.dart';
import 'package:quora/Views/Common/appdrawer.dart';
import 'package:quora/Views/EditorScreen/texteditor.dart';
import 'package:quora/Views/Home/homescreen.dart';
import 'package:quora/Views/Notifications/notificationscreen.dart';
import 'package:provider/provider.dart';
import 'package:quora/styles/colors.dart';

import 'appbar.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [HomeScreen(), ChatScreen(), NotificationScreen()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: AppColors.orange,
        inactiveColorPrimary: CupertinoColors.white,
      ),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.chat_bubble_rounded),
          title: ("Chat"),
          activeColorPrimary: AppColors.orange,
          inactiveColorPrimary: Colors.white),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.notifications_active_rounded),
        title: ("Notification"),
        activeColorPrimary: AppColors.orange,
        inactiveColorPrimary: Colors.white,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        child: CustomAppBar(
          title: "Home",
        ),
        preferredSize: Size(
            _deviceSize.width,
            kToolbarHeight +
                ((Provider.of<AppProviders>(context).currentIndex == 0)
                    ? 50
                    : 0)),
      ),
      drawer: AppDrawer(),
      body: Stack(
        children: [
          PersistentTabView(
            context,
            onItemSelected: (index) {
              Provider.of<AppProviders>(context, listen: false)
                  .setPageIndex(index);
            },
            navBarHeight: 70,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(),
            confineInSafeArea: true,
            backgroundColor: AppColors.violet, // Default is Colors.white.
            handleAndroidBackButtonPress: true, // Default is true.
            resizeToAvoidBottomInset:
                true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: true, // Default is true.
            hideNavigationBarWhenKeyboardShows:
                true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(10.0),
              colorBehindNavBar: Colors.white,
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: ItemAnimationProperties(
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimation(
              // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle
                .style12, // Choose the nav bar style with this property.
          ),
          Positioned(
            child: ((Provider.of<AppProviders>(context).currentIndex == 0)
                ? FloatingActionButton(
                    backgroundColor: AppColors.violet,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return EditorPage();
                      }));
                    },
                  )
                : Container()),
            bottom: 90,
            right: 20,
          )
        ],
      ),
    );
  }
}
