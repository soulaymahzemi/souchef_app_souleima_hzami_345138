import 'package:flutter/material.dart';

class IntroVideoViewModel extends ChangeNotifier {

  String _backgroundImage = 'assets/images/background.jpg';
  
  String get backgroundImage => _backgroundImage;


  void changeBackgroundImage(String newImagePath) {
    _backgroundImage = newImagePath;
    notifyListeners();
  }
}
