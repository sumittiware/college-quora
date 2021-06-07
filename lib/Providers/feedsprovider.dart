import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:http/http.dart' as http;
import 'package:quora/Configurations/apiConfig.dart';
import 'package:quora/Models/question.dart';
import 'package:quora/Services/authservices.dart';

class MyFeeds with ChangeNotifier {
  List<Question> _feeds = [];

  List<Question> get feeds {
    return [..._feeds];
  }

  Future<Question> fetchFeeds(Auth authdata) async {
    try {
      final url =
          API().getUrl(endpoint: 'user/getQuestion/60b9e8e1557cc135305b6e6f');
      final response = await http
          .get(url, headers: {'Authorization': 'Bearer ${authdata.token}'});
      final result = json.decode(response.body);
      print(result);
      Question question;
      if (result['error'] == null) {
        try {
          var body = Delta();
          result['question']['body'].forEach((element) {
            body.insert(element['insert'], element['attributes']);
          });
          question = Question(title: result['question']['title'], body: body);
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
