import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_mvvm_app/src/model/apis/api_response.dart';
import 'package:simple_mvvm_app/src/view/screens/home_page.dart';
import 'package:simple_mvvm_app/src/view/screens/phone_verification_page.dart';

import 'package:simple_mvvm_app/src/view/widgets/custome_button.dart';
import 'package:simple_mvvm_app/src/view/widgets/phone_code.dart';
import 'package:simple_mvvm_app/src/view_model/auth_view_model.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/mvvmapp/loginpage";
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailEextEditingController =
      TextEditingController();
  final TextEditingController _phoneTextEditingController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _dialCode = '+251';

  // late AuthenticationViewModel authenticationViewModel;

  @override
  Widget build(BuildContext context) {
    // authenticationViewModel = Provider.of<AuthenticationViewModel>(context);
    final size = MediaQuery.of(context).size;
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? const HomePage()
              : Scaffold(
                  body: Consumer<AuthenticationViewModel>(
                      builder: (context, model, child) {
                    return SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: size.height * 0.3,
                              ),
                              if (model.response.status == Status.error)
                                if (model.response.message != 'Time out')
                                  Text(
                                    model.response.message!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                              const Text(
                                'Sign in',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                controller: _emailEextEditingController,
                                onSaved: (value) {
                                  _emailEextEditingController.text = value!;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Email or Username required";
                                  }
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text("Email or Username"),
                                  prefixIcon: Icon(Icons.email),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.06,
                              ),
                              SizedBox(
                                width: size.width,
                                child: Row(
                                  children: [
                                    CountryCode(
                                      countryCode: (code) {
                                        setState(() {
                                          _dialCode = code;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: size.width * 0.55,
                                      child: TextFormField(
                                        controller: _phoneTextEditingController,
                                        keyboardType: TextInputType.phone,
                                        onSaved: (value) {
                                          _phoneTextEditingController.text =
                                              value!;
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "phone required";
                                          }
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text("Phone Number"),
                                          // prefixIcon: Icon(Icons.phone),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.06,
                              ),
                              CustomeButton(
                                onPressed: () async {
                                  _formKey.currentState!.save();
                                  if (_formKey.currentState!.validate()) {
                                    Map<String, dynamic> _userInfo = {
                                      "phone":
                                          "$_dialCode${_phoneTextEditingController.text}",
                                      "username":
                                          _emailEextEditingController.text
                                    };
                                    // String _validPhone = _dialCode + _phoneTextEditingController.text;
                                    model.verifyPhone(_userInfo, context);

                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (context) => PhoneVerification(_userInfo),
                                    //   ),
                                    // );
                                  }
                                },
                                child: model.response.status == Status.laoding
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.white),
                                      )
                                    : const Text(
                                        "LOG IN",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
        });
  }
}
