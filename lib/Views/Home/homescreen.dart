import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/models/documents/document.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:quora/Configurations/apiConfig.dart';
import 'package:quora/Configurations/string.dart';
import 'package:quora/Providers/feedsprovider.dart';
import 'package:quora/Services/authservices.dart';
import 'package:quora/Views/Common/error.dart';
import 'package:quora/Views/Common/showmessage.dart';
import 'package:quora/Views/EditorScreen/editans.dart';
import 'package:quora/Views/EditorScreen/giveanswer.dart';
import 'package:quora/Views/EditorScreen/texteditor.dart';
import 'package:quora/Views/EditorScreen/updateanswer.dart';
import 'package:quora/extras/contextkeeper.dart';
import 'package:quora/styles/colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  quill.QuillController _controller;
  final scrollController = ScrollController();
  final editorFocus = FocusNode();
  String title;
  Auth authdata;
  MyFeeds feeds;
  bool isLoading = true;
  bool hasError = false;
  List<dynamic> tags = [];
  String error;

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
        tags = result.tags;
      });
    }).catchError((e) {
      error = e.toString();
      setState(() {
        isLoading = false;
        hasError = true;
      });
    });
    super.initState();
  }

  _deleteQuestion() async {
    final url = API().getUrl(
        endpoint:
            'user/deleteQuestion/${authdata.userID}/$queId?mode="delete"');
    final response = await http.delete(url, headers: {
      "Content-type": "Application/json",
      'Authorization': 'Bearer ${authdata.token}'
    });
    final result = json.decode(response.body);
    showCustomSnackBar(context, result['message']);
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
              ? Center(
                  child: AppError(
                  error: error,
                ))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(children: [
                      Row(
                        children: [
                          Expanded(child: Text(title ?? "text")),
                          IconButton(
                              onPressed: _deleteQuestion,
                              icon: Icon(
                                Icons.delete,
                                color: AppColors.violet,
                              ))
                        ],
                      ),
                      quill.QuillEditor(
                        embedBuilder: _customEmbedBuilder,
                        focusNode: editorFocus,
                        expands: false,
                        padding: EdgeInsets.all(8),
                        scrollController: scrollController,
                        scrollable: true,
                        autoFocus: true,
                        showCursor: false,
                        controller: _controller,
                        readOnly: true, // true for view only mode
                      ),
                    ]),
                  ),
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
              child: Icon(Icons.edit),
              onPressed: () {
                // Navigator.pushNamed(context, EditQuestionPage.routename);
                Navigator.of(ContextKeeper.buildContext)
                    .push(new MaterialPageRoute(
                        builder: (ctx) => new UpdateAnswer(
                              title: title,
                              questionId: "",
                            )));
              }),
          FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                // Navigator.pushNamed(context, EditQuestionPage.routename);
                Navigator.of(ContextKeeper.buildContext)
                    .push(new MaterialPageRoute(
                        builder: (ctx) => new WriteAnswer(
                              title: title,
                              questionId: "",
                            )));
              }),
          FloatingActionButton(
              child: Icon(Icons.edit),
              onPressed: () {
                // Navigator.pushNamed(context, EditQuestionPage.routename);
                Navigator.of(ContextKeeper.buildContext)
                    .push(new MaterialPageRoute(
                        builder: (ctx) => new EditQuestionPage(
                              title: title,
                              delta: _controller.document.toDelta(),
                              tags: tags,
                            )));
              }),
        ],
      ),
    );
  }
}

Widget _customEmbedBuilder(BuildContext context, quill.Embed embed) {
  switch (embed.value.type) {
    case quill.BlockEmbed.imageType:
      return _buildImage(context, embed);
    case quill.BlockEmbed.horizontalRuleType:
      return const Divider();
    default:
      throw UnimplementedError('Embed "${embed.value.type}" is not supported.');
  }
}

Widget _buildImage(BuildContext context, quill.Embed embed) {
  final imageUrl = embed.value.data;
  return SizedBox(
    // height: 400,
    width: double.infinity,
    child: imageUrl.startsWith('http')
        ? Image.network(
            imageUrl,
            fit: BoxFit.fitWidth,
          )
        : isBase64(imageUrl)
            ? Image.memory(base64.decode(imageUrl))
            : Image.file(File(imageUrl)),
  );
}
