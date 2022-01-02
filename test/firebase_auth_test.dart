import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart';
import 'package:simple_mvvm_app/src/view_model/auth_view_model.dart';

class MockAuth extends Mock implements FirebaseAuth {}

void main() {
  final MockAuth mockAuth = MockAuth();
  final AuthenticationViewModel viewModel = AuthenticationViewModel();
  setUp(() {});
  tearDown(() {});

  test('testing verify phone', () async{
    Map<String, dynamic> _userInfo = {'phone': "+251929465849", 'username':'abex'};

    when(viewModel.verifyPhone(_userInfo,BuildContext context ))
  });
}
