import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:inotebook/api/ApiCalls.dart';

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
  Future checkAuth()async {
    await ApisCall.initializeValues();
    if(ApisCall.auth.isNotEmpty){
      Navigator.popAndPushNamed(context, '/Home');
    }
  }
  @override
  void initState(){
    checkAuth();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
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
          ]),
        ));
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  Future<String> login() async{
    Response response=await ApisCall.loginApi(email: email, password: password);
    if(response.statusCode!=200){
      Map<String,dynamic> errors=jsonDecode(response.body);
      Fluttertoast.showToast(msg: errors['Error']!=null?errors['Error'].toString():"",backgroundColor: Colors.redAccent);

      return 'Error';
    }
    Navigator.popAndPushNamed(context, '/Home');
    Fluttertoast.showToast(msg: 'Success',backgroundColor: Colors.greenAccent);

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: const EdgeInsets.all(25.0),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
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
                  hide: true,
                  hint: 'Password',
                  icon: Icons.lock),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      login();
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

    Response response=await ApisCall.signUpApi(username: username, email: email, password: password);
    if(response.statusCode!=200){
      Map<String,dynamic> errors=jsonDecode(response.body);
      Fluttertoast.showToast(msg: errors['Error']!=null?errors['Error'].toString():"",backgroundColor: Colors.redAccent);

      return 'Error';
    }

    Navigator.popAndPushNamed(context, '/Home');
    Fluttertoast.showToast(msg: 'Success',backgroundColor: Colors.greenAccent);
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
              const Text(
                'Sign Up',
                style: TextStyle(fontSize: 30),
              ),
              MyFormText(onChanged: (v){username=v;}, hint: 'UserName', icon: Icons.person),
              MyFormText(onChanged: (v){email=v;}, hint: 'Email', icon: Icons.email),
              MyFormText(onChanged: (v){password=v;},hide: true, hint: 'Password', icon: Icons.lock),
              MyFormText(onChanged: (v){cpassword=v;}, hint: 'Confirm Password', icon: Icons.lock_outline),

              ElevatedButton(
                  onPressed: () {
                    if (_signupFormKey.currentState!.validate()) {
                      signUP();
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
  final bool hide;
  const MyFormText(
      {Key? key,
      required this.onChanged,
      required this.hint,
      required this.icon,
      this.hide=false})
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
          obscureText: hide,
          onChanged: onChanged),
    );
  }
}
