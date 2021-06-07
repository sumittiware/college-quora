import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quora/Providers/panelcontroller.dart';
import 'package:quora/styles/colors.dart';

class BottomPanel extends StatefulWidget {
  // const BottomPanel({ Key? key }) : super(key: key);

  @override
  _BottomPanelState createState() => _BottomPanelState();
}

class _BottomPanelState extends State<BottomPanel> {
  @override
  Widget build(BuildContext context) {
    final panelController = Provider.of<PanelController>(context);
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _scrollTile("Answers", 0, panelController),
              _scrollTile("Questions", 1, panelController),
              _scrollTile("Followers", 2, panelController),
              _scrollTile("Following", 3, panelController),
            ],
          ),
        )
      ],
    );
  }

  Widget _scrollTile(String title, int index, PanelController panelController) {
    print(panelController.index);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: GestureDetector(
        onTap: () => panelController.setIndex(index),
        child: Column(
          children: [
            Text("0 $title",
                style: TextStyle(
                    color: (panelController.index == index)
                        ? AppColors.violet
                        : Colors.black)),
            SizedBox(height: 4),
            if (panelController.index == index)
              Container(
                height: 4,
                width: 70,
                color: AppColors.violet,
              )
          ],
        ),
      ),
    );
  }
}
