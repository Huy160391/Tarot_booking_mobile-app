import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isSigningIn = false;

  // Placeholder for the action when the button is pressed
  void _onSignUpPressed() {
    setState(() {
      _isSigningIn = true;
    });

    // Perform any action here (for now, just a delay to simulate some action)
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isSigningIn = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/tarotpage.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: _isSigningIn
              ? CircularProgressIndicator()
              : OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white.withOpacity(0.9)),
                    backgroundColor: Colors.white.withOpacity(0.7),
                  ),
                  onPressed: _onSignUpPressed,
                  child: Text(
                    'Sign up',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
        ),
      ),
    );
  }
}
