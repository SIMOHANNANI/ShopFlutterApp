import 'dart:math';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum AuthMode { SignUp, SignIn }

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(237, 83, 0, 0),
                  Color.fromRGBO(237, 83, 0, 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 2],
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

  void _submitFrom() {
    if (!_formKey.currentState.validate()) {
      // The field filled up are not valide
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_authMode == AuthMode.SignUp) {
      // A new user signing up
      print("A new user signing up");

    } else {
      // An existing user trying to sign in
      print("An existing user trying to signing in");
    }
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
      shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)),
      child: SingleChildScrollView(
        child: Container(
          height: 320.0,
          // To change
          constraints: BoxConstraints(minHeight: 320.0),
          // To change
          width: deviceSize.width * 0.75,
          padding: EdgeInsets.all(16.0),
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
                FlatButton(
                  child: Text(
                    '${_authMode == AuthMode.SignIn ? 'SIGN-UP' : 'SIGN-UP'} INSTEAD',
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
