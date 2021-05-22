import 'package:flushbar/flushbar.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quora/Services/authservices.dart';
import 'package:quora/Views/Auth/completeprofile.dart';
import 'package:quora/Views/Auth/signin.dart';
import 'package:quora/styles/colors.dart';

class SignUPScreen extends StatefulWidget {
  static const routename = '/signuppage';
  @override
  _SignUPScreenState createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  bool isSigninIn = false;
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailNode = FocusNode();
  final _usernameNode = FocusNode();
  final _passwordNode = FocusNode();
  bool _obscure = true;

  _showCustomSnackBar(String message) {
    Flushbar(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(12),
        borderRadius: 10,
        duration: Duration(seconds: 5),
        message: message)
      ..show(context);
  }

  _submitform() {
    if (!_formkey.currentState.validate()) {
      return;
    } else {
      try {
        setState(() {
          isSigninIn = true;
        });
        Provider.of<Auth>(context, listen: false)
            .signUp(
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        )
            .then((value) {
          _showCustomSnackBar(value + "!!");
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return CompleteYourProfile(null);
          }));
        }).catchError((msg) {
          setState(() {
            isSigninIn = false;
          });
          _showCustomSnackBar(msg);
        });
      } catch (e) {
        setState(() {
          isSigninIn = false;
        });
        _showCustomSnackBar(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final _padding = MediaQuery.of(context).padding.top;
    final _clipone = _height * 0.45 - _padding - kToolbarHeight;
    final _cliptwo = _height * 0.1;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipPath(
              clipper: WaveClipperTwo(
                flip: true,
                reverse: false,
              ),
              child: Container(
                  height: _clipone,
                  color: AppColors.orange,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 42),
                    height: _clipone,
                    child: SvgPicture.asset("assets/svgs/signup.svg"),
                  )),
            ),
            Container(
              height: _height - (_clipone + _cliptwo),
              width: _width,
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 29,
                              color: AppColors.violet,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          controller: _usernameController,
                          onFieldSubmitted: (_) {
                            FocusNode().requestFocus(_emailNode);
                          },
                          validator: MultiValidator([
                            RequiredValidator(errorText: "* Required"),
                          ]),
                          focusNode: _usernameNode,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.orange)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.violet)),
                              labelText: "Username",
                              labelStyle: TextStyle(color: AppColors.orange)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          controller: _emailController,
                          onFieldSubmitted: (_) {
                            FocusNode().requestFocus(_passwordNode);
                          },
                          validator: MultiValidator([
                            RequiredValidator(errorText: "* Required"),
                            EmailValidator(errorText: "Enter valid email id"),
                          ]),
                          focusNode: _emailNode,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.violet)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.orange)),
                              border: UnderlineInputBorder(),
                              labelText: "Email",
                              labelStyle: TextStyle(color: AppColors.orange)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          obscureText: _obscure,
                          controller: _passwordController,
                          onFieldSubmitted: (_) {
                            FocusNode().unfocus();
                          },
                          validator: MultiValidator([
                            RequiredValidator(errorText: "* required"),
                            MinLengthValidator(8,
                                errorText: "Password must contain 8 characters")
                          ]),
                          focusNode: _passwordNode,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.violet)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.orange)),
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    (_obscure)
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppColors.violet,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscure = !_obscure;
                                    });
                                  }),
                              border: UnderlineInputBorder(),
                              labelText: "Password",
                              labelStyle: TextStyle(color: AppColors.orange)),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            _submitform();
                          },
                          child: (!isSigninIn)
                              ? Text("Sign Up")
                              : CircularProgressIndicator(),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPrimary: Colors.white,
                              primary: AppColors.violet),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have account?"),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                    SignInScreen.routename);
                              },
                              child: Text(
                                "Sign In",
                                style: TextStyle(color: AppColors.orange),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ClipPath(
              clipper: WaveClipperTwo(flip: false, reverse: true),
              child: Container(
                height: _cliptwo,
                color: AppColors.violet,
              ),
            )
          ],
        ),
      ),
    );
  }
}
