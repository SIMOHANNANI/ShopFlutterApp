import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception_handler.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signUp(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCzIU3tmBi0cop9WvRTuQ4KbbIGdVK96-Y';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
    }catch (e) {
      throw e;
    }
  }

  Future<void> signIn(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCzIU3tmBi0cop9WvRTuQ4KbbIGdVK96-Y';
    try {
      final response = await http.post(url,body:json.encode({
        'email':email,
        'password':password,
      }));
      final responseData = json.decode(response.body);
      if(responseData['error'] != null){
        throw HttpExceptionHandler(responseData['error']['message']);

      }
    }catch (e) {
      throw e;

    }
  }
}
