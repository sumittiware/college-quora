import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:quora/Configurations/apiConfig.dart';
import 'package:quora/Models/question.dart';
import 'package:quora/Models/user.dart';
import 'package:http/http.dart' as http;
import 'package:quora/Services/authservices.dart';

import 'answer.dart';

class BookMark {
  User user;
  String questionId;
  String title;
  List<dynamic> totalAnswers;

  BookMark({this.user, this.questionId, this.title, this.totalAnswers});
}

getBooksMarks(Auth authdata) async {
  List<BookMark> bookmarks = [];
  final url = API().getUrl(endpoint: "user/getBookmarks/${authdata.userID}");
  final response = await http
      .get(url, headers: {'Authorization': 'Bearer ${authdata.token}'});
  final result = json.decode(response.body);

  if (result['error'] == null) {
    final bookMark = result['bookmarks'] as List<dynamic>;
    bookMark.forEach((element) {
      final bookmark = BookMark(
          questionId: element['question']['_id'],
          title: element['question']['title'],
          totalAnswers: element['answers'],
          user: userfromQNAJSON(element['question']['user']));
      bookmarks.add(bookmark);
    });
    return bookmarks;
  } else {
    throw result['message'];
  }
}

Future<String> deleteBookMark(
    Auth authdata, String questionId, List<dynamic> answerId) async {
  try {
    final url =
        API().getUrl(endpoint: "user/deleteBookmark/${authdata.userID}");
    final response = await http.delete(url,
        body: json.encode({"questionId": questionId, "answerIds": answerId}),
        headers: {
          "Content-type": "Application/json",
          'Authorization': 'Bearer ${authdata.token}'
        });
    final result = json.decode(response.body);
    if (result['error'] == null) {
      return (result['message']);
    } else {
      throw (result['message']);
    }
  } catch (e) {
    print(e.toString());
  }
}

Future<Question> fetchBookMark(Auth authdata, String questionID) async {
  try {
    Uri url = API().getUrl(
        endpoint:
            'user/getSpecificQuestionBookmark/${authdata.userID}?questionId=$questionID');
    final response = await http
        .get(url, headers: {'Authorization': 'Bearer ${authdata.token}'});
    final result = json.decode(response.body);
    print(result);
    Question question;
    if (result['error'] == null) {
      try {
        var body = Delta();
        // result['selectedBookmark']['body'].forEach((element) {
        //   body.insert(element['insert'], element['attributes']);
        // });
        question = Question(
            id: result['selectedBookmark']['_id'],
            title: result['selectedBookmark']['title'],
            body: body,
            tags: result['selectedBookmark']['tags'],
            upVote: result['selectedBookmark']['upVote'],
            answers: List.generate(
                result['selectedBookmark']['answers'].length,
                (index) => answerfromJSON(
                    result['selectedBookmark']['answers'][index])),
            creator: userfromQNAJSON(result['selectedBookmark']['user']),
            views: result['selectedBookmark']['Views'],
            downVote: result['selectedBookmark']['downVote'],
            createdAt: result['question']['createdAt']);
        return question;
      } catch (e) {
        throw e.toString();
      }
    } else {
      throw result['message'];
    }
  } catch (e) {
    throw e.toString();
  }
}
