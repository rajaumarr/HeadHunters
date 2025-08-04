import 'package:flutter/foundation.dart';

class LoadingProvider extends ChangeNotifier{
  bool _isLoading=false;
  bool get isLoading=>_isLoading;

  void setLoading(bool status){
    _isLoading=status;
    notifyListeners();
  }

}