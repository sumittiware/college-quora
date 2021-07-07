import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:quora/Configurations/apiConfig.dart';
import 'package:quora/Services/authservices.dart';

class Filter with ChangeNotifier {
  List<dynamic> _filters = [];
  List<String> _selectedFilter = [];
  List<dynamic> _selectedaTags = [];
  List<String> _createdTags = [];

  List<String> get filters {
    return [..._filters];
  }

  List<String> get currentFilters {
    return [..._selectedFilter];
  }

  List<String> get tags {
    return [..._selectedaTags];
  }

  List<String> get createdTags {
    return [..._createdTags];
  }

  Future<void> fetchTags(Auth authdata) async {
    try {
      final url = API().getUrl(endpoint: 'tag/getAlltags');
      final response = await http
          .get(url, headers: {'Authorization': 'Bearer ${authdata.token}'});
      final result = json.decode(response.body);

      if (result['error'] == null) {
        _filters = result['tags'];
        notifyListeners();
      } else {
        throw result['message'];
      }
    } catch (e) {
      print(e.toString());
    }
  }

  tooglefilter(String item) {
    if (_selectedFilter.contains(item)) {
      _selectedFilter.remove(item);
    } else {
      _selectedFilter.add(item);
    }
    notifyListeners();
  }

  setTags(List<dynamic> tags) {
    _selectedaTags.clear();
    _selectedaTags = tags;
    print(_selectedaTags);
    notifyListeners();
  }

  clearTags() {
    _selectedaTags.clear();
    notifyListeners();
  }

  createTag(String newtags) {
    _createdTags = newtags.split(",");
    _createdTags.forEach((element) {
      final tag = element.trim();
      if (tag != "") {
        if (!_filters.contains(tag)) _filters.add(tag);
      }
    });
    notifyListeners();
  }
}
