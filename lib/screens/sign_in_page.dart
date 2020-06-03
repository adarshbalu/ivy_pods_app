import 'package:flutter/material.dart';
import 'package:ivypodsapp/utils/auth.dart';

class SignIn extends StatelessWidget {
  SignIn({@required this.auth});
  final AuthBase auth;

  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: mq.height * 0.2,
          padding: EdgeInsets.all(10),
          child: Text(
            "Sign In to Continue",
            style: TextStyle(
              fontSize: 40 * curScaleFactor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: mq.height * 0.025),
        RaisedButton(
          onPressed: _signInWithGoogle,
          child: Text('Sign in with google'),
        ),
        SizedBox(height: mq.height * 0.0375),
      ],
    ));
  }
}
