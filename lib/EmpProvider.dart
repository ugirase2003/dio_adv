import 'dart:convert';
import 'package:app/model/employee.dart'; // Import your Employee model
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class EmpProvider extends ChangeNotifier {
  List<Emp> emps = [];
  List<Emp> fetchedEmps = [];

  bool isLoading = false;
  bool loadMore = false; // Correct typo
  bool hasMore = true; // Initialize to true
  int page = 1;
  int pageSize = 10;
  Dio dio = Dio();

  fetchEmployee() async {
    isLoading = true;
    notifyListeners();
    page = 1; // Reset page to 1 for initial fetch
    hasMore = true; // Reset hasMore when fetching initial data
    try {
      Response resp = await dio.get(
          "http://10.0.2.2:8000/data?page=$page&pageSize=$pageSize"); // Correct URL
      fetchedEmps = (resp.data["data"] as List<dynamic>)
          .map((e) => Emp.fromJson(e))
          .toList();
      emps = fetchedEmps;
      hasMore = resp.data["hasMore"]; // Update hasMore after fetching
    } catch (e) {
      print("Error $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  fetchMore() async {
    if (loadMore || !hasMore) return;
    loadMore = true;
    notifyListeners();
    // await Future.delayed(Duration(seconds: 8));
    page++;
    try {
      Response resp = await dio.get(
          "http://10.0.2.2:3000/data?page=$page&pageSize=$pageSize"); // Correct URL
      fetchedEmps.addAll((resp.data["data"] as List<dynamic>)
          .map((e) => Emp.fromJson(e))
          .toList());
      emps.addAll((resp.data["data"] as List<dynamic>)
          .map((e) => Emp.fromJson(e))
          .toList());
      hasMore = resp.data["hasMore"];
    } catch (e) {
      print("Error $e");
    } finally {
      loadMore = false;
      notifyListeners();
    }
  }

  updateData(
    Emp emp,
  ) {
    final index = emps.indexWhere((element) => element.id == emp.id);
    // if (index != -1) {
    emps[index] = emp;
    notifyListeners();

    // } else {
    //   // Handle the case where the employee is not found (optional)
    //   print('Employee with ID ${emp.id} not found.');
    // }
  }

  srchData(String srchQuery, String filter) {
    emps = fetchedEmps;
    if (srchQuery.isEmpty) {
      notifyListeners();
      return;
    }

    srchQuery = srchQuery.toLowerCase();

    List<Emp> filteredEmps = emps.where((emp) {
      String empValue;

      switch (filter) {
        case 'name':
          empValue = emp.name.toLowerCase();
          break;
        case 'department':
          empValue = emp.department.toLowerCase();
          break;
        default:
          empValue = '${emp.name} ${emp.department}'.toLowerCase();
          break;
      }
      return empValue.contains(srchQuery);
    }).toList();

    // Sort
    switch (filter) {
      case 'name':
        filteredEmps.sort((emp1, emp2) => emp1.name.compareTo(emp2.name));
        break;
      case 'department':
        filteredEmps
            .sort((emp1, emp2) => emp1.department.compareTo(emp2.department));
        break;
    }

    emps = filteredEmps;
    notifyListeners();
  }
}
