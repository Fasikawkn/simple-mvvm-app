import 'package:flutter/foundation.dart';
import 'package:simple_mvvm_app/src/view_model/db_helper.dart';

class UserProvider with ChangeNotifier {
  final DBHelper? dbHelper;
  final tableName = 'user';

  UserProvider(this.dbHelper) {
    if (dbHelper != null) {}
  }

  Future insertUser(Map<String, dynamic> user) async {
    if (dbHelper!.db != null) {
      await dbHelper!.insert(
        tableName,
        user,
      );
    }
  }

  Future deleteUser() async {
    if (dbHelper!.db != null) {
      await dbHelper!.delete(tableName);
    }
  }

  Future<String> fetchAndSetData() async {
    if (dbHelper!.db != null) {
      // do not execute if db is not instantiate
      final dataList = await dbHelper!.getData(tableName);
      return dataList[0]['username'];
    } else {
      return '';
    }
    
  }
}
