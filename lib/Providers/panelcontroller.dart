import 'package:flutter/cupertino.dart';

import 'package:flutter/foundation.dart';

class PanelController with ChangeNotifier {
  int _currentIndex = 0;

  int get index {
    return _currentIndex;
  }

  setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
