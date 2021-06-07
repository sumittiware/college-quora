import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quora/Providers/filter.dart';
import 'package:quora/styles/colors.dart';

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  List<String> tags = [];
  @override
  Widget build(BuildContext context) {
    final filters = Provider.of<Filter>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Dialog(
      child: Container(
        height: size.height * 0.6,
        width: size.width * 0.8,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: LayoutBuilder(builder: (ctx, constarints) {
          final height = constarints.maxHeight;
          final width = constarints.maxWidth;
          return Column(
            children: [
              SizedBox(
                height: height * 0.1,
                child: Align(
                    alignment: Alignment.center, child: Text("Select Tags")),
              ),
              Wrap(
                children: List.generate(filters.filters.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      if (tags.contains(filters.filters[index])) {
                        tags.remove(filters.filters[index]);
                      } else {
                        tags.add(filters.filters[index]);
                      }
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: (tags.contains(filters.filters[index]))
                              ? AppColors.violet
                              : Colors.transparent,
                          border: Border.all(color: AppColors.violet),
                          borderRadius: BorderRadius.circular(14)),
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(4),
                      child: Text(
                        filters.filters[index],
                        style: TextStyle(
                            color: (tags.contains(filters.filters[index]))
                                ? Colors.white
                                : AppColors.violet),
                      ),
                    ),
                  );
                }),
              ),
              Spacer(),
              SizedBox(
                height: height * 0.1,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Add Tags')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                          onPressed: () {
                            filters.setTags(tags);
                            Navigator.pop(context);
                          },
                          child: Text('Submit')),
                    ),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
