import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/models/documents/document.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quora/Configurations/apiConfig.dart';
import 'package:quora/Models/answer.dart';
import 'package:quora/Models/bookmark.dart';
import 'package:quora/Models/user.dart';
import 'package:quora/Services/authservices.dart';
import 'package:quora/Views/Common/showmessage.dart';
import 'package:quora/Views/EditorScreen/updateanswer.dart';
import 'package:quora/styles/colors.dart';
import 'package:http/http.dart' as http;

class AnswerWidget extends StatefulWidget {
  final String questionID;
  final String question;
  final Answer answer;
  final bool fromFeeds;
  AnswerWidget({this.questionID, this.question, this.answer, this.fromFeeds});
  @override
  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  bool _isLiked = false;
  bool _isDisliked = false;

  Auth authdata;
  quill.QuillController _controller;
  final scrollController = ScrollController();
  final editorFocus = FocusNode();
  var format = DateFormat.yMMMd(Intl.defaultLocale);

  @override
  void initState() {
    authdata = Provider.of<Auth>(context, listen: false);
    _controller = quill.QuillController(
        selection: TextSelection.collapsed(offset: 1),
        document: Document.fromDelta(widget.answer.body));
    super.initState();
  }

  _addBookmark() async {
    try {
      final url = API().getUrl(endpoint: "user/addBookmark/${authdata.userID}");
      final response = await http.post(url,
          body: json.encode(
              {"questionId": widget.questionID, "answerId": widget.answer.id}),
          headers: {
            "Content-type": "Application/json",
            'Authorization': 'Bearer ${authdata.token}'
          });
      final result = json.decode(response.body);
      if (result['error'] == null) {
        showCustomSnackBar(context, result["message"]);
      } else {
        showCustomSnackBar(context, result["message"]);
      }
    } catch (e) {
      print(e.toString());
    }
    print("add bookmark!!!");
  }

  toogleUpvote() {
    if (_isDisliked) {
      _isDisliked = false;
    }
    _isLiked = !_isLiked;
    setState(() {});
  }

  toogleDownvote() {
    if (_isLiked) {
      _isLiked = false;
    }
    _isDisliked = !_isDisliked;
    setState(() {});
  }

  _deleteAnswer() async {
    if (widget.answer.isVerified) {
      showCustomSnackBar(context, "Answer already verified!!");
      return;
    }
    final url = API().getUrl(
        endpoint:
            'answer/deleteAnswer/${authdata.userID}/${widget.questionID}/${widget.answer.id}?mode="delete"');
    final response = await http.delete(url, headers: {
      "Content-type": "application/json",
      'Authorization': 'Bearer ${authdata.token}'
    });
    final result = json.decode(response.body);
    Navigator.of(context).pop();
    showCustomSnackBar(context, result['message']);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.answer.creator.imageURl),
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
                        widget.answer.creator.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      if (widget.answer.creator.id != authdata.userID)
                        TextButton(
                            onPressed: () {
                              followUser(widget.answer.creator.id, authdata)
                                  .then((value) {
                                showCustomSnackBar(context, value);
                              }).catchError((error) {
                                showCustomSnackBar(context, error);
                              });
                            },
                            child: Text("Follow"))
                    ],
                  ),
                  Text(format.format(DateTime.parse(widget.answer.createdAt)))
                ],
              ),
              Spacer(),
              if (authdata.userID == widget.answer.creator.id)
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return UpdateAnswer(
                              answerId: widget.answer.id,
                              questionId: widget.questionID,
                              quilldata: widget.answer.body,
                              title: widget.question,
                            );
                          }));
                        },
                        icon: Icon(Icons.edit, color: AppColors.violet)),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.delete, color: AppColors.violet))
                  ],
                )
            ],
          ),
          quill.QuillEditor(
            focusNode: editorFocus,
            expands: false,
            padding: EdgeInsets.all(0),
            scrollController: scrollController,
            scrollable: true,
            autoFocus: true,
            showCursor: false,
            controller: _controller,
            readOnly: true, // true for view only mode
          ),
          Row(children: [
            if (widget.answer.isVerified)
              Column(children: [
                Icon(
                  Icons.verified_rounded,
                  size: 30,
                  color: Colors.green,
                ),
                Text(
                  "Verified",
                  style: TextStyle(color: Colors.green),
                )
              ]),
            Spacer(),
            _buildButton((_isLiked) ? Icons.thumb_up : Icons.thumb_up_outlined,
                widget.answer.upVotes.length.toString(), toogleUpvote),
            _buildButton(
                (_isDisliked) ? Icons.thumb_down : Icons.thumb_down_outlined,
                widget.answer.downVotes.length.toString(),
                toogleDownvote),
            _buildButton(Icons.add_comment_rounded, "Comment", () {}),
            (widget.fromFeeds)
                ? _buildButton(
                    Icons.bookmark_add_rounded, "Bookmark", _addBookmark)
                : _buildButton(Icons.bookmark_remove_rounded, "Remove Bookmark",
                    () {
                    deleteBookMark(
                            authdata, widget.questionID, [widget.answer.id])
                        .then((value) {
                      showCustomSnackBar(context, value);
                    }).catchError((error) {
                      showCustomSnackBar(context, error);
                    });
                  }),
          ])
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, String title, Function onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [IconButton(onPressed: onTap, icon: Icon(icon)), Text(title)],
      ),
    );
  }
}
