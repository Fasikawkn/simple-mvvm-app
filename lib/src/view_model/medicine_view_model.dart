import 'package:flutter/material.dart';
import 'package:simple_mvvm_app/src/model/apis/api_response.dart';
import 'package:simple_mvvm_app/src/model/model_objects/medicine.dart';
import 'package:simple_mvvm_app/src/model/repositories/medicine_repository.dart';

class MedicineViewModel extends ChangeNotifier {
  final MedicineRepository repository;
  MedicineViewModel({
    required this.repository,
  });
  Response _apiResponse = Response.initial("Empty Data");
  Response get response {
    return _apiResponse;
  }

  set response(Response response) {
    _apiResponse = response;
    notifyListeners();
  }

  Future getAllMedicines() async {
    response = Response.initial("fetching medicines");
    try {
      List<Medicine> _mediaList = await repository.getAllMedicines();
      response = Response.completed(_mediaList);
    } catch (e) {
      response = Response.error(e.toString());
    }
  }
}
