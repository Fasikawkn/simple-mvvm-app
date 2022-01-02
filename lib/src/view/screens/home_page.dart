import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_mvvm_app/src/model/apis/api_response.dart';
import 'package:simple_mvvm_app/src/model/model_objects/medicine.dart';
import 'package:simple_mvvm_app/src/view_model/auth_view_model.dart';
import 'package:simple_mvvm_app/src/view_model/db_provider.dart';
import 'package:simple_mvvm_app/src/view_model/medicine_view_model.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/mvvmapp/homepage';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // _getUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _getUser();
  }

  String _getGreetMessage(String username) {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,\n$username';
    }
    if (hour < 17) {
      return 'Good Afternoon, \n$username';
    }
    return 'Good Evening, \n$username';
  }

  String _getDate() {
    DateTime aDateTime = DateTime.now();
    var dateFormat = DateFormat.MMMMEEEEd().format(aDateTime);
    return dateFormat;
  }

  Widget _buildDateLabel() {
    return Center(
      child: Text(
        _getDate(),
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
    );
  }

  Widget _buildGreetingUser(UserProvider userProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: FutureBuilder<String>(
        future: userProvider.fetchAndSetData(),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            String userName = snapshots.data!;
            return Center(
              child: Text(
                _getGreetMessage(userName),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  // color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildMedicinesLabel() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Center(
        child: Text(
          "Medicines",
          style: TextStyle(fontSize: 18.0, color: Colors.lightBlue),
        ),
      ),
    );
  }

  Widget _buildMedicineList(List<Medicine> medicine) {
    return Container(
      padding: const EdgeInsets.symmetric(
          // horizontal: 20.0,
          ),
      child: Column(
          children: medicine
              .map((medicine) => Card(
                    child: ListTile(
                      title: Text(
                        medicine.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        medicine.strength,
                      ),
                      trailing: const Text('dose'),
                    ),
                  ))
              .toList()),
    );
  }

  late AuthenticationViewModel userModel;
  late UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    userModel = Provider.of<AuthenticationViewModel>(context);
    userProvider = Provider.of<UserProvider>(context);
    // userModel.fetchAndSetData();
    // debugPrint("User ${userModel.items}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("MVVM App"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await userProvider.deleteUser();
              await userModel.signout();
            },
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildDateLabel(),
            _buildGreetingUser(userProvider),
            _buildMedicinesLabel(),
            Consumer<MedicineViewModel>(
              builder: (context, value, child) {
                if (value.response.status == Status.laoding ||
                    value.response.status == Status.initial) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (value.response.status == Status.error) {
                  return Center(
                    child: Text(
                      value.response.message!,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                } else {
                  List<Medicine> _medicines = value.response.data;
                  return _buildMedicineList(_medicines);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
