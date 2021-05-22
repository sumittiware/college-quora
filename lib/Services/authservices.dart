import 'dart:async';
import 'dart:convert';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:quora/Configurations/apiConfig.dart';
import 'package:quora/Configurations/googleauthconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

FlutterAppAuth appAuth = FlutterAppAuth();

class Auth with ChangeNotifier {
  String _token;
  String _userID;

  bool get isAuth {
    return token != null;
  }

  String get userID {
    return _userID;
  }

  String get token {
    return _token;
  }

  Future<String> signUp({
    String username,
    String email,
    String password,
  }) async {
    final url = API().getUrl(endpoint: "auth/signup");
    try {
      final response = await http.post(url,
          body: json.encode(
              {"username": username, "email": email, "password": password}),
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json"
          });
      print(response.body);
      final authresult = json.decode(response.body);
      if (authresult['error'] == null) {
        _token = authresult['token'];
        _userID = authresult['userId'];
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _token,
          'userID': _userID,
        });
        prefs.setString('userData', userData);
        return authresult['message'];
        // print(authresult);
      } else {
        throw authresult['message'];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<dynamic>> googleSignIn() async {
    try {
      final AuthorizationTokenResponse result =
          await appAuth.authorizeAndExchangeCode(AuthorizationTokenRequest(
              CLIENT_ID, REDIRECT_URI,
              serviceConfiguration: AuthorizationServiceConfiguration(
                  AUTH_ENDPOINT, TOKEN_ENDPOINT),
              scopes: scopes));

      final url = API().getUrl(endpoint: "auth/googleLogin");
      final response = await http.post(url,
          body: json.encode(
              {'id_token': result.idToken, 'access_token': result.accessToken}),
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json"
          });

      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] == null) {
        _token = responseData['token'];
        _userID = responseData['userId'];
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _token,
          'userID': _userID,
        });
        prefs.setString('userData', userData);
        return [
          responseData['message'],
          responseData['profilePath'],
          responseData['profileCompleted']
        ];
      } else {
        throw responseData['error'];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<dynamic>> logIn(String email, String password) async {
    final url = API().getUrl(endpoint: "auth/signin"); //place the url
    try {
      final response = await http.post(url,
          body: json.encode(
            {'email': email, 'password': password},
          ),
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json"
          });
      print(response.body);
      final authresult = json.decode(response.body);
      if (authresult['error'] == null) {
        _token = authresult['token'];
        _userID = authresult['userId'];
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _token,
          'userID': _userID,
        });
        prefs.setString('userData', userData);
        return [authresult['message'], authresult['profileCompleted']];
      } else {
        throw authresult['message'];
      }
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    _token = extractedUserData['token'];
    _userID = extractedUserData['userID'];
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userID = null;
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    //pref.remove('userData'); used to remove the single  data
    pref.clear();
  }
}
