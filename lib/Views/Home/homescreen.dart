import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/models/documents/document.dart';
import 'package:provider/provider.dart';
import 'package:quora/Providers/feedsprovider.dart';
import 'package:quora/Services/authservices.dart';
import 'package:quora/Views/Common/error.dart';
import 'package:quora/Views/EditorScreen/texteditor.dart';
import 'package:quora/styles/colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  quill.QuillController _controller;
  String title;
  Auth authdata;
  MyFeeds feeds;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    authdata = Provider.of<Auth>(context, listen: false);
    Provider.of<MyFeeds>(context, listen: false)
        .fetchFeeds(authdata)
        .then((result) {
      setState(() {
        isLoading = false;
        hasError = false;
        title = result.title;
        _controller = quill.QuillController(
            selection: TextSelection.collapsed(offset: 1),
            document: Document.fromDelta(result.body));
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: (isLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (hasError)
              ? Center(child: AppError())
              : SingleChildScrollView(
                  child: Column(children: [
                    Text(title ?? "text"),
                    quill.QuillEditor.basic(
                      autoFocus: false,
                      controller: _controller,
                      readOnly: true, // true for view only mode
                    ),
                  ]),
                ),
    );
  }
}
