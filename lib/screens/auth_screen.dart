import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/auth.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FlutterLogin(
        messages: LoginMessages(
          recoverPasswordDescription: 'Please enter your email',
        ),
        title: 'What To Do',
        theme: LoginTheme(
          titleStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width / 15,
            color: kPrimaryColor,
            letterSpacing: 5,
            shadows: [
              Shadow(
                  // bottomLeft
                  offset: Offset(-1.5, -1.5),
                  color: kDarkColor),
              Shadow(
                  // bottomRight
                  offset: Offset(1.5, -1.5),
                  color: kDarkColor),
              Shadow(
                  // topRight
                  offset: Offset(1.5, 1.5),
                  color: kDarkColor),
              Shadow(
                  // topLeft
                  offset: Offset(-1.5, 1.5),
                  color: kDarkColor),
            ],
          ),
          pageColorLight: kSecondaryColor.withOpacity(.8),
          pageColorDark: kSecondaryColor.withOpacity(.8),
        ),
        logo: 'assets/images/logo.png',
        onSignup: (data) async {
          return await Provider.of<Auth>(context, listen: false)
              .signup(data.name, data.password);
        },
        onLogin: (data) async {
          return await Provider.of<Auth>(context, listen: false)
              .login(data.name, data.password);
        },
        onRecoverPassword: (val) async {
          return 'Function Not available yet!';
        },
      ),
    );
  }
}
