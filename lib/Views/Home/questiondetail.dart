import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quora/Configurations/apiConfig.dart';
import 'package:quora/Configurations/string.dart';
import 'package:quora/Models/bookmark.dart';
import 'package:quora/Models/question.dart';
import 'package:quora/Providers/feedsprovider.dart';
import 'package:quora/Services/authservices.dart';
import 'package:quora/Views/Common/commentcontroller.dart';
import 'package:quora/Views/Common/error.dart';
import 'package:quora/Views/Common/heading.dart';
import 'package:quora/Views/Common/showmessage.dart';
import 'package:quora/Views/EditorScreen/editans.dart';
import 'package:quora/Views/EditorScreen/giveanswer.dart';
import 'package:quora/Views/Home/widgets/answerWidget.dart';
import 'package:quora/styles/colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:sliding_up_panel/sliding_up_panel.dart';

class QuestionDetailScreen extends StatefulWidget {
  final bool fromFeeds;
  final questionID;
  QuestionDetailScreen({this.fromFeeds = true, this.questionID = ""});
  @override
  _QuestionDetailScreenState createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  bool _isLiked = false;
  bool _isDisliked = false;

  final _panel = PanelController();
  final _commentController = TextEditingController();

  quill.QuillController _controller;
  final scrollController = ScrollController();
  final editorFocus = FocusNode();
  Auth authdata;
  MyFeeds feeds;
  bool isLoading = true;
  bool hasError = false;
  List<dynamic> tags = [];
  String error;
  Question _question;
  var format = DateFormat.yMMMd(Intl.defaultLocale);
  getData() async {
    final fetchingMethod = (widget.fromFeeds)
        ? Provider.of<MyFeeds>(context, listen: false).fetchFeeds(authdata)
        : fetchBookMark(authdata, widget.questionID);
    fetchingMethod.then((result) {
      print("RESULT " + result.toString());
      setState(() {
        isLoading = false;
        hasError = false;
        _question = result;
        _controller = quill.QuillController(
            selection: TextSelection.collapsed(offset: 1),
            document: Document.fromDelta(result.body));
        tags = result.tags;
      });
    }).catchError((e) {
      print("ERROR : " + e.toString());
      error = e.toString();
      setState(() {
        isLoading = false;
        hasError = true;
        print("haserror" + hasError.toString());
      });
    });
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    authdata = Provider.of<Auth>(context, listen: false);
    getData();
    super.initState();
  }

