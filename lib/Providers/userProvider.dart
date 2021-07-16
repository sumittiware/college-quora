import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import 'package:quora/Configurations/apiConfig.dart';
import 'package:quora/Models/user.dart';
import 'package:quora/Services/authservices.dart';

class UserProvider with ChangeNotifier {
  User _appuser;

  User get appuser {
    return _appuser;
  }

  Future<User> getUser(Auth authdata) async {
    try {
      final url = API().getUrl(endpoint: 'user/getUser/${authdata.userID}');
      final response = await http
          .get(url, headers: {'Authorization': 'Bearer ${authdata.token}'});
      final result = json.decode(response.body) as Map<String, dynamic>;
      final appuser = result['user'];
      // print(appuser.toString());
      if (result['error'] == null) {
        final imageUrl = appuser['profileImage']['path'] ?? null;
        final user = User(
            college: appuser['college'],
            branch: appuser['branch'],
            year: appuser['year'],
            contact: appuser['contact'],
            name: appuser['name'],
            email: appuser['email'],
            emailverified: appuser['emailVerify'],
            numberverified: appuser['numberVerify'],
            createdDate: appuser['createdAt'],
            imageURl: imageUrl,
            followers: appuser['followers'],
            following: appuser['followings']);
        _appuser = user;
        notifyListeners();
        return user;
      } else {
        throw result['error'];
      }
    } catch (e) {
      // print("Error : " + e.toString());
      throw e.toString();
    }
  }

  Future<String> updateUser(Auth authdata, File userimage, String name,
      String selectedBranch, String selectedYear, String collegename) async {
    try {
      final url =
          API().getUrl(endpoint: "user/updateProfile/${authdata.userID}");
      String filename = userimage.path ?? null;
      final mimeTypeData =
          lookupMimeType(filename, headerBytes: [0xFF, 0xD8]).split('/');

      final request = http.MultipartRequest('PUT', url);
      request.files.add(await http.MultipartFile.fromPath('image', filename,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
      request.fields['name'] = name;
      request.fields['branch'] = selectedBranch;
      request.fields['year'] = selectedYear;
      request.fields['college'] = collegename;
      request.headers.addAll({
        "Content-type": "multipart/form-data",
        'Authorization': 'Bearer ${authdata.token}'
      });
      final res = await request.send();
      var response = await http.Response.fromStream(res);
      final resp = json.decode(response.body);
      if (resp['error'] == null) {
        return resp['message'];
      } else {
        throw resp['message'];
      }
    } catch (e) {
      print("Error : " + e.toString());
      throw e.toString();
    }
  }
}
