import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:http/http.dart' as http;
import 'package:quora/Configurations/apiConfig.dart';
import 'package:quora/Configurations/string.dart';
import 'package:quora/Models/answer.dart';
import 'package:quora/Models/comment.dart';
import 'package:quora/Models/question.dart';
import 'package:quora/Models/user.dart';
import 'package:quora/Services/authservices.dart';

class MyFeeds with ChangeNotifier {
  List<Question> _feeds = [];

  List<Question> get feeds {
    return [..._feeds];
  }

  Future<Question> fetchFeeds(Auth authdata) async {
    try {
      final url = API()
          .getUrl(endpoint: 'question/getQuestion/${authdata.userID}/$queId');
      final response = await http
          .get(url, headers: {'Authorization': 'Bearer ${authdata.token}'});
      final result = json.decode(response.body);
      print(result.toString());
      Question question;
      if (result['error'] == null) {
        try {
          var body = Delta();
          result['question']['body'].forEach((element) {
            body.insert(element['insert'], element['attributes']);
          });
          question = Question(
              id: result['question']['_id'],
              title: result['question']['title'],
              body: body,
              tags: result['question']['tags'],
              upVote: result['question']['upVote'],
              answers: List.generate(
                  result['question']['answers'].length,
                  (index) =>
                      answerfromJSON(result['question']['answers'][index])),
              creator: userfromQNAJSON(result['question']['user']),
              comments: [],
              //  List.generate(
              //         result['question']['comments'].length,
              //         (index) => commentFromJson(
              //             result['question']['comments'][index])) ??
              //     [],
              views: result['question']['Views'],
              downVote: result['question']['downVote'],
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
}
