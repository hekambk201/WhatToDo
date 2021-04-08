// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/notes.dart';
import 'providers/auth.dart';
import 'providers/events.dart';
import 'providers/todos.dart';
import 'screens/auth_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/main_screen.dart';
import 'providers/navigation.dart';
import './constants.dart';

void main() {
  // SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyNavigator(),
        ),
        ChangeNotifierProxyProvider<Auth, Events>(
          create: (_) => Events(null, null, null),
          update: (context, auth, previousEvents) => Events(
              auth.token,
              auth.userId,
              previousEvents == null ? {} : previousEvents.allEvents),
        ),
        ChangeNotifierProxyProvider<Auth, Todos>(
          create: (_) => Todos(null, null, null),
          update: (context, auth, previousTodos) => Todos(auth.token,
              auth.userId, previousTodos == null ? [] : previousTodos.allTodos),
        ),
        ChangeNotifierProxyProvider<Auth, Notes>(
          create: (_) => Notes(null, null, null),
          update: (context, auth, previousNotes) => Notes(auth.token,
              auth.userId, previousNotes == null ? [] : previousNotes.allNotes),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'What To Do',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primaryColor: kPrimaryColor,
            accentColor: kSecondaryColor,
            fontFamily: 'Lato',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth
              ? MainScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? LoadingScreen()
                          : AuthScreen(),
                ),
          // home: MainScreen(),
          routes: {
            MainScreen.routeName: (ctx) => MainScreen(),
          },
        ),
      ),
    );
  }
}
