import 'package:flutter_quill/flutter_quill.dart';
import 'package:quora/Models/user.dart';

class Answer {
  String id;
  Delta body;
  String createdAt;
  List<dynamic> upVotes;
  List<dynamic> downVotes;
  User creator;
  bool isVerified;

  Answer(
      {this.id,
      this.body,
      this.upVotes,
      this.creator,
      this.downVotes,
      this.isVerified,
      this.createdAt});
}

Answer answerfromJSON(Map<String, dynamic> json) {
  var body = Delta();
  json['body'].forEach((element) {
    body.insert(element['insert'], element['attributes']);
  });
  final answer = Answer(
      id: json['_id'],
      body: body,
      createdAt: json['createdAt'],
      upVotes: json['upVote'],
      downVotes: json['downVote'],
      creator: userfromQNAJSON(json['user']),
      isVerified: json['verified']);
  return answer;
}
