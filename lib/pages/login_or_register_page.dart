import 'package:flutter/material.dart';
import 'package:socialapp/pages/login_page.dart';
import 'package:socialapp/pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {

  // Initially show Login page
  bool showLoginPage = true;

  // Toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(onTapFunc: togglePages);
    }else{
      return RegisterPage(onTapFunc: togglePages,);
    }
  }
}