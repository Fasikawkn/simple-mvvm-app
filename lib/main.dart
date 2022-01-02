import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_mvvm_app/src/model/repositories/medicine_repository.dart';
import 'package:simple_mvvm_app/src/model/services/medicine_data_provider.dart';
import 'package:simple_mvvm_app/src/view/screens/signin_page.dart';
import 'package:simple_mvvm_app/src/view_model/auth_view_model.dart';
import 'package:simple_mvvm_app/src/view_model/db_helper.dart';
import 'package:simple_mvvm_app/src/view_model/db_provider.dart';
import 'package:simple_mvvm_app/src/view_model/medicine_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:simple_mvvm_app/utils/routes.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  HttpOverrides.global = MyHttpOverrides();
  runApp(SimpleMVVMAPP());
}

class SimpleMVVMAPP extends StatelessWidget {
  SimpleMVVMAPP({Key? key}) : super(key: key);
  final MedicineRepository _medicineRepository = MedicineRepository(
    dataProvider: MedicineDataProvider(
      httpClient: http.Client(),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationViewModel>(
          create: (context) => AuthenticationViewModel(),
        ),
        ChangeNotifierProvider<MedicineViewModel>(
          create: (context) => MedicineViewModel(
            repository: _medicineRepository,
          )..getAllMedicines(),
        ),
        ChangeNotifierProvider<DBHelper>(
          create: (context) => DBHelper(),
        ),
        ChangeNotifierProxyProvider<DBHelper, UserProvider>(
          create: (context) => UserProvider(null),
          update: (context, db, previous) => UserProvider(
            db,
          ),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: LoginPage.routeName,
        onGenerateRoute: AppRoute.generateRoute,
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
