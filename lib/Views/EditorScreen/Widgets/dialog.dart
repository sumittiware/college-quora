import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quora/Providers/filter.dart';
import 'package:quora/styles/colors.dart';

class MyDialog extends StatefulWidget {
  final List<dynamic> tags;
  MyDialog({this.tags});
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  List<dynamic> tags;
  final _newstagController = TextEditingController();
  bool init = true;

  @override
  void didChangeDependencies() {
    if (init) {
      tags = widget.tags ?? [];
    }
    init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final filters = Provider.of<Filter>(context);
    final size = MediaQuery.of(context).size;

    return Material(
      child: Container(
        height: size.height * 0.6,
        width: size.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: LayoutBuilder(builder: (ctx, constarints) {
          final height = constarints.maxHeight;
          final width = constarints.maxWidth;
          return Column(
            children: [
              SizedBox(
                height: 80,
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Select Tags",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    )),
              ),
              SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: size.width * 0.7,
                        child: TextField(
                          controller: _newstagController,
                          decoration: InputDecoration(
                              hintText: "Add tags seprated by space",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            filters.createTag(_newstagController.text);
                            _newstagController.clear();
                            Navigator.pop(context);
                          },
                          child: Text("Add"))
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                child: Wrap(
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
                            borderRadius: BorderRadius.circular(20)),
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
              ),
              Spacer(),
              SizedBox(
                height: 60,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
