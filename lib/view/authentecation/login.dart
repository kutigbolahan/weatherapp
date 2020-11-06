import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/view/authentecation/register.dart';
import 'package:weatherapp/view/pages/homepage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String email = "";
  String password = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _signInWithEmailAndPassword() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      setState(() {
        _isLoading = true;
      });
      SharedPreferences localStorage = await SharedPreferences.getInstance();

      localStorage.setString('data', "${user.email} signed in");
      showToast(context, "${user.email} signed in");

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showToast(context, "Failed to sign in with Email & Password");
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text("Failed to sign in with Email & Password"),
      // ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(26),
            child: Column(
              children: <Widget>[
                Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          style: GoogleFonts.montserrat(
                              fontSize: 17, fontWeight: FontWeight.w300),
                          //   validator: EmailValidator.validate,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),

                            // filled: true,

                            labelText: 'Email',
                            labelStyle: GoogleFonts.montserrat(
                                fontSize: 15, fontWeight: FontWeight.w300),
                          ),
                          onSaved: (input) => email = input,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                            style: GoogleFonts.montserrat(
                                fontSize: 17, fontWeight: FontWeight.w300),
                            //  validator: PasswordValidator.validate,
                            controller: _passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // filled: true,
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(_obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                              labelText: 'Password',
                              labelStyle: GoogleFonts.montserrat(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            ),
                            onSaved: (input) => password = input),
                        SizedBox(
                          height: 20,
                        ),
                        _isLoading
                            ? CircularProgressIndicator(
                                //  backgroundColor: Colors.grey,
                                strokeWidth: 1.5,
                              )
                            : Container(
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    textColor: Colors.white,
                                    disabledColor: Colors.grey,
                                    color: Color(0xff01A0C7),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 50),
                                      child: Text('Login',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 17)),
                                    ),
                                    onPressed: _isLoading
                                        ? null
                                        : _signInWithEmailAndPassword),
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {},
                                child: Text("Forgot Password?",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 12) //TextStyle(fontSize: 10),
                                    ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ]),
                        SizedBox(height: 80),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                          },
                          child: Text(
                            "Don't have an account? REGISTER",
                            style: GoogleFonts.montserrat(fontSize: 12),
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showToast(BuildContext context, msg) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(),
      content: Text(
        msg,
        style: GoogleFonts.montserrat(fontSize: 12, color: Colors.white),
      ),
      duration: Duration(seconds: 4),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
