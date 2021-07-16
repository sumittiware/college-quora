import 'package:flutter/material.dart';
// import 'package:flutter_quill/models/documents/nodes/container.dart' as quill;
import 'package:provider/provider.dart';
import 'package:quora/Models/bookmark.dart';
import 'package:quora/Services/authservices.dart';
import 'package:quora/Views/Common/showmessage.dart';
import 'package:quora/Views/Home/questiondetail.dart';
import 'package:quora/styles/colors.dart';

class BookMarksScreen extends StatefulWidget {
  @override
  _BookMarksScreenState createState() => _BookMarksScreenState();
}

class _BookMarksScreenState extends State<BookMarksScreen> {
  Auth authdata;
  List<BookMark> _booksmarks = [];
  bool _isLoading = true;
  @override
  void initState() {
    authdata = Provider.of<Auth>(context, listen: false);
    print("Bookmarkinitstate");
    getBooksMarks(authdata).then((value) {
      print("Value : " + value.toString());
      _booksmarks = value;
      _isLoading = false;
      setState(() {});
    }).catchError((err) {
      print(err.toString());
    });
    super.initState();
  }

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
        title: Text("Bookmarks (${_booksmarks.length})"),
        backgroundColor: AppColors.orange,
      ),
      body: (_isLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (_booksmarks.length == 0)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bookmark_remove_outlined,
                        size: 70,
                        color: AppColors.violet,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("No booksmarks added!!")
                    ],
                  ),
                )
              : ListView(
                  children: List.generate(
                      _booksmarks.length,
                      (index) => InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return QuestionDetailScreen(
                                  fromFeeds: false,
                                  questionID: _booksmarks[index].questionId,
                                );
                              }));
                            },
                            child: Container(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              _booksmarks[index].user.imageURl),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          _booksmarks[index].user.name,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  deleteBookMark(
                                                          authdata,
                                                          _booksmarks[index]
                                                              .questionId,
                                                          _booksmarks[index]
                                                              .totalAnswers)
                                                      .then((value) {
                                                    showCustomSnackBar(
                                                        context, value);
                                                    _booksmarks.remove(
                                                        _booksmarks[index]);
                                                    setState(() {});
                                                  }).catchError((e) {
                                                    print(e);
                                                  });
                                                },
                                                icon: Icon(Icons.delete,
                                                    color: AppColors.violet))
                                          ],
                                        )
                                      ],
                                    ),
                                    Text(_booksmarks[index].title)
                                  ],
                                )),
                          )),
                ),
    );
  }
}
