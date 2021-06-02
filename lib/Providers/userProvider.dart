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
      final result = json.decode(response.body);
      if (result['error'] == null) {
        final imageUrl = result['user']['profileImage']['path'];
        final user = User(
            college: result['user']['college'],
            branch: result['user']['branch'],
            year: result['user']['year'],
            contact: result['user']['contact'],
            username: result['user']['username'],
            email: result['user']['email'],
            emailverified: result['user']['emailVerify'],
            numberverified: result['user']['numberVerify'],
            createdDate: result['user']['createdAt'],
            imageURl: imageUrl);
        _appuser = user;
        notifyListeners();
        return user;
      } else {
        throw result['error'];
      }
    } catch (e) {
      print("Error : " + e.toString());
      throw e.toString();
    }
  }

  Future<String> updateUser(Auth authdata, File userimage, String username,
      String selectedBranch, String selectedYear, String collegename) async {
    try {
      final url =
          API().getUrl(endpoint: "user/updateProfile/${authdata.userID}");
      String filename = userimage.path ?? null;
      final mimeTypeData =
          lookupMimeType(filename, headerBytes: [0xFF, 0xD8]).split('/');

      final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('image', filename,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
      request.fields['username'] = username;
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
