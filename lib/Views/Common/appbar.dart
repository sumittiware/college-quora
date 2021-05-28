import 'package:flutter/material.dart';
import 'package:quora/Providers/appproviders.dart';
import 'package:quora/styles/colors.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget {
  final title;
  CustomAppBar({this.title});
  getTitle(int index) {
    if (index == 0) {
      return "Home";
    } else if (index == 1) {
      return "Chat";
    } else if (index == 2) {
      return "Notification";
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    final appconfig = Provider.of<AppProviders>(context);
    return AppBar(
      iconTheme: IconThemeData(color: AppColors.violet),
      title: Text(getTitle(appconfig.currentIndex)),
      elevation: 2,
      backgroundColor: AppColors.orange,
      bottom: (appconfig.currentIndex == 0)
          ? PreferredSize(
              preferredSize: Size(double.infinity, 45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: _deviceSize.width * 0.7,
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 18,
                          ),
                          Icon(
                            Icons.search_rounded,
                            color: AppColors.violet,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text("Search")
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: _deviceSize.width * 0.1,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Icon(
                          Icons.filter_list_rounded,
                          color: AppColors.violet,
                        )),
                  )
                ],
              ))
          : PreferredSize(
              child: Container(),
              preferredSize: Size(double.infinity, 0),
            ),
    );
  }
}
