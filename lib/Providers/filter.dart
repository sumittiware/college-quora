import 'package:flutter/cupertino.dart';

class Filter with ChangeNotifier {
  List<String> _filters = [];
  List<String> _selectedFilter = [];

  List<String> get filters {
    return [..._filters];
  }

  List<String> get currentFilters {
    return [..._selectedFilter];
  }

  Future<void> filterValues() {}

  tooglefilter(String item) {
    if (_selectedFilter.contains(item)) {
      _selectedFilter.remove(item);
    } else {
      _selectedFilter.add(item);
    }
    notifyListeners();
  }
}
