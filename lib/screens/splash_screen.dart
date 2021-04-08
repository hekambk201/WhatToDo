import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constants.dart';
import '../screens/auth_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 2),
      () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AuthScreen()));
      },
    );
    return Scaffold(
      backgroundColor: kLightColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'What To Do',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: MediaQuery.of(context).size.width / 7,
                color: kPrimaryColor,
                letterSpacing: 5,
                shadows: [
                  Shadow(
                      blurRadius: 22,
                      // bottomLeft
                      offset: Offset(-1.5, -1.5),
                      color: kDarkColor),
                  Shadow(
                      blurRadius: 22,
                      // bottomRight
                      offset: Offset(1.5, -1.5),
                      color: kDarkColor),
                  Shadow(
                      blurRadius: 22,
                      // topRight
                      offset: Offset(1.5, 1.5),
                      color: kDarkColor),
                  Shadow(
                      blurRadius: 22,
                      // topLeft
                      offset: Offset(-1.5, 1.5),
                      color: kDarkColor),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Image.asset(
              'assets/images/logo.png',
              width: MediaQuery.of(context).size.width / 3,
            ),
            SizedBox(
              height: 25,
            ),
            SpinKitFoldingCube(
              color: kPrimaryColor,
              size: MediaQuery.of(context).size.width / 15,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Loading, Please wait...',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
