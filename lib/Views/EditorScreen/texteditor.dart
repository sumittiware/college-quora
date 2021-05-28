import 'dart:convert'; // access to jsonEncode()

import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:quora/styles/colors.dart';

class EditorPage extends StatefulWidget {
  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  final _titlecontroller = TextEditingController();
  QuillController _controller = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Ask Question"),
          backgroundColor: AppColors.orange,
          actions: [
            IconButton(
              icon: Icon(Icons.save_rounded),
              onPressed: () {
                final file = jsonEncode(_controller.document);
                print(file.toString());
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titlecontroller,
                maxLines: 2,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.violet)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.orange)),
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              // Text(
              //   "Add Content",
              //   style: TextStyle(fontSize: 18),
              // ),
              // SizedBox(
              //   height: 8,
              // ),
              Container(
                decoration: BoxDecoration(border: Border.all(width: 1)),
                child: QuillToolbar.basic(
                  controller: _controller,
                  showClearFormat: true,
                  showHeaderStyle: false,
                  showStrikeThrough: false,
                  showIndent: false,
                  showCodeBlock: false,
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: QuillEditor.basic(
                    controller: _controller,
                    readOnly: false, // true for view only mode
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: OutlinedButton(
                  child: Text("Submit"),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white, primary: AppColors.violet),
                ),
              )
            ],
          ),
        ));
  }
}
