import 'package:simple_mvvm_app/src/model/model_objects/medicine.dart';
import 'package:simple_mvvm_app/src/model/services/medicine_data_provider.dart';

class MedicineRepository {
  final MedicineDataProvider dataProvider;
  MedicineRepository({required this.dataProvider});
  
  // fetch all the medicines
  Future<List<Medicine>> getAllMedicines() async {
    final _jsonResponse = await dataProvider.getAllMeMedicines();
    final _medicineResponse = _jsonResponse as List;
    return _medicineResponse
        .map((medicineJson) => Medicine.fromJson(medicineJson))
        .toList();
  }
}
