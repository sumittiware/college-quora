class Comment {
  dynamic likes;
  String id;
  String text;

  Comment({this.id, this.likes, this.text});
}

commentFromJson(Map<String, dynamic> commentMap) {
  Comment comment = Comment(
      id: commentMap["_id"],
      text: commentMap["comment"]["text"],
      likes: commentMap["comment"]["likes"]);
  return comment;
}
