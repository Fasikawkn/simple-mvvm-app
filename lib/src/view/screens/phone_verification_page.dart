import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:simple_mvvm_app/src/view/screens/home_page.dart';
import 'package:simple_mvvm_app/src/view/widgets/country_code.dart';
import 'package:simple_mvvm_app/src/view/widgets/custome_button.dart';

class PhoneVerification extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  const PhoneVerification( this.userInfo, {Key? key}) : super(key: key);

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

  _onPressed() async {

    formKey.currentState!.validate();
    // conditions for validating
    if (currentText.length != 6) {
      errorController!
          .add(ErrorAnimationType.shake); // Triggering error shake animation
      setState(() => hasError = true);
    } else {
     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage(),),);
   
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: ListView(
            children: <Widget>[
             
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
              _buildDidNotRecieveCode((){}),
              const SizedBox(
                height: 14,
              ),
              CustomeButton(
                child: const Text(
                        "VERIFY",
                        style: TextStyle(color: Colors.white),
                      ),
                onPressed: _onPressed
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getUser() async {
    // final userModel = Provider.of<MvvpUserProvider>(context, listen: false);
    // await userModel.fetchAndSetData();
  }
// Widget _buildUser
 Widget _buildDidNotRecieveCode(Function() onPressed){
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

  Widget _buildEnterCodeText(String phoneNumber){
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
