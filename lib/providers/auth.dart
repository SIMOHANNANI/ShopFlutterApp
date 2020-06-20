import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception_handler.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
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
  Future<void> _authenticate(String email, String password,
      String urlSegment) async {
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
      _autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final currentUserData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
        prefs.setString('currentUserData', currentUserData);

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

  Future<bool> tryAutoSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    // If the token is not set yet:
    if (!prefs.containsKey('currentUserData')) {
      return false;
    }
    // If the token is already set
    // Getting the data stored locally
    final grapedDataFromDevice = json.decode(
        prefs.getString('currentUserData')) as Map<String, Object>;
    // Get the expiry date :
    final expiryDate = DateTime.parse(grapedDataFromDevice['expiryDate']);
    // CHeck whether if the expiry date is passed on not yet :
    if (expiryDate.isBefore(DateTime.now())) {
      // Token is not valid :
      return false;
    }
    _token = grapedDataFromDevice['token'];
    _userId = grapedDataFromDevice['userId'];
    _expiryDate = expiryDate;
    _autoLogOut();
    notifyListeners();
    return true;
  }

  Future<void> logOut() async{
    _expiryDate = null;
    _userId = null;
    _token = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // purge all the data stored :
    prefs.clear();
    // purge a specific data with :
    prefs.remove('currentUserData');
    print('Logging out ...');
  }

  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final _timeToExpires = _expiryDate
        .difference(DateTime.now())
        .inSeconds;
    _authTimer = Timer(Duration(seconds: _timeToExpires), () => logOut());
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
