import 'package:flutter_quill/flutter_quill.dart';
import 'package:quora/Models/answer.dart';
import 'package:quora/Models/comment.dart';
import 'package:quora/Models/user.dart';

// TODO : adding user remaining!!!
class Question {
  String id;
  String title;
  String createdAt;
  Delta body;
  List<dynamic> tags;
  List<dynamic> upVote;
  List<dynamic> downVote;
  List<Answer> answers;
  List<Comment> comments;
  User creator;
  List<dynamic> views;
  Question(
      {this.id,
      this.title,
      this.body,
      this.tags,
      this.upVote,
      this.downVote,
      this.creator,
      this.answers,
      this.views,
      this.createdAt,
      this.comments});
}
