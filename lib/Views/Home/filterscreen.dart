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
  void initState() {
    // TODO: implement initState
    allvalue = Provider.of<Filter>(context, listen: false).filters;
    currentValues = Provider.of<Filter>(context, listen: false).currentFilters;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;
    // final padding = MediaQuery.of(context).padding.top;
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                children: List.generate(allvalue.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (currentValues.contains(allvalue[index])) {
                          currentValues.remove(allvalue[index]);
                        } else {
                          currentValues.add(allvalue[index]);
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(6),
                      child: Text(allvalue[index],
                          style: TextStyle(
                              color: ((currentValues.contains(allvalue[index])))
                                  ? Colors.white
                                  : AppColors.violet)),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.violet),
                          color: (currentValues.contains(allvalue[index]))
                              ? AppColors.violet
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  );
                }),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              child: Text(
                "Apply",
              ),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white, primary: AppColors.violet),
            ),
          ),
        ],
      ),
    );
  }
}
