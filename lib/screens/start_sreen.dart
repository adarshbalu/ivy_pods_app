import 'package:flutter/material.dart';
import 'package:ivypodsapp/screens/home_page.dart';
import 'package:ivypodsapp/screens/sign_in_page.dart';
import 'package:ivypodsapp/utils/auth.dart';

class StartScreen extends StatelessWidget {
  StartScreen({@required this.auth});
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignIn(
                auth: auth,
              );
            }
            return HomePage();
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
