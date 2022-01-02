import 'package:flutter_test/flutter_test.dart';
import 'package:simple_mvvm_app/src/model/model_objects/medicine.dart';

void main() {
  group("Testing Medicine object", ()  {
    Medicine? medicine;
    setUp(() {
      medicine = Medicine(name: "Abebe", dose: "kebede", strength: "bbbb");
    });

    // in this test cases we test individual attributes.
    // The expect method checks individual attributes with individual
    // if the the expected is true the test case passes the test
    // else it will fail.
    test("Check individual values", () async {

      // begin testing
      expect(medicine!.dose, isA<String>());
      expect(medicine!.name, "Abebe");
      expect(medicine!.dose, isNotNull);
    });
  });
}
