import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_mvvm_app/src/model/model_objects/medicine.dart';
import 'package:simple_mvvm_app/src/model/repositories/medicine_repository.dart';
import 'package:simple_mvvm_app/src/model/services/medicine_data_provider.dart';

import 'constants.dart';

class MockDataProvider extends Mock implements MedicineDataProvider {
  @override
  Future<List<dynamic>> getAllMeMedicines()  {
    return  Future.value(mockDynamicList);
  }
}

@GenerateMocks([MockDataProvider])
void main() {
  final mockDataProvider = MockDataProvider();
  final MedicineRepository repository =
      MedicineRepository(dataProvider: mockDataProvider);
  setUp(() {});
  tearDown(() {});

  // Get 
  test("get all medicines", () async {

    expect(await repository.getAllMedicines(), isA<List<Medicine>>());
  });
}
