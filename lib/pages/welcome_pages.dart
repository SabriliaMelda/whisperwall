import 'package:flutter/material.dart';
import 'package:whisperwall/pages/register_pages.dart';
import 'package:whisperwall/pages/login_pages.dart';
import 'package:whisperwall/shared/shared.dart';

class WelcomePages extends StatefulWidget {
  const WelcomePages({Key? key}) : super(key: key);

  @override
  _WelcomePagesState createState() => _WelcomePagesState();
}

class _WelcomePagesState extends State<WelcomePages> {
  bool _isHidden = true;
  bool _isHiddenCourse = true;
  bool _isHiddenPassword = true;
  bool _isHiddenConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            Image.asset('assets/images/w.png', height: 400),
            SizedBox(height: 15),
            Text(
              "'Kamu dilahirkan untuk menjadi nyata, \nbukan untuk menjadi sempurna.' \n\nMin Yoongi",
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 51),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width - 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text(
                  'Create Account',
                  style: whiteTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: primaryColor),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width - 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  'Login',
                  style: whiteTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: secondaryColor),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: secondaryColor, width: 3),
                        borderRadius: BorderRadius.circular(15))),
              ),
            ),
            SizedBox(
              height: 36,
            ),
            Text('All Right Reserved @2025',
                textAlign: TextAlign.center,
                style: whiteTextStyle.copyWith(
                    color: secondaryColor, fontSize: 11)),
            SizedBox(
              height: defaultMargin,
            ),
          ],
        ),
      ),
    );
  }

  void _toogleUsernameView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _toogleCourseView() {
    setState(() {
      _isHiddenCourse = !_isHiddenCourse;
    });
  }

  void _tooglePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  void _toogleConfirmPasswordView() {
    setState(() {
      _isHiddenConfirmPassword = !_isHiddenConfirmPassword;
    });
  }
}
