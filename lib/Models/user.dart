class User {
  String id;
  String username;
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
      this.branch,
      this.year,
      this.email,
      this.imageURl,
      this.contact,
      this.emailverified,
      this.numberverified,
      this.createdDate});
}
