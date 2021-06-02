import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quora/Providers/filter.dart';
import 'package:quora/styles/colors.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<String> allvalue = [];
  List<String> currentValues = [];

  @override
  Widget build(BuildContext context) {
    allvalue = Provider.of<Filter>(context).filters;
    currentValues = Provider.of<Filter>(context).currentFilters;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Filter feeds"),
        backgroundColor: AppColors.orange,
      ),
      body: Stack(
        children: [
          Wrap(
            children: List.generate(allvalue.length, (index) {
              return Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: (currentValues.contains(allvalue[index]))
                        ? AppColors.violet
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10)),
              );
            }),
          ),
          Positioned(
            child: SizedBox(
              height: 30,
              width: double.infinity,
              child: ElevatedButton(
                child: Text(
                  "Apply",
                ),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    primary: Colors.white, onPrimary: AppColors.violet),
              ),
            ),
          )
        ],
      ),
    );
  }
}
