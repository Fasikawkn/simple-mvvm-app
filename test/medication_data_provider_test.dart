import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:simple_mvvm_app/src/model/services/medicine_data_provider.dart';

import 'constants.dart';
@GenerateMocks([http.Client])
void main() {
  group('Testing Medication data provider Method', () {

    // In this test case, the method return a json string if the the http call is completed successfully
    // the expect method check if the method returns a json string
    // and if the result is as expected it passes the test case.
    test('returns A list of medications if the http call completes succesfully',
        () async {
      final client = MockClient((req) async {
        return http.Response(jsonEncode(mockAPi), 200);
      });

      MedicineDataProvider dataProvider =
          MedicineDataProvider(httpClient: client);

      expect(await dataProvider.getAllMeMedicines(), mockAPi);
    });

    // In this case the method throws an exception if the http call method completed successfully.
    // The expect method checks if the method throws an exception
    // The the method throws an exception as expected the testcase passss.

    test('throws exception if the http call is unsuccesfull', () async {
      final client = MockClient((req) async {
        return http.Response('Something went wrong', 404);
      });

      MedicineDataProvider dataProvider =
          MedicineDataProvider(httpClient: client);
      expect(await dataProvider.getAllMeMedicines(), throwsException);
    });
  });}