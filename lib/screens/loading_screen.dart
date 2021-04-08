import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constants.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitChasingDots(
              itemBuilder: (context, index) => DecoratedBox(
                decoration: BoxDecoration(
                  color: index.isEven ? kPrimaryColor : kDarkColor,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Please wait...',
              style: TextStyle(
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
