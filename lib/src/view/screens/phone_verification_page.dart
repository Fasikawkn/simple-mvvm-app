import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:simple_mvvm_app/src/model/apis/api_response.dart';
import 'package:simple_mvvm_app/src/view/screens/signin_page.dart';
import 'package:simple_mvvm_app/src/view/widgets/country_code.dart';
import 'package:simple_mvvm_app/src/view/widgets/custome_button.dart';
import 'package:simple_mvvm_app/src/view_model/auth_view_model.dart';
import 'package:simple_mvvm_app/src/view_model/db_provider.dart';

class PhoneVerification extends StatefulWidget {
  static const routeName = '/mvvmapp/phoneVerification';
  final Map<String, dynamic> userInfo;
  const PhoneVerification(this.userInfo, {Key? key}) : super(key: key);

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  TextEditingController otpController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  _pleaseFillAllCell() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Text(
        hasError ? "*Please fill up all the cells properly" : "",
        style: const TextStyle(
            color: Colors.red, fontSize: 12, fontWeight: FontWeight.w400),
      ),
    );
  }

  _onPressed(AuthenticationViewModel model, UserProvider userProvider,
      String otpCode) async {
    formKey.currentState!.validate();
    // conditions for validating
    if (currentText.length != 6) {
      errorController!
          .add(ErrorAnimationType.shake); // Triggering error shake animation
      setState(() => hasError = true);
    } else {
      final _phoneAuthProvider = PhoneAuthProvider.credential(
          verificationId: model.verificationID, smsCode: otpCode);
      await model.siginInWithCredential(_phoneAuthProvider);
      if (model.response.status == Status.completed) {
        final _userModel = {
          'id':1,
          'username': widget.userInfo['username']
        };
        await userProvider.insertUser(_userModel);
        Navigator.of(context).restorablePushNamedAndRemoveUntil(
            LoginPage.routeName, (route) => false);
      }
    }
  }

  late UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Consumer<AuthenticationViewModel>(builder: (context, model, child) {
        return SizedBox(
          height: size.height,
          width: size.width,
          child: ListView(
            children: <Widget>[
              _buildImage(
                size.height * 0.4,
              ),
              _buildEnterCodeText(widget.userInfo['phone']),
              const SizedBox(
                height: 20,
              ),
              EnterCodeField(
                errorController: errorController,
                formKey: formKey,
                onChanged: (value) {
                  debugPrint(value);
                  setState(() {
                    currentText = value;
                  });
                },
                otpController: otpController,
              ),
              const SizedBox(
                height: 20,
              ),
              _pleaseFillAllCell(),
              if (model.response.status == Status.error)
                Center(
                  child: Text(
                    model.response.message!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              _buildDidNotRecieveCode(() {}),
              const SizedBox(
                height: 14,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: CustomeButton(
                    child: model.response.status == Status.laoding
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "VERIFY",
                            style: TextStyle(color: Colors.white),
                          ),
                    onPressed: () {
                      _onPressed(model,userProvider, currentText,);
                    }),
              ),
            ],
          ),
        );
      }),
    );
  }

  _getUser() async {
    // final userModel = Provider.of<MvvpUserProvider>(context, listen: false);
    // await userModel.fetchAndSetData();
  }
// Widget _buildUser
  Widget _buildDidNotRecieveCode(Function() onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Didn't receive the code? ",
          style: TextStyle(color: Colors.black54, fontSize: 15),
        ),
        TextButton(
          onPressed: onPressed,
          child: const Text(
            "RESEND",
            style: TextStyle(
                color: Colors.lightBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        )
      ],
    );
  }

  Widget _buildImage(double height) {
    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.asset("assets/images/phone_image_verified.png"),
      ),
    );
  }

  Widget _buildEnterCodeText(String phoneNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
      child: RichText(
        text: TextSpan(
            text: "Enter the code sent to ",
            children: [
              TextSpan(
                  text: phoneNumber,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ],
            style: const TextStyle(color: Colors.black54, fontSize: 15)),
        textAlign: TextAlign.center,
      ),
    );
  }
}
