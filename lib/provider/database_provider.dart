import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../helper/userdata.dart';

class DbProvider extends ChangeNotifier{
  List<UserData> _list=[];
  UnmodifiableListView<UserData> get userDataList => UnmodifiableListView(_list);
  final String userDataHiveBox="userdata-box";
  bool _showLoading=false;

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
    notifyListeners();
  }

  Future<void> addUserData(BuildContext context,UserData userData) async {
    Box<UserData> box = await Hive.openBox<UserData>(userDataHiveBox);
    await box.add(userData);
    _list.add(userData);
    _list = box.values.toList();

    if (kDebugMode) {
      print("Data Inserted Successfully");
    }
    Navigator.pop(context);
    notifyListeners();
  }

  Future<void> getUserData() async {
    showLoading=true;
    try
    {
      _list.clear();
      Box<UserData> box = await Hive.openBox<UserData>(userDataHiveBox);
      _list = box.values.toList();

      if (kDebugMode) {
        print("Get User Data Complete");
      }
    }catch(e)
    {
      if (kDebugMode) {
        print("Exception is  : $e");
      }}

    showLoading=false;
    notifyListeners();
  }

  Future<void> deleteUserData(UserData userData) async {
    Box<UserData> box = await Hive.openBox<UserData>(userDataHiveBox);
    await box.delete(userData.key);
    _list = box.values.toList();
    if (kDebugMode) {
      print("User data deleted");
    }
    notifyListeners();
  }
}