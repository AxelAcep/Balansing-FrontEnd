import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FilterModel extends ChangeNotifier {
  bool _filter = false;
  int _month = DateTime.now().month;
  int _year = DateTime.now().year;
  int _count = 1;

  bool get filter => _filter;
  int get month => _month;
  int get year => _year;
  int get count => _count;

  void setFilter(bool newFilter) {
    _filter = newFilter;
    notifyListeners();
  }

  void setMonth(int newMonth) {
    _month = newMonth;
    notifyListeners();
  }

  void setYear(int newYear) {
    _year = newYear;
    notifyListeners();
  }

  void setCount(int newCount) {
    _count = newCount;
    notifyListeners();
  }
}