import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab_mis/screens/home_screen.dart';

import 'register_screen.dart';

class SignInScreen extends StatefulWidget {
  static const String idScreen = "signinScreen";

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>{

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loginFail = false;
  bool passwordError = false;
  bool emailError = false;
  String loginErrorMessage = "test";

  Future _signIn() async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text)
        .then((value) {
          print("User signed in");
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        });
    } on FirebaseAuthException catch (e){
        print("ERROR HERE");
        print(e.message);
        loginFail = true;
        loginErrorMessage = e.message!;

        if(loginErrorMessage == "There is no user record corresponding to this identifier. The user may have been deleted."){
          emailError = true;
          loginErrorMessage = "User does not exist, please create an account";
        }else {
          passwordError = true;
          loginErrorMessage = "Incorrect password";
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height*0.1, 20, 0),
            child: Column(
            children: <Widget>[
              SizedBox(height: 40),
              Text("Welcome", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 30),),
              SizedBox(height: 40),
              TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText: emailError ? loginErrorMessage : null
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: passwordError ? loginErrorMessage : null
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                icon: Icon(Icons.lock_open, size: 32,),
                label: Text("Sign In", style: TextStyle(fontSize: 24),),
                onPressed: _signIn,
                ),
              SizedBox(height: 20),
              signUpOption()
              ]
            )
          )
        )
      );
  }

  Row signUpOption(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?"),
        GestureDetector(
          onTap: (){
            Navigator.push(context, 
                MaterialPageRoute(builder: (context) => RegisterScreen()));
          },
          child: const Text(" Sign Up",
            style: TextStyle(fontWeight: FontWeight.bold),
            )
        ),
      ],
    );
  }
}