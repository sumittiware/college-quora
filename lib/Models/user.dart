class User {
  String id;
  String username;
  String college;
  String branch;
  String year;
  String email;
  String imageURl;
  String contact;
  bool emailverified;
  bool numberverified;
  String createdDate;

  User(
      {this.id,
      this.username,
      this.college,
      this.branch,
      this.year,
      this.email,
      this.imageURl,
      this.contact,
      this.emailverified,
      this.numberverified,
      this.createdDate});
}

User userfromQNAJSON(Map<String, dynamic> json) {
  print("Inside user json");
  print(json.toString());
  final user = User(
    id: json['_id'] ?? "",
    username: json['username'] ?? "",
    imageURl: json['profileImage']['path'] ?? null,
  );
  return user;
}
