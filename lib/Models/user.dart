import 'dart:convert';

import 'package:quora/Configurations/apiConfig.dart';
import 'package:http/http.dart' as http;
import 'package:quora/Services/authservices.dart';

class User {
  String id;
  String name;
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
  List<dynamic> followers;
  List<dynamic> following;

  User(
      {this.id,
      this.name,
      this.username,
      this.college,
      this.branch,
      this.year,
      this.email,
      this.imageURl,
      this.contact,
      this.emailverified,
      this.numberverified,
      this.createdDate,
      this.followers,
      this.following});

  bool isFollowing(String userID) {
    // TODO
  }
}

User userfromQNAJSON(Map<String, dynamic> json) {
  // print("Inside user json");
  // print(json.toString());
  final user = User(
    id: json['_id'] ?? "",
    name: json['name'] ?? "",
    imageURl: json['profileImage']['path'] ?? null,
  );
  return user;
}

Future<String> followUser(String userId, Auth authdata) async {
  final url = API().getUrl(endpoint: "user/connectUser/$userId");
  try {
    final response = await http.put(url,
        body: json.encode({"Id": authdata.userID}),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer ${authdata.token}'
        });
    final result = json.decode(response.body);
    if (result['error'] == null) {
      return result['message'];
    } else {
      throw result['error'];
    }
  } catch (e) {
    throw e.toString();
  }
}
