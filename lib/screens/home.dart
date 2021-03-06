import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innovtion/providers/auth.dart';
import 'package:innovtion/screens/page.dart';
import 'package:innovtion/screens/user_info.dart';

import 'base.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image(
                image: AssetImage('images/newlogo.png'),
              ),
            ),
            Container(
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                splashColor: Colors.orange,
                onTap: () async {
                  final result = await Auth().signInWithGoogle();
                  if (result) {
                    final check = await Auth().checkuserInfo();
                    print('check $check');
                    if (check) {
                      Navigator.of(context)
                          .pushReplacementNamed(Page1.routeName);
                    } else {
                      Navigator.of(context)
                          .pushReplacementNamed(UserInfoScreen.routeName);
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black, spreadRadius: 1, blurRadius: 10)
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Sign In With Google',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  // color: Colors.white30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
