import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception_handler.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }


  // --------------------------------------------------------------------------------
  Future<void> _authenticate(

      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCzIU3tmBi0cop9WvRTuQ4KbbIGdVK96-Y';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpExceptionHandler(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
//  Future<void> signUp(String email, String password) async {
//    const url =
//        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCzIU3tmBi0cop9WvRTuQ4KbbIGdVK96-Y';
//    try {
//      final response = await http.post(url,
//          body: json.encode({
//            'email': email,
//            'password': password,
//            'returnSecureToken': true,
//          }));
//      final responseData = json.decode(response.body);
//      if (responseData['error'] != null) {
//        throw HttpExceptionHandler(responseData['error']['message']);
//      }
//      _token = responseData['idToken'];
//      _userId = responseData['localId'];
//      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
//      notifyListeners();
//    } catch (e) {
//      throw e;
//    }
//  }
//
//  Future<void> signIn(String email, String password) async {
//    const url =
//        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCzIU3tmBi0cop9WvRTuQ4KbbIGdVK96-Y';
//    try {
//      final response = await http.post(url,
//          body: json.encode({
//            'email': email,
//            'password': password,
//          }));
//      final responseData = json.decode(response.body);
//      if (responseData['error'] != null) {
//        throw HttpExceptionHandler(responseData['error']['message']);
//      }
//      _token = responseData['idToken'];
//      _userId = responseData['localId'];
//      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
//      notifyListeners();
//    } catch (e) {
//      print('error --- ');
//      throw e;
//    }
//  }
//
//
//
//
//
//
}
