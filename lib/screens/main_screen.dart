import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/auth.dart';

import '../constants.dart';
import '../providers/navigation.dart';

class MainScreen extends StatelessWidget {
  static const routeName = '/mainScreen';

  Widget build(BuildContext context) {
    String email = Provider.of<Auth>(context, listen: false).userEmail;
    int index = Provider.of<MyNavigator>(context).index;
    String appBarTitle = '';
    switch (index) {
      case 0:
        appBarTitle = 'Calendar';
        break;
      case 1:
        appBarTitle = 'Todos';
        break;
      case 2:
        appBarTitle = 'Notes';
        break;
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: kPrimaryColor),
          title: Text(
            appBarTitle,
            style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: index,
          backgroundColor: Colors.white,
          color: Theme.of(context).primaryColor,
          onTap: (val) {
            if (val == 0) {
              Provider.of<MyNavigator>(context, listen: false).setCalendar();
            } else if (val == 1) {
              Provider.of<MyNavigator>(context, listen: false).setTodos();
            }
            if (val == 2) {
              Provider.of<MyNavigator>(context, listen: false).setNotes();
            }
          },
          items: <Widget>[
            Icon(
              FontAwesomeIcons.calendar,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              FontAwesomeIcons.list,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              FontAwesomeIcons.solidStickyNote,
              size: 30,
              color: Colors.white,
            ),
          ],
        ),
        body: Consumer<MyNavigator>(
            builder: (context, nav, _) => nav.currentPage),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/logo.png',
                width: MediaQuery.of(context).size.width / 4,
              ),
              SizedBox(
                height: 5,
              ),
              Image.asset(
                'assets/images/drawer.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Signed in as: ',
                    style: TextStyle(
                        color: kSecondaryColor,
                        fontSize: MediaQuery.of(context).size.width / 25),
                  ),
                  Text(
                    email.toString(),
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: MediaQuery.of(context).size.width / 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 2,
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(
                      color: kSecondaryColor,
                      fontSize: MediaQuery.of(context).size.width / 20,
                      fontWeight: FontWeight.bold),
                ),
                leading: Icon(
                  FontAwesomeIcons.signOutAlt,
                  color: kSecondaryColor,
                ),
                onTap: () {
                  AwesomeDialog(
                      context: context,
                      headerAnimationLoop: false,
                      dialogType: DialogType.WARNING,
                      animType: AnimType.TOPSLIDE,
                      btnOkText: 'Yes',
                      btnCancelText: 'No',
                      title: 'Are you sure?',
                      desc: 'Are you sure that you want to logout?',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () async {
                        await Provider.of<Auth>(context, listen: false)
                            .logout();
                      }).show();
                },
              ),
              Divider(
                thickness: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
