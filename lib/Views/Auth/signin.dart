import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:quora/Services/authservices.dart';
import 'package:quora/Views/Auth/completeprofile.dart';
import 'package:quora/Views/Auth/signup.dart';
import 'package:quora/Views/Home/homescreen.dart';
import 'package:quora/styles/colors.dart';

class SignInScreen extends StatefulWidget {
  static const routename = '/signinpage';
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isSigninLoading = false;
  bool isGoogleLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  bool _obscure = false;

  _showCustomSnackBar(String message) {
    Flushbar(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(12),
        duration: Duration(seconds: 5),
        borderRadius: 10,
        message: message)
      ..show(context);
  }

  _submitform() {
    if (_emailController.text == null && _passwordController.text == null) {
      _showCustomSnackBar("Please enter valid email and password!!");
      return;
    } else {
      setState(() {
        isSigninLoading = true;
      });
      try {
        Provider.of<Auth>(context, listen: false)
            .logIn(_emailController.text, _passwordController.text)
            .then((value) {
          setState(() {
            isSigninLoading = false;
          });
          _showCustomSnackBar(value[0]);
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return (value[1]) ? HomeScreen() : CompleteYourProfile(null);
          }));
        }).catchError((msg) {
          setState(() {
            isSigninLoading = false;
          });
          _showCustomSnackBar(msg);
        });
      } catch (e) {
        setState(() {
          isSigninLoading = false;
        });
        _showCustomSnackBar(e.toString());
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
                padding: EdgeInsets.symmetric(vertical: 42),
                height: _clipone,
                color: AppColors.orange,
                child: SvgPicture.asset("assets/svgs/login.svg"),
              ),
            ),
            Container(
              height: _height - (_cliptwo + _clipone),
              width: _width,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Sign In",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 29,
                                color: AppColors.violet,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: _emailController,
                          onFieldSubmitted: (_) {
                            FocusNode().requestFocus(_passwordNode);
                          },
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
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          obscureText: _obscure,
                          controller: _passwordController,
                          onFieldSubmitted: (_) {
                            FocusNode().unfocus();
                          },
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
                          child: (!isSigninLoading)
                              ? Text("Sign In")
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 1,
                            width: 80,
                            color: AppColors.orange,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Or",
                            style: TextStyle(color: AppColors.orange),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 1,
                            width: 80,
                            color: AppColors.orange,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        width: 220,
                        child: Material(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isGoogleLoading = true;
                              });
                              Provider.of<Auth>(context, listen: false)
                                  .googleSignIn()
                                  .then((msg) {
                                setState(() {
                                  isGoogleLoading = false;
                                });
                                _showCustomSnackBar(msg[0]);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                  return (msg[2])
                                      ? HomeScreen()
                                      : CompleteYourProfile(msg[1]);
                                }));
                              }).catchError((error) {
                                setState(() {
                                  isGoogleLoading = false;
                                });
                                _showCustomSnackBar(error);
                              });
                            },
                            child: (!isGoogleLoading)
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/pngs/google.png'),
                                                fit: BoxFit.contain)),
                                      ),
                                      Container(
                                        height: 48,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      Text("Sign In with Google"),
                                    ],
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don\'t have account ?"),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                    SignUPScreen.routename);
                              },
                              child: Text(
                                "Sign Up",
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