  toogleUpvote() {
    final url = API().getUrl(
        endpoint: "question/updateQuestionVote/${_question.id}?type=up");
    http.put(url,
        body: json.encode({
          "userId": authdata.userID,
          "upVote": _isLiked,
          "downVote": _isDisliked
        }),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer ${authdata.token}'
        }).then((response) {
      final result = json.decode(response.body);
      if (result['error'] == null) {
        if (_isDisliked) {
          _isDisliked = false;
        }
        _isLiked = !_isLiked;
        _question.upVote.contains(_question.id)
            ? _question.upVote.remove(_question.id)
            : _question.upVote.remove(_question.id);
      }
      showCustomSnackBar(context, result['message']);
    }).catchError((error) {
      showCustomSnackBar(context, error.toString());
    });
    setState(() {});
  }

  toogleDownvote() {
    final url = API().getUrl(
        endpoint: "question/updateQuestionVote/${_question.id}?type=down");
    http.put(url,
        body: json.encode({
          "userId": authdata.userID,
          "upVote": _isLiked,
          "downVote": _isDisliked
        }),
        headers: {
          "Content-type": "Application/json",
          'Authorization': 'Bearer ${authdata.token}'
        }).then((response) {
      final result = json.decode(response.body);
      if (result['error'] == null) {
        if (_isLiked) {
          _isLiked = false;
        }
        _isDisliked = !_isDisliked;
        _question.upVote.contains(_question.id)
            ? _question.upVote.remove(_question.id)
            : _question.upVote.remove(_question.id);
      }
      showCustomSnackBar(context, result['message']);
    }).catchError((error) {
      showCustomSnackBar(context, error.toString());
    });
    setState(() {});
  }

  _deleteQuestion() async {
    final url = API().getUrl(
        endpoint:
            'question/deleteQuestion/${authdata.userID}/$queId?mode="delete"');
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Question Detail"),
        backgroundColor: AppColors.orange,
      ),
      body: (isLoading)
          ? Center(child: CircularProgressIndicator())
          : (hasError)
              ? AppError(
                  error: error,
                )
              : SlidingUpPanel(
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(_question.creator.imageURl),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          _question.creator.name,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        if (_question.creator.id !=
                                            authdata.userID)
                                          TextButton(
                                              onPressed: () {},
                                              child: Text("Follow"))
                                      ],
                                    ),
                                    Text(format.format(
                                        DateTime.parse(_question.createdAt)))
                                  ],
                                ),
                                Spacer(),
                                if (authdata.userID == _question.creator.id)
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return EditQuestionPage(
                                                delta: _question.body,
                                                tags: _question.tags,
                                                title: _question.title,
                                              );
                                            }));
                                          },
                                          icon: Icon(Icons.edit,
                                              color: AppColors.violet)),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.delete,
                                              color: AppColors.violet))
                                    ],
                                  )
                              ],
                            ),
                            Text(
                              _question.title,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            quill.QuillEditor(
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
                            Wrap(
                              children: List.generate(
                                _question.tags.length,
                                (index) => Container(
                                  margin: EdgeInsets.all(6),
                                  child: Text(_question.tags[index],
                                      style: TextStyle(color: Colors.white)),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: AppColors.violet),
                                      color: AppColors.violet,
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ),
                            ),
                            Heading(
                                text: "Answer (${_question.answers.length})"),
                            Column(
                              children: List.generate(
                                  _question.answers.length,
                                  (index) => Column(
                                        children: [
                                          AnswerWidget(
                                              questionID: _question.id,
                                              question: _question.title,
                                              answer: _question.answers[index],
                                              fromFeeds: widget.fromFeeds),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12),
                                            color: Colors.grey,
                                            height: 2,
                                            width: _deviceSize.width,
                                          )
                                        ],
                                      )),
                            ),
                            SizedBox(
                              height: 200,
                            )
                          ]),
                    ),
                  ),
                  controller: _panel,
                  minHeight: 70,
                  maxHeight: _deviceSize.height * 0.5,
                  panel: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: (isLoading)
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildButton(
                                        (_isLiked)
                                            ? Icons.thumb_up
                                            : Icons.thumb_up_outlined,
                                        _question.upVote.length.toString(),
                                        toogleUpvote),
                                    _buildButton(
                                        (_isDisliked)
                                            ? Icons.thumb_down
                                            : Icons.thumb_down_outlined,
                                        _question.downVote.length.toString(),
                                        toogleDownvote),
                                    _buildButton(
                                        Icons.add_comment_rounded, "Comment",
                                        () {
                                      setState(() {
                                        _panel.open();
                                      });
                                    }),
                                    _buildButton(Icons.edit, "Answer", () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return WriteAnswer(
                                          questionId: _question.id,
                                          title: _question.title,
                                        );
                                      }));
                                    }),
                                  ]),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Comments",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: TextField(
                                    controller: _commentController,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    autocorrect: true,
                                    enableSuggestions: true,
                                    decoration: InputDecoration(
                                        hintText: 'Add Comment',
                                        hintStyle: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(30))),
                                  )),
                                  FloatingActionButton(
                                      elevation: 0,
                                      child: Icon(Icons.send),
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      onPressed: () {
                                        final url = API().getUrl(
                                            endpoint:
                                                "question/addComment/${_question.id}");
                                        print("URL : " + url.toString());
                                        http.post(url,
                                            body: json.encode(
                                              {
                                                "text": _commentController.text,
                                                "user": authdata.userID
                                              },
                                            ),
                                            headers: {
                                              "Content-type":
                                                  "application/json",
                                              'Authorization':
                                                  'Bearer ${authdata.token}'
                                            }).then((result) {
                                          showCustomSnackBar(
                                              context, result.body);
                                        }).catchError((err) {
                                          showCustomSnackBar(context, err);
                                        });
                                      })
                                ],
                              ),
                              SingleChildScrollView(
                                child: Column(
                                  children: List.generate(
                                      _question.comments.length, (index) {
                                    return Text(_question.comments[index].text);
                                  }),
                                ),
                              )
                            ],
                          ),
                  ),
                ),
    );
  }

  Widget _buildButton(IconData icon, String title, Function onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [IconButton(onPressed: onTap, icon: Icon(icon)), Text(title)],
      ),
    );
  }
}
