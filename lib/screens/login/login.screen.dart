import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:maps/screens/pages.screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogged = false;
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final barSize = MediaQuery.of(context).padding.top;

    return Material(
        child: SafeArea(
      child: Stack(
        children: <Widget>[
          Container(
            //color: Color.fromRGBO(243, 243, 246, 1),
            color: Color.fromRGBO(255, 190, 0, 1),
          ),
          Positioned(
            left: 48,
            right: 48,
            top: ((screenSize.height - (432.0 + barSize)) / 2),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                width: screenSize.width - 96,
                height: 452,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 81.0),
                      child: Image.asset('assets/images/logo.png'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 27),
                      child: Text(
                        "Challenge",
                        style: TextStyle(
                          fontFamily: "Rubik",
                          fontSize: 18,
                          color: Color.fromRGBO(16, 21, 154, 1),
                          letterSpacing: 0.92,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 51, left: 21, right: 21),
                      child: OutlineButton(
                        onPressed: _handleSignIn,
                        padding: EdgeInsets.symmetric(
                          vertical: 19,
                          horizontal: 15,
                        ),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(16, 21, 154, 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Sign in with facebook',
                              style: TextStyle(
                                fontFamily: "Nunito",
                                fontSize: 16,
                                color: Color.fromRGBO(16, 21, 154, 1),
                                letterSpacing: 0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 21, right: 21),
                      child: RaisedButton(
                        onPressed: _handleSignIn,
                        padding: EdgeInsets.symmetric(
                          vertical: 19,
                          horizontal: 15,
                        ),
                        color: Color.fromRGBO(16, 21, 154, 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Sign up with facebook',
                              style: TextStyle(
                                fontFamily: "Nunito",
                                fontSize: 16,
                                color: Colors.white,
                                letterSpacing: 0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }

  _handleSignIn() async {
    FacebookLogin fbLogin = FacebookLogin();
    FacebookLoginResult fbResult = await fbLogin.logIn(['email']);
    if (fbResult != null && fbResult.accessToken != null) {
      final accessToken = fbResult.accessToken.token;

      switch (fbResult.status) {
        case FacebookLoginStatus.cancelledByUser:
          print("called");
          break;
        case FacebookLoginStatus.error:
          print("error");
          break;
        case FacebookLoginStatus.loggedIn:
          final fbCredential =
              FacebookAuthProvider.getCredential(accessToken: accessToken);
          await firebaseAuth.signInWithCredential(fbCredential);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PagesScreen()),
          );

          break;
        default:
      }
    }
  }
}
