import 'package:flutter/foundation.dart';

class AppProviders with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex {
    return _currentIndex;
  }

  setPageIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
