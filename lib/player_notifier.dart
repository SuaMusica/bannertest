import 'package:flutter/widgets.dart';

class PlayerNotifier with ChangeNotifier {
  bool hasAds = false;

  void notifyHasAds(bool hasAd) {
    hasAds = hasAd;
    notifyListeners();
  }
}
