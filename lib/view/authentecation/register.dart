import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherapp/view/authentecation/login.dart';
import 'package:weatherapp/view/pages/homepage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String firstname, email, password;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _success = false;
  String _userEmail;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _register() async {
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false);
    } else {
      _success = false;
      _showToast(context, 'Registration failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(36),
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
                          // validator: NameValidator.validate,
                          controller: _firstNameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // filled: true,
                            labelText: 'Firstname',
                            labelStyle: GoogleFonts.montserrat(
                                fontSize: 15, fontWeight: FontWeight.w300),
                          ),
                          onSaved: (input) => firstname = input,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          style: GoogleFonts.montserrat(
                              fontSize: 17, fontWeight: FontWeight.w300),
                          // validator: NameValidator.validate,
                          controller: _lastNameController,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // filled: true,
                            labelText: 'LastName',
                            labelStyle: GoogleFonts.montserrat(
                                fontSize: 15, fontWeight: FontWeight.w300),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          style: GoogleFonts.montserrat(
                              fontSize: 17, fontWeight: FontWeight.w300),
                          // validator: EmailValidator.validate,
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
                          height: 15,
                        ),
                        TextFormField(
                          style: GoogleFonts.montserrat(
                              fontSize: 17, fontWeight: FontWeight.w300),
                          // validator: PasswordValidator.validate,
                          controller: _passwordController,
                          obscureText: _obscureText,
                          textCapitalization: TextCapitalization.words,
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
                          onSaved: (input) => password = input,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _success
                            ? CircularProgressIndicator(
                                //  backgroundColor: Colors.grey,
                                strokeWidth: 1.5,
                              )
                            : RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                textColor: Colors.white,
                                disabledColor: Colors.grey,
                                color: Color(0xff01A0C7),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 50),
                                  child: Text('Register',
                                      style:
                                          GoogleFonts.montserrat(fontSize: 17)),
                                ),
                                onPressed: _success ? null : _register),
                        SizedBox(
                          height: 20,
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginPage()));
                          },
                          child: Text("Already have an account? LOGIN",
                              style: GoogleFonts.montserrat(fontSize: 12)),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showToast(BuildContext context, msg) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(),
      content: Text(
        msg,
        style: GoogleFonts.montserrat(fontSize: 12),
      ),
      duration: Duration(seconds: 5),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
