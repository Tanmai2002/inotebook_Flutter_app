import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String email = "";
String username = "";
String password = "";
String cpassword = "";

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isSignup = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Column(children: [
          _isSignup ? SignupForm() : LoginForm(),
          Text(_isSignup ? 'Login?' : 'Sign Up?'),
          IconButton(
              iconSize: 35,
              onPressed: () {
                setState(() {
                  _isSignup = !_isSignup;
                });
              },
              icon: Icon(
                _isSignup ? Icons.toggle_off : Icons.toggle_on,
                color: _isSignup ? Colors.black : Colors.lightBlueAccent,
              ))
        ]));
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: const EdgeInsets.all(25.0),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 30),
              ),
              MyFormText(
                  onChanged: (value) {
                    email = value;
                  },
                  hint: 'Email',
                  icon: Icons.email),
              MyFormText(
                  onChanged: (value) {
                    password = value;
                  },
                  hint: 'Password',
                  icon: Icons.lock),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.popAndPushNamed(context, '/Home');
                    }
                  },
                  child: Text("Login"))
            ],
          )),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _signupFormKey = GlobalKey<FormState>();
  Future<String> signUP() async {
    Navigator.popAndPushNamed(context, '/Home');

    return 'success';

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: const EdgeInsets.all(25.0),
      child: Form(
          key: _signupFormKey,
          child: Column(
            children: [
              Text(
                'Sign Up',
                style: TextStyle(fontSize: 30),
              ),
              MyFormText(onChanged: (v){username=v;}, hint: 'UserName', icon: Icons.person),
              MyFormText(onChanged: (v){email=v;}, hint: 'Email', icon: Icons.email),
              MyFormText(onChanged: (v){password=v;}, hint: 'Password', icon: Icons.lock),
              MyFormText(onChanged: (v){cpassword=v;}, hint: 'Confirm Password', icon: Icons.lock_outline),

              ElevatedButton(
                  onPressed: () {
                    if (_signupFormKey.currentState!.validate()) {
                    }
                  },
                  child: Text("Sign Up"))
            ],
          )),
    );
  }
}

class MyFormText extends StatelessWidget {
  final Function(String x) onChanged;
  final String hint;
  final IconData icon;
  const MyFormText(
      {Key? key,
      required this.onChanged,
      required this.hint,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
          decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon),
              border: OutlineInputBorder()),
          onChanged: onChanged),
    );
  }
}
