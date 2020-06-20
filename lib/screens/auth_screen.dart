import 'dart:math';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/http_exception_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
enum AuthMode { SignUp, SignIn }

class AuthScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(

//            margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/img/women.png",
                ),
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              width: deviceSize.width,
              height: deviceSize.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 90.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                      transform: Matrix4.rotationZ(10 * pi / 180)
                        ..translate(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.orange,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20.0,
                            color: Colors.orange,
                            offset: Offset(5, 7),
                          )
                        ],
                      ),
                      child: Text(
                        'Shopping Universe',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 60.0,
                          fontFamily: 'Piedra',
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.SignIn;
  Map<String, String> _authCred = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorMessage(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error occurred'),
        content: Text(errorMessage),
        actions: <Widget>[
          FlatButton(
            child: Text('close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _submitFrom() async {
    if (!_formKey.currentState.validate()) {
      // The field filled up are not valide
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.SignUp) {
        // A new user signing up
        print("A new user signing up");
        await Provider.of<Auth>(context, listen: false).signUp(
          _authCred['email'],
          _authCred['password'],
        );
      } else {
        // An existing user trying to sign in
        print("An existing user trying to signing in");
        await Provider.of<Auth>(context, listen: false).signIn(
          _authCred['email'],
          _authCred['password'],
        );
      }
    } on HttpExceptionHandler catch (e) {
      var errorMessage = 'wrong credentials';
      if (e.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email was already token';
      } else if (e.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'Invalid email ! Please try another one';
      } else if (e.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Weak password';
      } else if (e.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'You\'re not registred yet, Please sign up';
      } else if (e.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'incorrect password';
      }
      _showErrorMessage(errorMessage);
    } catch (e) {
      print(e);
      var errorMessage = 'Something went wrong, Please try later';
      _showErrorMessage(errorMessage);
    }
    print("logged in ");

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.SignIn) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.SignIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 20.0,
      color: Color.fromRGBO(252, 252, 252, 0.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: SingleChildScrollView(
        child: Container(
          padding:EdgeInsets.symmetric(vertical: 30.0,horizontal: 40.0),
          height: 320.0,
          // To change
          constraints: BoxConstraints(minHeight: 350.0),
          // To change
          width: deviceSize.width * 0.75,
//          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authCred['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 8) {
                      return 'Weak password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authCred['password'] = value;
                  },
                ),
//            if (AuthMode == AuthMode.SignUp)
                _authMode == AuthMode.SignUp
                    ? TextFormField(
                        enabled: _authMode == AuthMode.SignUp,
                        decoration:
                            InputDecoration(labelText: 'Retype password'),
                        obscureText: true,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'passwords does not match';
                          }
                          return null;
                        },
                      )
                    : SizedBox(
                        height: 30.0,
                      ),
                SizedBox(
                  height: 20.0,
                ),
                _isLoading
                    ? SizedBox(
                        height: 10.0,
                        width: 10.0,
                        child: CircularProgressIndicator(),
                      )
                    : RaisedButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 40.0),
                        child: Text(
                          '${_authMode == AuthMode.SignIn ? 'SIGN-IN' : 'SIGN-UP'}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        onPressed: _submitFrom,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: Colors.orangeAccent,
                        textColor: Colors.white,
                        elevation: 5.0,
                        splashColor: Theme.of(context).primaryColor,
                      ),
                _authMode == AuthMode.SignIn ? FlatButton(
                  child: Text(
                    'A new user ?',
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 15.0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: _switchAuthMode,
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                  textColor: Theme.of(context).primaryColor,
                ):FlatButton(
                  child: Text(
                    'Already registred ?',
                    style:
                    TextStyle(fontWeight: FontWeight.w800, fontSize: 15.0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: _switchAuthMode,
                  padding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
