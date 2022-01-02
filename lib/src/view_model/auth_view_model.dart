import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_mvvm_app/src/model/apis/api_response.dart';
import 'package:simple_mvvm_app/src/view/screens/phone_verification_page.dart';

class AuthenticationViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Response _response = Response.initial("authentiate");

  Response get response {
    return _response;
  }

  set response(Response response) {
    _response = response;
    notifyListeners();
  }

  String verificationID = '';
  Future verifyPhone(
      Map<String, dynamic> userInfo, BuildContext context) async {
    try {
      response = Response.loading("Verifying");
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: userInfo['phone'],
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: (String verificationId, int? forceResendingToken) {
          verificationID = verificationId;

          response = Response.completed(verificationId);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PhoneVerification(userInfo),
            ),
          );
          notifyListeners();
        },
        codeAutoRetrievalTimeout: _onCodeAutoRetrievalTimeout,
      );
    } on FirebaseAuthException catch (e) {
      String message = getMessageFromErrorCode(e.code);
      response = Response.error(message);
    } catch (e) {
      response = Response.error(e.toString());
    }
  }

  // Verification Completed
  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    debugPrint("verification completed${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;
    if (authCredential.smsCode != null) {
      try {
        await user!.linkWithCredential(authCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'provider-already-linked') {
          await siginInWithCredential(authCredential);
        }
      }
    }
  }

  Future siginInWithCredential(PhoneAuthCredential phoneAuthCredential) async {
    try {
      await _firebaseAuth.signInWithCredential(phoneAuthCredential);
    } catch (e) {
      if (e.toString().toLowerCase().contains("auth credential is invalid")) {
      } else {}
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      debugPrint("The phone Number is invalid");
    }
    String message = getMessageFromErrorCode(exception.code);

    notifyListeners();
  }

  _onCodeAutoRetrievalTimeout(String timeout) {
    return null;
  }

  signout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      debugPrint("somting happened");
    }
  }

  String getMessageFromErrorCode(String errorCode) {
    switch (errorCode) {
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used. Go to login page.";
      case "wrong-password":
        return "Wrong email/password combination.";
      case "user-not-found":
        return "No user found with this email.";
      case "user-disabled":
        return "User disabled.";
      case "too-many-requests":
        return "Too many requests to log into this account.";
      case "invalid-email":
        return "Email address is invalid.";
      default:
        return "Login failed. Please try again.";
    }
  }
}
